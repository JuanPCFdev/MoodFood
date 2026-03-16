import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_user.dart';

// ─── Abstract contract ───────────────────────────────────────────────────────

abstract class FirebaseAuthDatasource {
  Future<AppUser> signIn({required String email, required String password});
  Future<AppUser> register({required String email, required String password});
  Future<void> signOut();
  Future<AppUser> signInWithGoogle();
  AppUser? getCurrentUser();
}

// ─── Firebase implementation ─────────────────────────────────────────────────

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDatasourceImpl(this._auth, this._googleSignIn);

  // Maps a Firebase User to the domain AppUser entity.
  // Domain layer must never import firebase_auth — this is the boundary.
  AppUser _toAppUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  // Maps FirebaseAuthException error codes to Spanish user-facing messages.
  AuthFailure _mapFirebaseError(FirebaseAuthException e) {
    const messages = {
      'email-already-in-use':
          'El correo ya está registrado. ¿Querés iniciar sesión?',
      'invalid-email': 'El formato del correo no es válido',
      'weak-password': 'La contraseña debe tener al menos 6 caracteres',
      'wrong-password': 'Email o contraseña incorrectos',
      'user-not-found': 'Email o contraseña incorrectos',
      'too-many-requests': 'Demasiados intentos. Intentá de nuevo más tarde',
      'network-request-failed': 'Error de conexión. Verificá tu internet',
      'google-sign-in-failed':
          'Error al iniciar sesión con Google. Verificá tu conexión',
    };

    final message =
        messages[e.code] ?? 'Error inesperado. Intentá de nuevo';
    return AuthFailure(message, technicalDetail: e.code);
  }

  @override
  Future<AppUser> signIn(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toAppUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (e) {
      throw AuthFailure(
        'Error inesperado. Intentá de nuevo',
        technicalDetail: e.toString(),
      );
    }
  }

  @override
  Future<AppUser> register(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toAppUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (e) {
      throw AuthFailure(
        'Error inesperado. Intentá de nuevo',
        technicalDetail: e.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from both Firebase and Google (order matters — Firebase first).
      // Calling GoogleSignIn.signOut() when signed in with email/password is a no-op.
      await _auth.signOut();
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (e) {
      throw AuthFailure(
        'Error al cerrar sesión. Intentá de nuevo',
        technicalDetail: e.toString(),
      );
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      // User cancelled the Google picker — signal silently with a typed failure.
      if (googleUser == null) {
        throw const GoogleSignInCancelledFailure();
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return _toAppUser(userCredential.user!);
    } on AppFailure {
      // Re-throw our own failures (GoogleSignInCancelledFailure, AuthFailure)
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (e) {
      throw AuthFailure(
        'Error al iniciar sesión con Google. Verificá tu conexión',
        technicalDetail: e.toString(),
      );
    }
  }

  @override
  AppUser? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _toAppUser(user);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';

// ─── Auth State (sealed) ──────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AppUser user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ─── AuthNotifier ─────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUsecase _signIn;
  final RegisterUsecase _register;
  final SignOutUsecase _signOut;
  final GoogleSignInUsecase _googleSignIn;

  AuthNotifier({
    required SignInUsecase signIn,
    required RegisterUsecase register,
    required SignOutUsecase signOut,
    required GoogleSignInUsecase googleSignIn,
  })  : _signIn = signIn,
        _register = register,
        _signOut = signOut,
        _googleSignIn = googleSignIn,
        super(const AuthInitial());

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final user = await _signIn.execute(email: email, password: password);
      state = AuthAuthenticated(user);
    } on AuthFailure catch (f) {
      state = AuthError(f.message);
    } on AppFailure catch (f) {
      state = AuthError(f.message);
    } catch (e) {
      state = const AuthError('Error inesperado. Intentá de nuevo');
    }
  }

  Future<void> register({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final user = await _register.execute(email: email, password: password);
      state = AuthAuthenticated(user);
    } on AuthFailure catch (f) {
      state = AuthError(f.message);
    } on AppFailure catch (f) {
      state = AuthError(f.message);
    } catch (e) {
      state = const AuthError('Error inesperado. Intentá de nuevo');
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      final user = await _googleSignIn.execute();
      state = AuthAuthenticated(user);
    } on GoogleSignInCancelledFailure {
      // User cancelled — stay silent, return to previous state (unauthenticated)
      state = const AuthUnauthenticated();
    } on AuthFailure catch (f) {
      state = AuthError(f.message);
    } on AppFailure catch (f) {
      state = AuthError(f.message);
    } catch (e) {
      state = const AuthError('Error al iniciar sesión con Google. Verificá tu conexión');
    }
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    try {
      await _signOut.execute();
      state = const AuthUnauthenticated();
    } on AuthFailure catch (f) {
      state = AuthError(f.message);
    } on AppFailure catch (f) {
      state = AuthError(f.message);
    } catch (e) {
      state = const AuthError('Error al cerrar sesión. Intentá de nuevo');
    }
  }

  /// Clears any current [AuthError] back to [AuthUnauthenticated].
  /// Called by UI on each keystroke so the error dismisses as the user types.
  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

/// Single source of truth for auth state used by GoRouter redirect.
/// Maps Firebase User? to AppUser? — returns null when unauthenticated.
final authStateStreamProvider = StreamProvider<AppUser?>((ref) {
  return FirebaseAuth.instance.authStateChanges().map((firebaseUser) {
    if (firebaseUser == null) return null;
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  });
});

/// Main auth notifier — drives login/register/logout flows and their UI states.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    signIn: ref.read(signInUsecaseProvider),
    register: ref.read(registerUsecaseProvider),
    signOut: ref.read(signOutUsecaseProvider),
    googleSignIn: ref.read(googleSignInUsecaseProvider),
  );
});

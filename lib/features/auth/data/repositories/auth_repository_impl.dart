import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

// ─── DI providers ─────────────────────────────────────────────────────────────

final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  return FirebaseAuthDatasourceImpl(
    FirebaseAuth.instance,
    GoogleSignIn(scopes: ['email']),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(firebaseAuthDatasourceProvider));
});

// ─── Implementation ───────────────────────────────────────────────────────────

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<AppUser> signIn(
      {required String email, required String password}) async {
    return _datasource.signIn(email: email, password: password);
  }

  @override
  Future<AppUser> register(
      {required String email, required String password}) async {
    return _datasource.register(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return _datasource.signOut();
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    return _datasource.signInWithGoogle();
  }

  @override
  AppUser? getCurrentUser() {
    return _datasource.getCurrentUser();
  }
}

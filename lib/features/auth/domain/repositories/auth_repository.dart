import '../entities/app_user.dart';

// Contrato abstracto — la UI nunca conoce la implementación
abstract class AuthRepository {
  Future<AppUser> signIn({required String email, required String password});
  Future<AppUser> register({required String email, required String password});
  Future<void> signOut();
  Future<AppUser> signInWithGoogle();
  AppUser? getCurrentUser();
}

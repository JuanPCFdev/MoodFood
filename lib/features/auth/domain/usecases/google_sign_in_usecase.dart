import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final googleSignInUsecaseProvider = Provider<GoogleSignInUsecase>((ref) {
  return GoogleSignInUsecase(ref.read(authRepositoryProvider));
});

class GoogleSignInUsecase {
  final AuthRepository _repository;

  GoogleSignInUsecase(this._repository);

  Future<AppUser> execute() {
    return _repository.signInWithGoogle();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final signInUsecaseProvider = Provider<SignInUsecase>((ref) {
  return SignInUsecase(ref.read(authRepositoryProvider));
});

class SignInUsecase {
  final AuthRepository _repository;

  SignInUsecase(this._repository);

  Future<AppUser> execute({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}

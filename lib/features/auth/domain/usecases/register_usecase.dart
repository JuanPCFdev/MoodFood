import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  return RegisterUsecase(ref.read(authRepositoryProvider));
});

class RegisterUsecase {
  final AuthRepository _repository;

  RegisterUsecase(this._repository);

  Future<AppUser> execute({required String email, required String password}) {
    return _repository.register(email: email, password: password);
  }
}

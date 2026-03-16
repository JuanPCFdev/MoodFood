import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final signOutUsecaseProvider = Provider<SignOutUsecase>((ref) {
  return SignOutUsecase(ref.read(authRepositoryProvider));
});

class SignOutUsecase {
  final AuthRepository _repository;

  SignOutUsecase(this._repository);

  Future<void> execute() {
    return _repository.signOut();
  }
}

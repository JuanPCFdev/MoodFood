import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  return GetCurrentUserUsecase(ref.read(authRepositoryProvider));
});

class GetCurrentUserUsecase {
  final AuthRepository _repository;

  GetCurrentUserUsecase(this._repository);

  AppUser? execute() {
    return _repository.getCurrentUser();
  }
}

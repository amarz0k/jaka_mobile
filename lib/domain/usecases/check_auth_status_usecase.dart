import 'package:chat_app/domain/repositories/auth_repository.dart';

class CheckAuthStatusUsecase {
  final AuthRepository _authRepository;

  CheckAuthStatusUsecase(this._authRepository);

  Future<bool> call() async {
    return await _authRepository.isUserAuthenticated();
  }
}
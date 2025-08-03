import 'package:chat_app/domain/repositories/auth_repository.dart';

class SignInWithGoogleUsecase {
  final AuthRepository _authRepository;

  SignInWithGoogleUsecase(this._authRepository);

  Future<void> call() async {
    return await _authRepository.signInWithGoogle();
  }
}

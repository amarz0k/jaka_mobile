import 'package:chat_app/domain/repositories/auth_repository.dart';

class SignUpWithEmailUsecase {
  final AuthRepository _authRepository;

  SignUpWithEmailUsecase(this._authRepository);

  Future<void> call(String em, String pass, String name) async {
    return await _authRepository.signUpWithEmailAndPassword(em, pass, name);
  }
}
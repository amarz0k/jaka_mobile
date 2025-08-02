import 'package:chat_app/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository? _authRepository;

  SignInWithGoogle(this._authRepository);

  Future<void> call() async {
    return await _authRepository!.signInWithGoogle();
  }
}

import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository _authRepository;

  SignInWithGoogle(this._authRepository);

  Future<UserEntity> call() async {
    return await _authRepository.signInWithGoogle();
  }
}

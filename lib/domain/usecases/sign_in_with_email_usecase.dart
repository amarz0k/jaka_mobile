import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';

class SignInWithEmailUsecase {
  final AuthRepository _authRepository;

  SignInWithEmailUsecase(this._authRepository);

  Future<UserEntity> call(String em, String pass) async {
    return await _authRepository.signInWithEmailAndPassword(em, pass);
  }
}

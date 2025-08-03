import 'package:chat_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithGoogle();
}

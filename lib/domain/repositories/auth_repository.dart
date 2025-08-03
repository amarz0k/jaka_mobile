import 'package:chat_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithGoogle();

  Future<UserEntity> signInWithEmailAndPassword(String em, String pass);

  Future<UserEntity> signUpWithEmailAndPassword(String em, String pass, String name);

  Future<bool> isUserAuthenticated();

  Future<void> signOut();
}

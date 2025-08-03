import 'package:chat_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signInWithGoogle();

  Future<void> signInWithEmailAndPassword(String em, String pass);

  Future<UserEntity> signUpWithEmailAndPassword(
    String em,
    String pass,
    String name,
  );

  Future<bool> isUserAuthenticated();

  Future<void> signOut();
}

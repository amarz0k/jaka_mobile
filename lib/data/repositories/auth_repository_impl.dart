import 'package:chat_app/data/datasources/remote/google_auth_data_source.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleAuthDataSource _googleAuthDataSource;

  AuthRepositoryImpl(this._googleAuthDataSource);

  @override
  Future<UserEntity> signInWithGoogle() async {
    final userModel = await _googleAuthDataSource.signInWithGoogle();
    return userModel.toEntity();
  }
}

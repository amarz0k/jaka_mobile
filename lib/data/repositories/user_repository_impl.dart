import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  late final HiveService _hiveService;

  @override
  Future<void> saveUserToLocalStorage(UserEntity user) async{
    await _hiveService.openBox('user');
  }

}

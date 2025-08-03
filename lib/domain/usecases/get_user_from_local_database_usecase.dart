import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class GetUserFromLocalDatabaseUsecase {
  final UserRepository _userRepository;

  GetUserFromLocalDatabaseUsecase(this._userRepository);

  Future<UserEntity> call() async {
    return await _userRepository.getUserFromLocalStorage();
  }
}

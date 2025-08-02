import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class SaveUser {
  final UserRepository _userRepository;

  SaveUser(this._userRepository);

  Future<void> call(UserEntity user) async {
    return await _userRepository.saveUserToLocalStorage(user);
  }
}

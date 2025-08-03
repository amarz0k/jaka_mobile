import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class SaveUserToLocalUsecase {
  final UserRepository _userRepository;

  SaveUserToLocalUsecase(this._userRepository);

  Future<void> call(UserEntity user) async {
    return await _userRepository.saveUserToLocalStorage(user);
  }
}

import 'package:chat_app/domain/repositories/user_repository.dart';

class UpdateUserNameUsecase {
  final UserRepository _userRepository;

  UpdateUserNameUsecase(this._userRepository);

  Future<void> call(String name) async {
    await _userRepository.updateUserName(name);
  }
}

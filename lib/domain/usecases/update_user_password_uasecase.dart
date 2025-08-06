import 'package:chat_app/domain/repositories/user_repository.dart';

class UpdateUserPasswordUsecase {
  final UserRepository _userRepository;

  UpdateUserPasswordUsecase(this._userRepository);

  Future<void> call(String password) async {
    await _userRepository.updateUserPassword(password);
  }
}
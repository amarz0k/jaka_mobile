import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class SaveUserToRealtimeDatabaseUsecase {
  final UserRepository _userRepository;

  SaveUserToRealtimeDatabaseUsecase(this._userRepository);

  Future<void> call(UserModel user) async {
    return await _userRepository.saveUserToRealtimeDatabase(user);
  }
}

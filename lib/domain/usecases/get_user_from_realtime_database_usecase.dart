import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class GetUserFromRealtimeDatabaseUsecase {
  UserRepository _userRepository;

  GetUserFromRealtimeDatabaseUsecase(this._userRepository);

  Future<UserModel> call() async {
    return await _userRepository.getUserFromRealtimeDatabase();
  }
  
}
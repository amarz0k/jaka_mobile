import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

class GetUserByIdUsecase {
  final UserRepository _userRepository;

  GetUserByIdUsecase(this._userRepository);

  Future<UserModel?> call(String id) async {
    return await _userRepository.getUserById(id);
  }
}

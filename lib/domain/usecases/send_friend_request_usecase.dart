import 'package:chat_app/domain/repositories/user_repository.dart';

class SendFriendRequestUsecase {
  final UserRepository _userRepository;

  SendFriendRequestUsecase(this._userRepository);

  Future<void> call(String id) async {
    await _userRepository.sendFriendRequest(id);
  }
}
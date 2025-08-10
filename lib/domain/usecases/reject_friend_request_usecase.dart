import 'package:chat_app/domain/repositories/user_repository.dart';

class RejectFriendRequestUsecase {
  final UserRepository _userRepository;

  RejectFriendRequestUsecase(this._userRepository);

  Future<void> call(String id) async {
    await _userRepository.rejectFriendRequest(id);
  }
}
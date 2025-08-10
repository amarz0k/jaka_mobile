import 'package:chat_app/domain/repositories/user_repository.dart';

class AcceptFriendRequestUsecase {
  final UserRepository _userRepository;

  AcceptFriendRequestUsecase(this._userRepository);

  Future<void> call(String id) async {
    await _userRepository.acceptFriendRequest(id);
  }
}
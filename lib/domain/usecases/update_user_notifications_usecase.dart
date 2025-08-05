import 'package:chat_app/domain/repositories/user_repository.dart';

class UpdateUserNotificationsUsecase {
    final UserRepository _userRepository;

    UpdateUserNotificationsUsecase(this._userRepository);

    Future<void> call(bool value) async {
        return await _userRepository.updateUserNotifications(value);
    }
}
import 'package:chat_app/domain/repositories/user_repository.dart';

class UpdateUserProfileUsecase {
  final UserRepository _userRepository;

  UpdateUserProfileUsecase(this._userRepository);

  Future<void> call(String? name, String? photoUrl) async {
    await _userRepository.updateUserProfile(name, photoUrl);
  }
}
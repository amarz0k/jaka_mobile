import 'package:chat_app/domain/repositories/user_repository.dart';

class GetIncomingRequestsStreamUsecase {
  final UserRepository _userRepository;

  GetIncomingRequestsStreamUsecase(this._userRepository);

  Stream<List<Map<String, String>>> call() {
    return _userRepository.getIncomingRequestsStream();
  }
}

import 'package:chat_app/domain/repositories/user_repository.dart';

class GetOutgoingRequestsStreamUsecase {
  final UserRepository _userRepository;

  GetOutgoingRequestsStreamUsecase(this._userRepository);

  Stream<List<Map<String, String>>> call() {
    return _userRepository.getOutgoingRequestsStream();
  }
}

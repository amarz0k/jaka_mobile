import 'package:chat_app/domain/repositories/user_repository.dart';

class GetIncomingRequestsUsecase {
   final UserRepository _userRepository;

   GetIncomingRequestsUsecase(this._userRepository);

   Future<List<Map<String, dynamic>>> call() async {
     return await _userRepository.getIncomingRequests();
   }
}
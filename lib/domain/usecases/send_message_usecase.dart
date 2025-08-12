import 'package:chat_app/domain/repositories/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository _chatRepository;
  SendMessageUsecase(this._chatRepository);
  Future<void> call(String message, String senderId, String receiverId) async {
    await _chatRepository.sendMessage(message, senderId, receiverId);
  }
}

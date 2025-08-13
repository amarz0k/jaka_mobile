import 'package:chat_app/domain/repositories/chat_repository.dart';

class RemoveAllMessagesBetweenUsecase {
  final ChatRepository _chatRepository;

  RemoveAllMessagesBetweenUsecase(this._chatRepository);

  Future<void> call(String senderId, String receiverId) async {
    await _chatRepository.removeAllMessagesBetween(senderId, receiverId);
  }
}
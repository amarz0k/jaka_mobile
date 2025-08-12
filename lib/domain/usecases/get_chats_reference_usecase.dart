import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class GetChatsReferenceUsecase {
  final ChatRepository _chatRepository;
  GetChatsReferenceUsecase(this._chatRepository);
  Future<DatabaseReference> call() async {
    return _chatRepository.getChatReference();
  }
}

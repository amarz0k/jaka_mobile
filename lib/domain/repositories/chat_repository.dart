import 'package:firebase_database/firebase_database.dart';

abstract class ChatRepository {
  Future<void> sendMessage(String message, String senderId, String receiverId);
  Future<DatabaseReference> getChatReference();
}
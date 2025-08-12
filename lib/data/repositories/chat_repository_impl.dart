import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/repositories/user_repository_impl.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRepositoryImpl implements ChatRepository {
  final UserRepositoryImpl _userRepository;

  ChatRepositoryImpl(this._userRepository);

  Future<Map<String, bool>> checkExsistingChat(
    String senderId,
    String receiverId,
  ) async {
    final chatId1 =
        '${_userRepository.createSafeFirebasePath(senderId)}_${_userRepository.createSafeFirebasePath(receiverId)}';
    final chatId2 =
        '${_userRepository.createSafeFirebasePath(receiverId)}_${_userRepository.createSafeFirebasePath(senderId)}';

    final chatPath1 = 'chats/$chatId1/messages';

    final chatPath2 = 'chats/$chatId2/messages';

    final chatsDBRef1 = getIt<FirebaseDatabase>().ref().child(chatPath1);
    final chatsDBRef2 = getIt<FirebaseDatabase>().ref().child(chatPath2);

    final chat1 = await chatsDBRef1.get();
    final chat2 = await chatsDBRef2.get();

    if (!chat1.exists && !chat2.exists) {
      return {'chat1': false, 'chat2': false};
    }

    if (chat1.exists) {
      return {'chat1': true, 'chat2': false};
    }

    if (chat2.exists) {
      return {'chat1': false, 'chat2': true};
    }
    return {'chat1': false, 'chat2': false};
  }

  @override
  Future<void> sendMessage(
    String message,
    String senderId,
    String receiverId,
  ) async {
    try {
      // Check if user is trying to send message to themselves
      if (senderId == receiverId) {
        throw Exception('You cannot send message to yourself');
      }

      final chatId1 =
          '${_userRepository.createSafeFirebasePath(senderId)}_${_userRepository.createSafeFirebasePath(receiverId)}';
      final chatId2 =
          '${_userRepository.createSafeFirebasePath(receiverId)}_${_userRepository.createSafeFirebasePath(senderId)}';

      final chatPath1 = 'chats/$chatId1/messages';

      final chatPath2 = 'chats/$chatId2/messages';

      final chatsDBRef1 = getIt<FirebaseDatabase>().ref().child(chatPath1);
      final chatsDBRef2 = getIt<FirebaseDatabase>().ref().child(chatPath2);

      final Map<String, bool> exsistingChat = await checkExsistingChat(
        senderId,
        receiverId,
      );

      if (exsistingChat['chat1'] == true) {
        await chatsDBRef1.push().set({
          'senderId': senderId,
          'receiverId': receiverId,
          'text': message,
          'sentAt': DateTime.now().toIso8601String(),
        });
      } else if (exsistingChat['chat2'] == true) {
        await chatsDBRef2.push().set({
          'senderId': senderId,
          'receiverId': receiverId,
          'text': message,
          'sentAt': DateTime.now().toIso8601String(),
        });
      } else {
        // No existing chat, create new one using chat1 format
        await chatsDBRef1.push().set({
          'senderId': senderId,
          'receiverId': receiverId,
          'text': message,
          'sentAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DatabaseReference> getChatReference() async {
    try {
      final chatsDBRef = getIt<FirebaseDatabase>().ref().child('chats');
      return chatsDBRef;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

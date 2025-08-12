import 'dart:async';
import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/domain/usecases/get_chats_reference_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/home/conversation/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final SendMessageUsecase _sendMessageUsecase;
  final GetChatsReferenceUsecase _getChatsReferenceUsecase;
  StreamSubscription? _chatMessagesSubscription;

  ConversationCubit({required ChatRepository chatRepository})
    : _sendMessageUsecase = getIt<SendMessageUsecase>(),
      _getChatsReferenceUsecase = getIt<GetChatsReferenceUsecase>(),
      super(ConversationInitialState());

  Future<void> sendMessage(String message, String receiverId) async {
    try {
      final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
          .call();

      log(
        "sendMessage: currentUser: ${currentUser.id}, receiverId: $receiverId",
      );

      if (currentUser.id == receiverId) {
        log("Error: Trying to send message to self!");
        emit(
          ConversationFailureState(
            error: "You cannot send a message to yourself",
          ),
        );
        return;
      }

      await _sendMessageUsecase.call(message, currentUser.id, receiverId);
      // Don't emit a success state with message, let the stream update handle it
      // The messages will be updated automatically through the stream listener
    } catch (e) {
      log("sendMessage error: $e");
      emit(ConversationFailureState(error: e.toString()));
    }
  }

  Future<void> loadMessages(String friendId) async {
    emit(ConversaitonLoadingState());
    try {
      final currentUserModel = await getIt<GetUserFromRealtimeDatabaseUsecase>()
          .call();
      final currentUser = currentUserModel.toEntity();
      log(
        "loadMessages: current user id: ${currentUser.id}, friendId: $friendId",
      );

      // Get the base chats reference
      final chatsDBRef = await _getChatsReferenceUsecase.call();

      // Listen to the entire chats node and filter for our conversation
      _chatMessagesSubscription = chatsDBRef.onValue.listen((event) {
        _processMessages(currentUser, event.snapshot.value, friendId);
      });
    } catch (e) {
      log("loadMessages error: $e");
      emit(ConversationFailureState(error: e.toString()));
    }
  }

  Future<void> _processMessages(
    UserEntity currentUser,
    dynamic event,
    String friendId,
  ) async {
    if (event == null) {
      emit(ConversationLoadedState(messages: [], currentUser: currentUser));
      return;
    }

    try {
      final allChats = event as Map<dynamic, dynamic>;
      final List<MessageEntity> messages = [];

      log(
        "_processMessages: Processing chats data with keys: ${allChats.keys.toList()}",
      );

      // Look through all chat rooms to find messages for this conversation
      allChats.forEach((chatRoomKey, chatRoomData) {
        if (chatRoomData != null && chatRoomData is Map) {
          final chatRoom = Map<String, dynamic>.from(chatRoomData);

          // Check if this chat room has a messages node
          if (chatRoom.containsKey('messages') && chatRoom['messages'] is Map) {
            final messagesData = Map<String, dynamic>.from(
              chatRoom['messages'] as Map,
            );

            log(
              "_processMessages: Found messages in chat room $chatRoomKey with ${messagesData.length} messages",
            );

            // Process each message in this chat room
            messagesData.forEach((messageKey, messageData) {
              if (messageData != null && messageData is Map) {
                final message = Map<String, dynamic>.from(messageData);

                final String senderId = message['senderId'] as String? ?? '';
                final String receiverId =
                    message['receiverId'] as String? ?? '';

                log(
                  "_processMessages: Checking message - senderId: $senderId, receiverId: $receiverId",
                );
                log(
                  "_processMessages: Looking for - currentUserId: ${currentUser.id}, friendId: $friendId",
                );

                // Check if this message is part of the current conversation
                if ((senderId == currentUser.id && receiverId == friendId) ||
                    (senderId == friendId && receiverId == currentUser.id)) {
                  final messageEntity = MessageEntity(
                    senderId: senderId,
                    receiverId: receiverId,
                    text: message['text'] as String? ?? '',
                    sentAt: message['sentAt'] as String? ?? '',
                  );
                  messages.add(messageEntity);
                  log("_processMessages: Added message: ${messageEntity.text}");
                }
              }
            });
          }
        }
      });

      // Sort messages by timestamp if available
      messages.sort((a, b) {
        try {
          final aTime = DateTime.tryParse(a.sentAt) ?? DateTime.now();
          final bTime = DateTime.tryParse(b.sentAt) ?? DateTime.now();
          return aTime.compareTo(bTime);
        } catch (e) {
          return 0;
        }
      });

      log(
        "_processMessages: Final result - Found ${messages.length} messages for conversation",
      );
      emit(
        ConversationLoadedState(messages: messages, currentUser: currentUser),
      );
    } catch (e) {
      log("_processMessages error: $e");
      emit(ConversationFailureState(error: "Failed to load messages: $e"));
    }
  }

  @override
  Future<void> close() async {
    try {
      await _chatMessagesSubscription?.cancel();
      await super.close();
    } catch (e) {
      log("Error closing ConversationCubit: $e");
    }
  }
}

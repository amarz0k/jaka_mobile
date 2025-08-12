import 'dart:async';
import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/usecases/get_chats_reference_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/home/conversation/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final SendMessageUsecase _sendMessageUsecase;
  final GetChatsReferenceUsecase _getChatsReferenceUsecase;
  StreamSubscription? _chatMessagesSubscription;

  ConversationCubit({required SendMessageUsecase sendMessageUsecase})
    : _sendMessageUsecase = sendMessageUsecase,
      _getChatsReferenceUsecase = getIt<GetChatsReferenceUsecase>(),
      super(ConversationInitialState());

  Future<void> sendMessage(
    String message,
    String senderId,
    String receiverId,
  ) async {
    emit(ConversaitonLoadingState());
    try {
      await _sendMessageUsecase.call(message, senderId, receiverId);
      emit(
        ConversationLoadedState(successMessage: "Message sent successfully"),
      );
    } catch (e) {
      emit(FailureState(error: e.toString()));
    }
  }

  Future<void> loadMessages(String friendId) async {
    emit(ConversaitonLoadingState());
    final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
        .call();

    log(
      "_loadMessages: current user id: ${currentUser.id}, friendId: $friendId",
    );
    try {
      final chatsDBRef = await _getChatsReferenceUsecase.call();
      _chatMessagesSubscription = chatsDBRef.onValue.listen((event) {
        _processMessages(event.snapshot.value, friendId);
      });
    } catch (e) {
      emit(FailureState(error: e.toString()));
    }
  }

  Future<void> _processMessages(dynamic data, String friendId) async {
    if (data == null) {
      return;
    }

    final allChats = data as Map<dynamic, dynamic>;
    final List<MessageEntity> messages = [];

    // Separate incoming and outgoing requests
    allChats.forEach((key, value) {
      final Map<String, dynamic> chat = Map<String, dynamic>.from(value as Map);

      if (chat['senderId'] == friendId || chat['receiverId'] == friendId) {
        final message = MessageEntity(
          senderId: chat['senderId'] as String,
          receiverId: chat['receiverId'] as String,
          text: chat['text'] as String,
          sentAt: chat['sentAt'] as String,
        );
        messages.add(message);
      }
    });
  }

  @override
  Future<void> close() async {
    try {
      await super.close();
    } catch (e) {
      emit(FailureState(error: e.toString()));
    }
  }
}

import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/entities/user_entity.dart';

class ConversationState {}

class ConversaitonLoadingState extends ConversationState {}

class ConversationInitialState extends ConversationState {}

class ConversationLoadedState extends ConversationState {
  final List<MessageEntity>? messages;
  final String? successMessage;
  final String? error;
  final UserEntity? currentUser;

  ConversationLoadedState({this.messages, this.successMessage, this.error, this.currentUser});

  ConversationLoadedState copyWith({
    List<MessageEntity>? messages,
    String? successMessage,
    String? error,
    UserEntity? currentUser,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return ConversationLoadedState(
      messages: messages ?? this.messages,
      successMessage: clearMessage
          ? null
          : (successMessage ?? this.successMessage),
      error: clearError ? null : (error ?? this.error),
      currentUser: currentUser ?? this.currentUser,
    );
  }

  ConversationLoadedState clearMessage() {
    return copyWith(clearMessage: true, clearError: true);
  }
}

class  ConversationFailureState extends ConversationState {
  final String? error;

   ConversationFailureState({required this.error});
}

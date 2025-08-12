import 'package:chat_app/domain/entities/message_entity.dart';

class ConversationState {}

class ConversaitonLoadingState extends ConversationState {}

class ConversationInitialState extends ConversationState {}

class ConversationLoadedState extends ConversationState {
  final List<MessageEntity>? messages;
  final String? successMessage;
  final String? error;

  ConversationLoadedState({this.messages, this.successMessage, this.error});

  ConversationLoadedState copyWith({
    List<MessageEntity>? messages,
    String? successMessage,
    String? error,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return ConversationLoadedState(
      messages: messages ?? this.messages,
      successMessage: clearMessage
          ? null
          : (successMessage ?? this.successMessage),
      error: clearError ? null : (error ?? this.error),
    );
  }

  ConversationLoadedState clearMessage() {
    return copyWith(clearMessage: true, clearError: true);
  }
}

class FailureState extends ConversationState {
  final String? error;

  FailureState({required this.error});
}

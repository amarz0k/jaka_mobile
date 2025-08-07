import 'package:chat_app/domain/entities/user_entity.dart';

class UserDataState {}

class LoadingState extends UserDataState {}

class InitialState extends UserDataState {}

class UserDataLoadedState extends UserDataState {
  final UserEntity user;
  final List<Map<String, String>>? incomingRequests;
  final String? message; // For success messages
  final String? error; // For error messages

  UserDataLoadedState({
    required this.user, 
    this.incomingRequests,
    this.message,
    this.error,
  });

  UserDataLoadedState copyWith({
    UserEntity? user,
    List<Map<String, String>>? incomingRequests,
    String? message,
    String? error,
  }) {
    return UserDataLoadedState(
      user: user ?? this.user,
      incomingRequests: incomingRequests ?? this.incomingRequests,
      message: message,
      error: error,
    );
  }

  // Helper methods
  UserDataLoadedState clearMessage() {
    return copyWith(message: null, error: null);
  }
}

class IncomingRequestsLoadedState extends UserDataState {
  final List<Map<String, String>> incomingRequests;

  IncomingRequestsLoadedState({required this.incomingRequests});
}

class SuccessState extends UserDataState {
  final String? message;

  SuccessState({this.message});
}

class FailureState extends UserDataState {
  final String? error;

  FailureState({required this.error});
}

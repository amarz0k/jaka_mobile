import 'package:chat_app/domain/entities/friend_entity.dart';
import 'package:chat_app/domain/entities/user_entity.dart';

class UserDataState {}

class LoadingState extends UserDataState {}

class InitialState extends UserDataState {}

class UserDataLoadedState extends UserDataState {
  final UserEntity user;
  final List<FriendEntity>? incomingRequests;
  final List<FriendEntity>? outgoingRequests;
  final List<FriendEntity>? friends;
  final String? message; // For success messages
  final String? error; // For error messages

  UserDataLoadedState({
    required this.user,
    this.incomingRequests,
    this.outgoingRequests,
    this.friends,
    this.message,
    this.error,
  });

  UserDataLoadedState copyWith({
    UserEntity? user,
    List<FriendEntity>? incomingRequests,
    List<FriendEntity>? outgoingRequests,
    List<FriendEntity>? friends,
    String? message,
    String? error,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return UserDataLoadedState(
      user: user ?? this.user,
      incomingRequests: incomingRequests ?? this.incomingRequests,
      outgoingRequests: outgoingRequests ?? this.outgoingRequests,
      friends: friends ?? this.friends,
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
    );
  }

  UserDataLoadedState clearMessage() {
    return copyWith(clearMessage: true, clearError: true);
  }
}

class SuccessState extends UserDataState {
  final String? message;

  SuccessState({this.message});
}

class FailureState extends UserDataState {
  final String? error;

  FailureState({required this.error});
}

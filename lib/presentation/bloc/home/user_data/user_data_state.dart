import 'package:chat_app/domain/entities/user_entity.dart';

class UserDataState {}

class LoadingState extends UserDataState {}

class InitialState extends UserDataState {}

class LoadedState extends UserDataState {
  final UserEntity user;

  LoadedState({required this.user});
}

class SuccessState extends UserDataState {
  final String? message;

  SuccessState({this.message});
}

class FailureState extends UserDataState {
  final String? error;

  FailureState({required this.error});
}

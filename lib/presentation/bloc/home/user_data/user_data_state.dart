import 'package:chat_app/domain/entities/user_entity.dart';

class UserDataState {}

class LoadingState extends UserDataState {}

class InitialState extends UserDataState {}

class SuccessState extends UserDataState {
  final UserEntity user;

  SuccessState({required this.user});
}

class FailureState extends UserDataState {
  final String? error;

  FailureState({required this.error});
}

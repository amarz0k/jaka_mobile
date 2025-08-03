import 'package:chat_app/domain/entities/user_entity.dart';

class LoginState {}

class AuthLoadingState extends LoginState {}

class AuthInitialState extends LoginState {}

class AuthSuccessState extends LoginState {
  final UserEntity user;

  AuthSuccessState({required this.user});
}

class AuthFailureState extends LoginState {
  final String? error;

  AuthFailureState({required this.error});
}

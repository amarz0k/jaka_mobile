import 'package:chat_app/domain/entities/user_entity.dart';

class SignUpState {}

class AuthLoadingState extends SignUpState {}

class AuthInitialState extends SignUpState {}

class AuthSuccessState extends SignUpState {
  final UserEntity user;

  AuthSuccessState({required this.user});
}

class AuthFailureState extends SignUpState {
  final String? error;

  AuthFailureState({required this.error});
}

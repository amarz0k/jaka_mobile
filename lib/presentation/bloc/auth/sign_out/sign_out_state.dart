import 'package:chat_app/domain/entities/user_entity.dart';

class SignOutState {}

class AuthLoadingState extends SignOutState {}

class AuthInitialState extends SignOutState {}

class AuthSuccessState extends SignOutState {
  final UserEntity user;

  AuthSuccessState({required this.user});
}

class AuthFailureState extends SignOutState {
  final String? error;

  AuthFailureState({required this.error});
}

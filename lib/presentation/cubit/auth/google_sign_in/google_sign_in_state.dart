import 'package:chat_app/domain/entities/user_entity.dart';

class GoogleSignInState {}

class AuthLoadingState extends GoogleSignInState {}

class AuthInitialState extends GoogleSignInState {}

class AuthSuccessState extends GoogleSignInState {
  final UserEntity user;

  AuthSuccessState({required this.user});
}

class AuthFailureState extends GoogleSignInState {
  final String? error;

  AuthFailureState({required this.error});
}

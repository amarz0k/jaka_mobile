import 'package:chat_app/domain/entities/user_entity.dart';

class AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthInitialState extends AuthStates {

}

class AuthSuccessState extends AuthStates {
  final UserEntity user;

  AuthSuccessState({required this.user});
}

class AuthFailureState extends AuthStates {
  final String? error;

  AuthFailureState({required this.error});
}

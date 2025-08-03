import 'package:chat_app/domain/entities/user_entity.dart';

class AuthStates {}

class AuthLoading extends AuthStates {}

class AuthInitial extends AuthStates {}

class AuthSuccess extends AuthStates {
  final UserEntity? user;

  AuthSuccess({this.user});
}

class AuthFailure extends AuthStates {
  final String? error;

  AuthFailure({required this.error});
}

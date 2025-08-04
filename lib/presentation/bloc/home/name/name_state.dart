import 'package:chat_app/domain/entities/user_entity.dart';

class NameState {}

class LoadingState extends NameState {}

class InitialState extends NameState {}

class SuccessState extends NameState {
  final UserEntity user;

  SuccessState({required this.user});
}

class FailureState extends NameState {
  final String? error;

  FailureState({required this.error});
}

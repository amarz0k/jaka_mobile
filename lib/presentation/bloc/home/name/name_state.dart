import 'package:chat_app/domain/entities/user_entity.dart';

class NameState {}

class NameLoadingState extends NameState {}

class NameInitialState extends NameState {}

class InternetConnectionState extends NameState {
  final bool isConnected;

  InternetConnectionState({required this.isConnected});
}

class NameSuccessState extends NameState {
  final UserEntity user;

  NameSuccessState({required this.user});
}

class NameFailureState extends NameState {
  final String? error;

  NameFailureState({required this.error});
}

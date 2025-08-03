class LoginState {}

class AuthLoadingState extends LoginState {}

class AuthInitialState extends LoginState {}

class AuthSuccessState extends LoginState {
  AuthSuccessState();
}

class AuthFailureState extends LoginState {
  final String? error;

  AuthFailureState({required this.error});
}

class SignUpState {}

class AuthLoadingState extends SignUpState {}

class AuthInitialState extends SignUpState {}

class AuthSuccessState extends SignUpState {}

class AuthFailureState extends SignUpState {
  final String? error;

  AuthFailureState({required this.error});
}

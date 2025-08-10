class SignUpState {}

class AuthLoadingState extends SignUpState {}

class AuthInitialState extends SignUpState {}

class AuthSuccessState extends SignUpState {}

class AuthFailureState extends SignUpState {
  final String? error;

  AuthFailureState({required this.error});
}

class AuthDisplayNameValidationState extends SignUpState {
  final String? error;

  AuthDisplayNameValidationState({required this.error});
}

class AuthEmailValidationState extends SignUpState {
  final String? error;

  AuthEmailValidationState({required this.error});
}

class AuthPasswordValidationState extends SignUpState {
  final String? error;

  AuthPasswordValidationState({required this.error});
}

class AuthPasswordConfirmValidationState extends SignUpState {
  final String? error;

  AuthPasswordConfirmValidationState({required this.error});
}

class SignOutState {}

class AuthLoadingState extends SignOutState {}

class AuthInitialState extends SignOutState {}

class AuthSuccessState extends SignOutState {}

class AuthFailureState extends SignOutState {
  final String? error;

  AuthFailureState({required this.error});
}

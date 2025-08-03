class GoogleSignInState {}

class AuthLoadingState extends GoogleSignInState {}

class AuthInitialState extends GoogleSignInState {}

class AuthSuccessState extends GoogleSignInState {}

class AuthFailureState extends GoogleSignInState {
  final String? error;

  AuthFailureState({required this.error});
}

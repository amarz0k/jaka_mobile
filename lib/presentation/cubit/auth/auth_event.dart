class AuthEvent {}

class AuthSignInWithGoogleEvent extends AuthEvent {}

class AuthSignInWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInWithEmailAndPasswordEvent({required this.email, required this.password});
}

class AuthSignOutEvent extends AuthEvent {}

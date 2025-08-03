class LoginEvent {}

class AuthSignInWithEmailAndPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  AuthSignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });
}


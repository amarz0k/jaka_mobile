class SignUpEvent {}

class AuthSignUpWithEmailAndPasswordEvent extends SignUpEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUpWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthValidateDisplayNameEvent extends SignUpEvent {
  final String displayName;

  AuthValidateDisplayNameEvent({required this.displayName});
}

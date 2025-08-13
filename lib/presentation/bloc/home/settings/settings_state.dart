class SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsSuccessState extends SettingsState {
  final String? message;

  SettingsSuccessState({this.message});
}

class SettingsFailureState extends SettingsState {
  final String? error;

  SettingsFailureState({required this.error});
}

class SettingsPasswordSetValidateState extends SettingsState {
  final String? error;

  SettingsPasswordSetValidateState({required this.error});
}

class SettingsPasswordConfirmValidateState extends SettingsState {
  final String? error;

  SettingsPasswordConfirmValidateState({required this.error});
}

// Add new combined validation state
class SettingsPasswordValidationState extends SettingsState {
  final String? setPasswordError;
  final String? confirmPasswordError;

  SettingsPasswordValidationState({
    this.setPasswordError,
    this.confirmPasswordError,
  });
}

// Add new state for change password validation
class SettingsChangePasswordValidationState extends SettingsState {
  final String? oldPasswordError;
  final String? newPasswordError;
  final String? confirmNewPasswordError;

  SettingsChangePasswordValidationState({
    this.oldPasswordError,
    this.newPasswordError,
    this.confirmNewPasswordError,
  });
}

// Add new state for change name validation
class SettingsChangeNameValidationState extends SettingsState {
  final String? newNameError;

  SettingsChangeNameValidationState({
    this.newNameError,
  });
}

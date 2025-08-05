class SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsSuccessState extends SettingsState {
  SettingsSuccessState();
}

class SettingsFailureState extends SettingsState {
  final String? error;

  SettingsFailureState({required this.error});
}

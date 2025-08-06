import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/update_user_notifications_usecase.dart';
import 'package:chat_app/domain/usecases/update_user_password_uasecase.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UpdateUserNotificationsUsecase _updateUserNotificationsUsecase;
  final UpdateUserPasswordUsecase _updateUserPasswordUsecase;

  // Add fields to track validation states
  String? _setPasswordError;
  String? _confirmPasswordError;

  // Add fields for change password validation
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmNewPasswordError;

  SettingsCubit({required UserRepository userRepository})
    : _updateUserNotificationsUsecase = getIt<UpdateUserNotificationsUsecase>(),
      _updateUserPasswordUsecase = getIt<UpdateUserPasswordUsecase>(),
      super(SettingsInitialState());

  Future<void> updateUserNotifications(bool value) async {
    emit(SettingsLoadingState());
    try {
      await _updateUserNotificationsUsecase.call(value);
      emit(SettingsSuccessState());
    } catch (e) {
      emit(SettingsFailureState(error: e.toString()));
    }
  }

  Future<void> updateUserPassword(String password) async {
    emit(SettingsLoadingState());
    try {
      await _updateUserPasswordUsecase.call(password);
      emit(SettingsSuccessState(message: "Password updated successfully"));
    } catch (e) {
      emit(SettingsFailureState(error: e.toString()));
    }
  }

  void checkSetPassword(String password) {
    if (password.length < 8) {
      _setPasswordError = "Password must be at least 8 characters";
    } else {
      _setPasswordError = null;
    }

    // Emit a combined state that includes both validation results
    emit(
      SettingsPasswordValidationState(
        setPasswordError: _setPasswordError,
        confirmPasswordError: _confirmPasswordError,
      ),
    );
  }

  void checkConfirmPassword(String password, String confirmPassword) {
    // Only validate if confirm password is not empty
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = null; // Don't show error for empty field
    } else if (confirmPassword.length < 8) {
      _confirmPasswordError = "Password must be at least 8 characters";
    } else if (password != confirmPassword) {
      _confirmPasswordError = "Passwords do not match";
    } else {
      _confirmPasswordError = null;
    }

    // Emit a combined state that includes both validation results
    emit(
      SettingsPasswordValidationState(
        setPasswordError: _setPasswordError,
        confirmPasswordError: _confirmPasswordError,
      ),
    );
  }

  // New methods for change password functionality
  void checkOldPassword(String oldPassword, String currentPassword) {
    if (oldPassword.isEmpty) {
      _oldPasswordError = null; // Don't show error for empty field
    } else if (oldPassword != currentPassword) {
      _oldPasswordError = "Incorrect current password";
    } else {
      _oldPasswordError = null;
    }

    emit(
      SettingsChangePasswordValidationState(
        oldPasswordError: _oldPasswordError,
        newPasswordError: _newPasswordError,
        confirmNewPasswordError: _confirmNewPasswordError,
      ),
    );
  }

  void checkNewPassword(String newPassword) {
    if (newPassword.isEmpty) {
      _newPasswordError = null; // Don't show error for empty field
    } else if (newPassword.length < 8) {
      _newPasswordError = "Password must be at least 8 characters";
    } else {
      _newPasswordError = null;
    }

    emit(
      SettingsChangePasswordValidationState(
        oldPasswordError: _oldPasswordError,
        newPasswordError: _newPasswordError,
        confirmNewPasswordError: _confirmNewPasswordError,
      ),
    );
  }

  void checkConfirmNewPassword(String newPassword, String confirmNewPassword) {
    if (confirmNewPassword.isEmpty) {
      _confirmNewPasswordError = null; // Don't show error for empty field
    } else if (confirmNewPassword.length < 8) {
      _confirmNewPasswordError = "Password must be at least 8 characters";
    } else if (newPassword != confirmNewPassword) {
      _confirmNewPasswordError = "Passwords do not match";
    } else {
      _confirmNewPasswordError = null;
    }

    emit(
      SettingsChangePasswordValidationState(
        oldPasswordError: _oldPasswordError,
        newPasswordError: _newPasswordError,
        confirmNewPasswordError: _confirmNewPasswordError,
      ),
    );
  }
}

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_cubit.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_state.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_cubit.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_state.dart';
import 'package:chat_app/presentation/widgets/custom_text_field.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

Future<dynamic> changePassordBottomSheet(BuildContext context) {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          bool isOldPasswordValid = false;
          bool isNewPasswordValid = false;
          bool isConfirmNewPasswordValid = false;

          if (state is SettingsChangePasswordValidationState) {
            isOldPasswordValid =
                _oldPasswordController.text.isNotEmpty &&
                state.oldPasswordError == null;
            isNewPasswordValid =
                _newPasswordController.text.isNotEmpty &&
                state.newPasswordError == null;
            isConfirmNewPasswordValid =
                _confirmNewPasswordController.text.isNotEmpty &&
                state.confirmNewPasswordError == null;
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    label: "Current Password",
                    hintText: "Enter current password",
                    onChanged: (value) {
                      // Get current user's password from context
                      final currentUser = context.read<UserDataCubit>().state;
                      String currentPassword = "";
                      if (currentUser is UserDataLoadedState) {
                        currentPassword = currentUser.user.password ?? "";
                      }

                      context.read<SettingsCubit>().checkOldPassword(
                        value,
                        currentPassword,
                      );
                    },
                    textEditingController: _oldPasswordController,
                    errorText: state is SettingsChangePasswordValidationState
                        ? state.oldPasswordError
                        : null,
                    isValid: isOldPasswordValid,
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: "New Password",
                    hintText: "Enter new password",
                    onChanged: (value) {
                      context.read<SettingsCubit>().checkNewPassword(value);
                      // Also validate confirm password when new password changes
                      if (_confirmNewPasswordController.text.isNotEmpty) {
                        context.read<SettingsCubit>().checkConfirmNewPassword(
                          value,
                          _confirmNewPasswordController.text,
                        );
                      }
                    },
                    textEditingController: _newPasswordController,
                    errorText: state is SettingsChangePasswordValidationState
                        ? state.newPasswordError
                        : null,
                    isValid: isNewPasswordValid,
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: "Confirm New Password",
                    hintText: "Re-enter new password",
                    onChanged: (value) {
                      context.read<SettingsCubit>().checkConfirmNewPassword(
                        _newPasswordController.text,
                        value,
                      );
                    },
                    textEditingController: _confirmNewPasswordController,
                    errorText: state is SettingsChangePasswordValidationState
                        ? state.confirmNewPasswordError
                        : null,
                    isValid: isConfirmNewPasswordValid,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (isOldPasswordValid &&
                                  isNewPasswordValid &&
                                  isConfirmNewPasswordValid) {
                                context
                                    .read<SettingsCubit>()
                                    .updateUserPassword(
                                      _newPasswordController.text,
                                    );
                                Navigator.of(context).pop();
                                showToastification(
                                  context,
                                  "Password changed successfully",
                                  Colors.green,
                                  ToastificationType.success,
                                );
                              } else {
                                showToastification(
                                  context,
                                  "Please fix password validation errors",
                                  Colors.red,
                                  ToastificationType.error,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              overlayColor: Colors.transparent,
                              elevation: 2,
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

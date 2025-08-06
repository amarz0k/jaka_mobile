import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_cubit.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_state.dart';
import 'package:chat_app/presentation/widgets/custom_text_field.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

Future<dynamic> setPasswordBottomSheet(BuildContext context) {
  final TextEditingController _setPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          bool isSetPasswordValid = false;
          bool isConfirmPasswordValid = false;

          if (state is SettingsPasswordValidationState) {
            isSetPasswordValid = state.setPasswordError == null;
            // Only show confirm password as valid if it's not empty and has no error
            isConfirmPasswordValid =
                _confirmPasswordController.text.isNotEmpty &&
                state.confirmPasswordError == null;
          }

          return Container(
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
                  "Set Password",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  label: "Set Password",
                  hintText: "Enter password",
                  onChanged: (value) {
                    context.read<SettingsCubit>().checkSetPassword(value);
                    // Also validate confirm password when set password changes
                    if (_confirmPasswordController.text.isNotEmpty) {
                      context.read<SettingsCubit>().checkConfirmPassword(
                        value,
                        _confirmPasswordController.text,
                      );
                    }
                  },
                  textEditingController: _setPasswordController,
                  errorText: state is SettingsPasswordValidationState
                      ? state.setPasswordError
                      : null,
                  isValid: isSetPasswordValid,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: "Confirm Password",
                  hintText: "Confirm password",
                  onChanged: (value) {
                    context.read<SettingsCubit>().checkConfirmPassword(
                      _setPasswordController.text,
                      value,
                    );
                  },
                  textEditingController: _confirmPasswordController,
                  errorText: state is SettingsPasswordValidationState
                      ? state.confirmPasswordError
                      : null,
                  isValid: isConfirmPasswordValid,
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
                            if (isSetPasswordValid && isConfirmPasswordValid) {
                              context.read<SettingsCubit>().updateUserPassword(
                                _setPasswordController.text,
                              );
                              Navigator.of(context).pop();
                              showToastification(
                                context,
                                "Password updated successfully",
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
                            "Set Password",
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
          );
        },
      );
    },
  );
}

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_cubit.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_state.dart';
import 'package:chat_app/presentation/widgets/custom_text_field.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

Future<dynamic> changeNameBottomSheet(BuildContext context) {
  final TextEditingController _newNameController = TextEditingController();

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          bool isNewNameValid = false;

          if (state is SettingsChangeNameValidationState) {
            isNewNameValid =
                _newNameController.text.isNotEmpty &&
                state.newNameError == null;
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6,
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
                    "Change Name",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    label: "New Name",
                    hintText: "Enter new name",
                    onChanged: (value) {
                      context.read<SettingsCubit>().checkNewName(value);
                    },
                    textEditingController: _newNameController,
                    errorText: state is SettingsChangeNameValidationState
                        ? state.newNameError
                        : null,
                    isValid: isNewNameValid,
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
                              if (isNewNameValid) {
                                context
                                    .read<SettingsCubit>()
                                    .updateUserName(
                                      _newNameController.text,
                                    );
                                Navigator.of(context).pop();
                                showToastification(
                                  context,
                                  "Name changed successfully",
                                  Colors.green,
                                  ToastificationType.success,
                                );
                              } else {
                                showToastification(
                                  context,
                                  "Please fix name validation errors",
                                  Colors.red,
                                  ToastificationType.error,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              overlayColor: Colors.transparent,
                              elevation: 2,
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Change Name",
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

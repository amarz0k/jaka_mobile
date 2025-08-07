import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_icons.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_bloc.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_event.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_state.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_cubit.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_cubit.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_state.dart';
import 'package:chat_app/presentation/widgets/change_password_bottom_sheet.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:chat_app/presentation/widgets/set_password_bottom_sheet.dart';
import 'package:chat_app/presentation/widgets/setting_tab.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 35,
            color: AppColors.lightBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: BlocBuilder<UserDataCubit, UserDataState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FailureState) {
            return Center(child: Text('Failed to load user info'));
          }

          if (state is UserDataLoadedState) {
            final String name =
                '${state.user.name.split(' ').first} ${state.user.name.split(' ')[1]}';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      imageDetector(
                        state.user.photoUrl!,
                        60,
                        isCircle: true,
                        radius: 100,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: AppColors.lightBlack,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      BlocListener<SignOutBloc, SignOutState>(
                        listener: (context, state) {
                          if (state is AuthFailureState) {
                            showToastification(
                              context,
                              "Signout Failed",
                              Colors.red,
                              ToastificationType.error,
                            );
                          }
                          if (state is AuthSuccessState) {
                            showToastification(
                              context,
                              "Signout Successful",
                              Colors.green,
                              ToastificationType.success,
                            );
                            context.router.replace(const HomeRoute());
                          }
                        },
                        child: IconButton(
                          onPressed: () {
                            context.read<SignOutBloc>().add(AuthSignOutEvent());
                          },
                          style: IconButton.styleFrom(iconSize: 30),
                          icon: Icon(Icons.logout, color: Colors.red),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 45),

                  Divider(height: 1),

                  SettingTab(
                    icon: AppIcons.person,
                    label: 'User Profile',
                    onTap: () {
                      context.router.push(const UserProfileRoute());
                    },
                  ),
                  Divider(height: 1),

                  SettingTab(
                    icon: AppIcons.lock,
                    label: state.user.password == ""
                        ? "Set Password"
                        : 'Change Passowrd',
                    onTap: () {
                      state.user.password == ""
                          ? setPasswordBottomSheet(context)
                          : changePassordBottomSheet(context);
                    },
                  ),
                  Divider(height: 1),

                  SettingTab(icon: AppIcons.faq, label: 'FAQs', onTap: () {}),

                  Divider(height: 1),

                  SettingTab(
                    icon: AppIcons.notification,
                    label: 'Notifications',
                    isSwitch: true,
                    value: state.user.notifications,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updateUserNotifications(
                        value,
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

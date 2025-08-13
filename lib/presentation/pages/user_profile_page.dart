import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_cubit.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_state.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_cubit.dart';
import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/presentation/widgets/change_password_bottom_sheet.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:chat_app/presentation/widgets/change_name_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "User Settings",
            style: TextStyle(
              fontSize: 28,
              color: AppColors.lightBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
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
            final photoUrl = state.user.photoUrl!;
            final name = state.user.name;
            final id = state.user.id;
            final email = state.user.email;
            final notifications = state.user.notifications;
            final hasPassword = (state.user.password ?? "").isNotEmpty;

            return Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: imageDetector(photoUrl, 200, isCircle: true),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightBlack,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      id,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: id));
                        showToastification(
                          context,
                          'Copied to clipboard',
                          Colors.green,
                          ToastificationType.success,
                        );
                      },
                      child: Icon(
                        Icons.copy,
                        color: AppColors.lightBlack,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Name
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  subtitle: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    color: AppColors.lightBlack,
                    onPressed: () {
                      changeNameBottomSheet(context);
                    },
                  ),
                ),

                // Email
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(email),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    color: AppColors.lightBlack,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: email));
                      showToastification(
                        context,
                        'Email copied',
                        Colors.green,
                        ToastificationType.success,
                      );
                    },
                  ),
                ),

                // Password status
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Password'),
                  subtitle: Text(hasPassword ? 'Set' : 'Not set'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    color: AppColors.lightBlack,
                    onPressed: () {
                      changePassordBottomSheet(context);
                    }
                  )
                ),

                // Notifications status
                ListTile(
                  leading: const Icon(Icons.notifications_none),
                  title: const Text('Notifications'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: notifications
                          ? Colors.green.withOpacity(0.12)
                          : Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      notifications ? 'On' : 'Off',
                      style: TextStyle(
                        color: notifications ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      ),
    );
  }
}

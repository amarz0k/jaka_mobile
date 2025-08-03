import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_cubit.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_event.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_state.dart';
import 'package:chat_app/presentation/bloc/home/name/name_cubit.dart';
import 'package:chat_app/presentation/bloc/home/name/name_event.dart';
import 'package:chat_app/presentation/bloc/home/name/name_state.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch CheckUserDataEvent when the page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NameCubit>().add(CheckUserDataEvent());
    });

    return BlocConsumer<NameCubit, NameState>(
      listenWhen: (prev, curr) =>
          curr is InternetConnectionState && curr.isConnected,

      listener: (context, state) {
        if (state is InternetConnectionState && state.isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Back online"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Back offline"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final String name;
        if (state is NameLoadingState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is NameFailureState) {
          showToastification(
            context,
            "Signin Failed",
            Colors.red,
            ToastificationType.error,
          );
        }

        if (state is NameSuccessState) {
          name = state.user.name;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.lightBlack,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search, size: 22),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.person, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Center(
              child: BlocBuilder<SignOutCubit, SignOutState>(
                builder: (context, state) {
                  if (state is AuthInitialState) {
                    context.router.replace(const HomeRoute());
                  }
                  if (state is AuthFailureState) {
                    showToastification(
                      context,
                      "Signin Failed",
                      Colors.red,
                      ToastificationType.error,
                    );
                  }
                  if (state is AuthLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<SignOutCubit>().add(AuthSignOutEvent());
                    },
                    child: Text("Sign out"),
                  );
                },
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

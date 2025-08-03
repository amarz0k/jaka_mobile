import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:chat_app/presentation/cubit/auth/auth_event.dart';
import 'package:chat_app/presentation/cubit/auth/auth_state.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthCubit, AuthStates>(
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
                context.read<AuthCubit>().add(AuthSignOutEvent());
              },
              child: Text("Sign out"),
            );
          },
        ),
      ),
    );
  }
}

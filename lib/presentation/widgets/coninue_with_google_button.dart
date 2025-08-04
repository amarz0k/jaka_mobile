import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_images.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/bloc/auth/google_sign_in/google_sign_in_bloc.dart';
import 'package:chat_app/presentation/bloc/auth/google_sign_in/google_sign_in_event.dart';
import 'package:chat_app/presentation/bloc/auth/google_sign_in/google_sign_in_state.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

BlocListener<GoogleSignInBloc, GoogleSignInState> continueWithGoogleButton() {
  return BlocListener<GoogleSignInBloc, GoogleSignInState>(
    listener: (context, state) {
      if (state is AuthFailureState) {
        showToastification(
          context,
          "Signin Failed",
          Colors.red,
          ToastificationType.error,
        );
      }
      if (state is AuthSuccessState) {
        showToastification(
          context,
          "Loged in Successfully",
          Colors.green,
          ToastificationType.success,
        );
        context.router.replace(const HomeRoute());
      }
    },
    child: BlocBuilder<GoogleSignInBloc, GoogleSignInState>(
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ElevatedButton(
          onPressed: () {
            context.read<GoogleSignInBloc>().add(AuthSignInWithGoogleEvent());
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 60),
            overlayColor: AppColors.lightBlack,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.primaryColor),
            ),
            elevation: 2,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageDetector(AppImages.googleLogo, size: 35),
              const SizedBox(width: 10),
              Text(
                'Continue with Google',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

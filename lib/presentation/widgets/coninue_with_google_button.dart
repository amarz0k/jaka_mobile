import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_images.dart';
import 'package:chat_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:chat_app/presentation/cubit/auth/auth_event.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ElevatedButton continueWithGoogleButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.read<AuthCubit>().add(AuthSignInWithGoogle());
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
}

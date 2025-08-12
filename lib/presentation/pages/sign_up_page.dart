import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_images.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_bloc.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_event.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_state.dart';
import 'package:chat_app/presentation/widgets/coninue_with_google_button.dart';
import 'package:chat_app/presentation/widgets/custom_text_form_field.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static final _formKey = GlobalKey<FormState>();
  static TextEditingController _emailController = TextEditingController();
  static TextEditingController _passwordController = TextEditingController();
  static TextEditingController _confirmPasswordController =
      TextEditingController();
  static TextEditingController _displayNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(AppImages.loginBg),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            bottom: 0, // Changed from height to bottom
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                // Added SingleChildScrollView
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 25,
                  right: 25,
                  bottom: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Get Started',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: BlocListener<SignUpBloc, SignUpState>(
                        listener: (context, state) {
                          if (state is AuthFailureState) {
                            showToastification(
                              context,
                              "Signup Failed",
                              Colors.red,
                              ToastificationType.error,
                            );
                          }
                          if (state is AuthSuccessState) {
                            showToastification(
                              context,
                              "Signup Successful",
                              Colors.green,
                              ToastificationType.success,
                            );
                            context.router.replace(const LoginRoute());
                          }
                        },
                        child: Column(
                          children: [
                            customFormField(
                              labelText: 'Display name',
                              hintText: 'Enter your display name',
                              controller: _displayNameController,
                            ),
                            const SizedBox(height: 40),
                            customFormField(
                              labelText: 'Email',
                              hintText: 'Enter your email address',
                              controller: _emailController,
                            ),
                            const SizedBox(height: 40),
                            customFormField(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              controller: _passwordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 40),
                            customFormField(
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your password',
                              controller: _confirmPasswordController,
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        context.read<SignUpBloc>().add(
                          AuthSignUpWithEmailAndPasswordEvent(
                            name: _displayNameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        minimumSize: const Size(double.infinity, 60),
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                        const Text(
                          "Sign up with",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    continueWithGoogleButton(),
                    const SizedBox(height: 50),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.router.replace(const LoginRoute());
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

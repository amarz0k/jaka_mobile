import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_images.dart';
import 'package:chat_app/presentation/cubit/auth/sign_up/sign_up_cubit.dart';
import 'package:chat_app/presentation/cubit/auth/sign_up/sign_up_event.dart';
import 'package:chat_app/presentation/cubit/auth/sign_up/sign_up_state.dart';
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

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    TextEditingController _displayNameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    String? _displayNameValidator(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Display name cannot be empty';
      }
      if (value.length < 3) {
        return 'Display name must be at least 3 characters';
      }
      if (value.length > 20) {
        return 'Display name must be at most 20 characters';
      }
      final displayNameRegex = RegExp(r'^[a-zA-Z0-9]+$');
      if (!displayNameRegex.hasMatch(value)) {
        return 'Display name can only contain letters and numbers';
      }
      return null;
    }

    String? _emailValidator(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Email cannot be empty';
      }
      final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
      return null;
    }

    String? _passwordValidator(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Password cannot be empty';
      }
      if (value.length < 8) {
        return 'Password must be at least 8 characters';
      }
      if (value.length > 32) {
        return 'Password must be at most 32 characters';
      }
      final upperCaseRegex = RegExp(r'[A-Z]');
      final lowerCaseRegex = RegExp(r'[a-z]');
      final digitRegex = RegExp(r'[0-9]');
      final specialCharRegex = RegExp(r'[!@#\$%\^&\*]');
      if (!upperCaseRegex.hasMatch(value)) {
        return 'Password must contain at least one uppercase letter';
      }
      if (!lowerCaseRegex.hasMatch(value)) {
        return 'Password must contain at least one lowercase letter';
      }
      if (!digitRegex.hasMatch(value)) {
        return 'Password must contain at least one number';
      }
      if (!specialCharRegex.hasMatch(value)) {
        return 'Password must contain at least one special character';
      }
      return null;
    }

    String? _passwordConfirmValidator(String? value) {
      if (value != _passwordController.text) {
        return 'Passwords do not match';
      }
      return null;
    }

    String? _validateDisplayName(String? value) {
      return null;
    }

    String? _validatePassword(String? value) {
      return null;
    }

    String? _validateEmail(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Email cannot be empty';
      }
      return null;
    }

    String? _validatePasswordConfirm(String? value) {
      if (value != _passwordController.text) {
        return 'Passwords do not match';
      }
      return null;
    }

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
            top: MediaQuery.of(context).size.height * 0.2,
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
                  bottom: 20, // Increased bottom padding
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
                      child: BlocListener<SignUpCubit, SignUpState>(
                        listener: (context, state) {
                          if (state is AuthSuccessState) {
                            showToastification(
                              context,
                              "Signup Successful",
                              Colors.green,
                              ToastificationType.success,
                            );
                            context.router.replace(const HomeRoute());
                          }
                        },
                        child: Column(
                          children: [
                            customFormField(
                              labelText: 'Display name',
                              hintText: 'Enter your display name',
                              controller: _displayNameController,
                              validator: _displayNameValidator,
                              onChanged: _validateDisplayName,
                              obscureText:
                                  false, // Display name should not be obscured
                            ),
                            const SizedBox(height: 40),
                            customFormField(
                              labelText: 'Email',
                              hintText: 'Enter your email address',
                              controller: _emailController,
                              validator: _emailValidator,
                              onChanged: _validateEmail,
                              obscureText:
                                  false, // Email should not be obscured
                            ),
                            const SizedBox(height: 40),
                            customFormField(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              controller: _passwordController,
                              validator:
                                  _passwordValidator, // Fixed: was using _passwordConfirmValidator
                              onChanged: _validatePassword,
                              obscureText: true, // Password should be obscured
                            ),
                            const SizedBox(height: 40),
                            customFormField(
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your password',
                              controller: _confirmPasswordController,
                              validator: _passwordConfirmValidator,
                              onChanged: _validatePasswordConfirm,
                              obscureText: true, // Password should be obscured
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        context.read<SignUpCubit>().add(
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

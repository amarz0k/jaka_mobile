import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_images.dart';
import 'package:chat_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:chat_app/presentation/cubit/auth/auth_state.dart';
import 'package:chat_app/presentation/widgets/coninue_with_google_button.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    String? _passwordValidator(String? value) {
      final passReg = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})',
      );
      if (!passReg.hasMatch(value!)) {
        return 'Password must contain at least 8 characters';
      }
      return null;
    }

    String? _emailValidator(String? value) {
      final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      );
      if (!emailRegex.hasMatch(value!)) {
        return 'Please enter a valid email address';
      }
      return null;
    }

    String? _validatePassword(String? value) {
      if (value != _passwordController.text) {
        return 'Passwords do not match';
      }
      return null;
    }

    String? _validateEmail(String? value) {
      if (value != _emailController.text) {
        return 'Emails do not match';
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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 25,
                  right: 25,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            validator: _emailValidator,
                            onChanged: _validateEmail,
                            autocorrect: false,
                            cursorColor: AppColors.primaryColor,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1.5,
                              ),
                              hintText: 'Enter your email address',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: _passwordController,
                            validator: _passwordValidator,
                            onChanged: _validatePassword,
                            obscureText: true,
                            autocorrect: false,
                            cursorColor: AppColors.primaryColor,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Forget password?",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        context.router.replace(const HomeRoute());
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
                        "Sign In",
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
                          "Sign in with",
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

                    BlocListener<AuthCubit, AuthStates>(
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
                      child: BlocBuilder<AuthCubit, AuthStates>(
                        builder: (context, state) {
                          if (state is AuthLoadingState) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return continueWithGoogleButton(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 50),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: "Sign up",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.router.replace(const SignUpRoute());
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

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "User Profile",
          style: TextStyle(
            fontSize: 30,
            color: AppColors.lightBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(),
    );
  }
}

import 'package:chat_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomChatTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String value)? onChanged;
  final bool isSendButtonVisible;
  final Function()? onSendPress;
  final double? borderRadius;
  const CustomChatTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.onChanged,
    this.isSendButtonVisible = false,
    this.onSendPress,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // Increase this value for more height
      child: TextField(
        controller: textEditingController,
        onChanged: onChanged,
        obscureText: false,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: AppColors.primaryColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ), // Add vertical padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          suffixIconColor: Colors.white,
          suffixIcon: isSendButtonVisible
              ? IconButton(onPressed: onSendPress, icon: Icon(Icons.send))
              : null,
        ),
      ),
    );
  }
}

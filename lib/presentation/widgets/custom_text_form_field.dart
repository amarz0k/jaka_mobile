import 'package:chat_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

TextFormField customFormField({
  required TextEditingController controller,
  String? Function(String? value)? validator,
  Function(String? value)? onChanged,
  required String labelText,
  required String hintText,
  bool obscureText = false,
  String? errorText,
  bool? isValid,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    onChanged: onChanged,
    obscureText: obscureText,
    autocorrect: false,
    cursorColor: AppColors.primaryColor,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.black54,
        fontSize: 18,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black26, fontSize: 16),
      errorText: errorText,
      errorStyle: TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isValid == true ? Colors.green : AppColors.primaryColor,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isValid == true ? Colors.green : Colors.grey,
          width: isValid == true ? 2 : 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: isValid != null
          ? Icon(
              isValid ? Icons.check_circle : Icons.error,
              color: isValid ? Colors.green : Colors.red,
              size: 20,
            )
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}

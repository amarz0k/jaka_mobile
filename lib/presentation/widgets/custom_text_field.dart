import 'package:chat_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final String? errorText;
  final Function(String value)? onChanged;
  final bool? isValid;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.textEditingController,
    required this.errorText,
    this.onChanged,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onChanged: onChanged,
      obscureText: true,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black54,
          fontSize: 18,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
        hintText: hintText,
        errorText: errorText,
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

        suffixIcon: isValid == true
            ? Icon(Icons.check_circle, color: Colors.green, size: 20)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

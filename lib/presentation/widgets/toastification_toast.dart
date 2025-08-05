import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToastification(
  BuildContext context,
  String message,
  Color color,
  ToastificationType type,
) {
  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.fillColored,
    title: Text(message),
    icon: const Icon(Icons.error),
    primaryColor: color,
    foregroundColor: Colors.white,
    closeOnClick: true,
    autoCloseDuration: const Duration(seconds: 2),
  );
}

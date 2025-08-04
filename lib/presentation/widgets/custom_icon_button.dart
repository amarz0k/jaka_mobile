import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final double size;
  final Color? iconColor;
  final Color borderColor;
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomIconButton({
    super.key,
    required this.size,
    this.iconColor,
    required this.borderColor,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: iconColor),
      ),
    );
  }
}

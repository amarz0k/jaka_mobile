import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final double? size;
  final Color? iconColor;
  final Color borderColor;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool? isIcon;
  final Widget? widget;

  const CustomIconButton({
    super.key,
    this.size,
    this.iconColor,
    required this.borderColor,
    this.icon,
    this.onPressed,
    this.isIcon,
    this.widget,
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
      child: isIcon == true
          ? InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(100),
              child: widget,
            )
          : IconButton(
              onPressed: onPressed,
              icon: Icon(icon, size: 22, color: iconColor),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget imageDetector(
  String logo,
  double size, {
  bool isCircle = false,
  double radius = 0,
  String fit = "cover",
}) {
  if (isCircle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageDetector(logo, size),
    );
  }
  if (logo.endsWith('.svg')) {
    if (logo.startsWith('http')) {
      return SvgPicture.network(logo, width: size, height: size);
    } else {
      return SvgPicture.asset(logo, width: size, height: size);
    }
  } else if (logo.startsWith('http')) {
    return Image.network(
      logo,
      width: size,
      height: size,
      fit: fit == "cover" ? BoxFit.cover : BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  } else {
    return Image.asset(
      logo,
      width: size,
      height: size,
      fit: fit == "cover" ? BoxFit.cover : BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget imageDetector(String logo, {double size = 40}) {
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
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  } else {
    return Image.asset(
      logo,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}

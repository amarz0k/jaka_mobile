import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class CustomArrowBackButton extends StatelessWidget {
  const CustomArrowBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.router.popForced();
      },
      icon: Icon(
        Icons.arrow_back_rounded,
        size: 33,
        color: Colors.black,
        weight: 900, // Makes it very bold
      ),
    );
  }
}

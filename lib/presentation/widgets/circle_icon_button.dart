 import 'package:flutter/material.dart';

Widget circleIconButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.purple),
      ),
    );
  }
import 'dart:math';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';

String generateId(String name) {
  // Convert name to lowercase and replace spaces with underscores
  String formattedName = name.trim().toLowerCase().replaceAll(' ', '_');

  // Generate random 4 numbers
  final random = Random();
  String randomNumbers = '';
  for (int i = 0; i < 4; i++) {
    randomNumbers += random.nextInt(10).toString();
  }

  // Return in format: "name#1234"
  return '${formattedName}#$randomNumbers';
}

Future<String> ensureUniqueId(String name) async {
  final dbRef = getIt<FirebaseDatabase>().ref().child('users');
  String newId;

  while (true) {
    newId = generateId(name);

    final snapshot = await dbRef.orderByChild('id').equalTo(newId).get();
    if (!snapshot.exists) break; // ID is unique
  }

  return newId;
}

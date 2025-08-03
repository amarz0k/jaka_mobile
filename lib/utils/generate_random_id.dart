import 'dart:math';

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

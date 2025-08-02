import 'dart:math';

import 'package:chat_app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthDataSource(this._firebaseAuth, this._googleSignIn);

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

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) throw Exception('Google sign-in canceled');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential user = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (user.user == null) {
        throw Exception('User is null');
      }

      final uid = user.user!.uid;
      final userRef = FirebaseDatabase.instance.ref().child('users').child(uid);

      final DataSnapshot snapshot = await userRef.get();

      if (!snapshot.exists) {
        final userData = UserModel(
          id: generateId(user.user!.displayName!),
          name: user.user!.displayName!,
          email: user.user!.email!,
          photoUrl: user.user!.photoURL!,
          isOnline: true,
          lastSeen: DateTime.now(),
        );

        await userRef.set(userData.toJson());
        return userData;
      }

      final existingUser = UserModel.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );
      return existingUser;
    } catch (e) {
      throw Exception(e);
    }
  }
}

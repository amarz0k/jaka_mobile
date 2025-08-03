import 'dart:developer';

import 'package:chat_app/data/datasources/remote/google_auth_data_source.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleAuthDataSource _googleAuthDataSource;
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._googleAuthDataSource, this._firebaseAuth);

  @override
  Future<UserEntity> signInWithGoogle() async {
    final userModel = await _googleAuthDataSource.signInWithGoogle();
    return userModel.toEntity();
  }

  @override
  Future<bool> isUserAuthenticated() async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        log("isUserAuthenticated: No user found - user not authenticated");
        return false;
      }

      log("isUserAuthenticated: User found with UID: ${currentUser.uid}");

      final token = await currentUser.getIdToken();
      final isAuthenticated = token != null;

      log("isUserAuthenticated: Token valid: $isAuthenticated");
      return isAuthenticated;
    } catch (e) {
      log("isUserAuthenticated: Error checking authentication: $e");
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log("signOut: Error signing out: $e");
    }
  }
}

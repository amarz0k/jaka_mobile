import 'dart:developer';

import 'package:chat_app/data/datasources/remote/firebase_data_source.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseDataSource _firebaseDataSource;
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseDataSource, this._firebaseAuth);

  @override
  Future<UserEntity> signInWithGoogle() async {
    final userModel = await _firebaseDataSource.signInWithGoogle();
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(String em, String pass) async {
    try {
      final userModel = await _firebaseDataSource.signInWithEmailAndPassword(
        em,
        pass,
      );
      return userModel.toEntity();
    } catch (e) {
      log("signInWithEmail: Error signing in: $e");
      throw FirebaseAuthException(
        code: 'Signin Failed',
        message: 'Signin Failed',
      );
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String em,
    String pass,
    String name,
  ) async {
    try {
      final userModel = await _firebaseDataSource.signUpWithEmailAndPassword(
        em,
        pass,
        name,
      );

      return userModel.toEntity();
    } catch (e) {
      log("signUpWithEmail: Error signing up: $e");
      throw FirebaseAuthException(
        code: 'Signup Failed',
        message: 'Signup Failed',
      );
    }
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
      throw FirebaseAuthException(
        code: 'Signout Failed',
        message: 'Signout Failed',
      );
    }
  }
}

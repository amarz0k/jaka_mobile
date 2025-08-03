import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserRepositoryImpl implements UserRepository {
  final HiveService _hiveService;
  final usersBox = 'users';

  UserRepositoryImpl(this._hiveService);

  @override
  Future<void> saveUserToRealtimeDatabase(UserModel user) async {
    try {
      final userRef = getIt<FirebaseDatabase>()
          .ref()
          .child('users')
          .child(getIt<FirebaseAuth>().currentUser!.uid);

      final DataSnapshot snapshot = await userRef.get();

      if (!snapshot.exists) {
        await userRef.set(user.toJson());
      }
    } catch (e) {
      throw FirebaseAuthException(code: 'SIGNUP_FAILED', message: e.toString());
    }
  }

  @override
  Future<void> saveUserToLocalStorage(UserEntity user) async {
    try {
      await _hiveService.openBox(usersBox);
      await _hiveService.getBox<UserEntity>(usersBox).put('currentUser', user);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity> getUserFromLocalStorage() async {
    try {
      await _hiveService.openBox(usersBox);
      final currentUser = await _hiveService
          .getBox<UserEntity>(usersBox)
          .get('currentUser');

      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'NULL_USER',
          message: 'Sign in failed',
        );
      }
      return currentUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> getUserFromRealtimeDatabase() async {
    try {
      final userRef = getIt<FirebaseDatabase>()
          .ref()
          .child('users')
          .child(getIt<FirebaseAuth>().currentUser!.uid);

      final DataSnapshot snapshot = await userRef.get();

      if (!snapshot.exists) {
        throw FirebaseAuthException(
          code: 'NOT_FOUND',
          message: 'User not found in database',
        );
      }

      final existingUser = UserModel.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );

      return existingUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DatabaseReference> getUserDatabaseReference() async {
    try {
      final userRef = getIt<FirebaseDatabase>()
          .ref()
          .child('users')
          .child(getIt<FirebaseAuth>().currentUser!.uid);
      return userRef;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

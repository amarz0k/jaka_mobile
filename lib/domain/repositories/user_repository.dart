import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class UserRepository {
  Future<void> saveUserToLocalStorage(UserEntity user);

  Future<void> saveUserToRealtimeDatabase(UserModel user);

  Future<UserModel> getUserFromRealtimeDatabase();

  Future<DatabaseReference> getUserDatabaseReference();

  Future<UserEntity> getUserFromLocalStorage();

  Future<void> updateUserNotifications(bool value);

  Future<void> updateUserPassword(String password);

  Future<void> sendFriendRequest(String id);

  Future<List<Map<String, dynamic>>> getIncomingRequests();
}

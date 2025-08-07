import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
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
      final currentUser = _hiveService
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

  @override
  Future<void> updateUserNotifications(bool value) async {
    try {
      final dbRef = await getIt<UserRepository>().getUserDatabaseReference();
      await dbRef.update({'notifications': value});
    } catch (e) {
      throw FirebaseException(
        plugin: 'updateUserNotifications',
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> updateUserPassword(String password) async {
    try {
      final dbRef = await getIt<UserRepository>().getUserDatabaseReference();
      await dbRef.update({'password': password});
    } catch (e) {
      throw FirebaseException(
        plugin: 'updateUserPassword',
        message: e.toString(),
      );
    }
  }

  String _createSafeFirebasePath(String input) {
    return input
        .replaceAll('#', '_')
        .replaceAll('.', '_')
        .replaceAll('\$', '_')
        .replaceAll('[', '_')
        .replaceAll(']', '_');
  }

  Future<String?> getUserById(String customId) async {
    final DatabaseReference ref = getIt<FirebaseDatabase>().ref().child(
      'users',
    );

    final Query query = ref.orderByChild("id").equalTo(customId);
    final DataSnapshot snapshot = await query.get();

    if (snapshot.exists) {
      final Map users = snapshot.value as Map;
      final userEntry = users.entries.first;

      final userMap = Map<String, dynamic>.from(userEntry.value as Map);
      final user = UserModel.fromJson(userMap);

      return user.id;
    }

    return null;
  }

  @override
  Future<void> sendFriendRequest(String id) async {
    final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
        .call();
    final friendId = await getUserById(id);
    final requestId =
        '${_createSafeFirebasePath(currentUser.id)}_${_createSafeFirebasePath(friendId!)}';

    final dbRef = getIt<FirebaseDatabase>().ref().child(
      'friendRequests/$requestId',
    );

    if (await requestExists(currentUser.id, friendId)) {
      throw FirebaseAuthException(
        code: 'REQUEST_EXISTS',
        message: 'Request already exists',
      );
    }

    if (id == currentUser.id) {
      throw FirebaseAuthException(
        code: 'CURRENT_USER',
        message: 'Can\'t send friend request to yourself',
      );
    }

    await dbRef.set({
      'senderId': currentUser.id,
      'receiverId': friendId,
      'status': 'pending',
      'sentAt': DateTime.now().toIso8601String(),
      'acceptedAt': null,
    });
  }

  Future<bool> requestExists(String senderId, String receiverId) async {
    final safeSenderId = _createSafeFirebasePath(senderId);
    final safeReceiverId = _createSafeFirebasePath(receiverId);

    final snapshot = await getIt<FirebaseDatabase>()
        .ref()
        .child('friendRequests/${safeSenderId}_$safeReceiverId')
        .once();

    final snapshot2 = await getIt<FirebaseDatabase>()
        .ref()
        .child('friendRequests/${safeReceiverId}_$safeSenderId')
        .once();

    return snapshot.snapshot.exists || snapshot2.snapshot.exists;
  }

  @override
  Future<List<Map<String, dynamic>>> getIncomingRequests() async {
    final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
        .call();
    final dbRef = getIt<FirebaseDatabase>().ref().child('friendRequests');

    final snapshot = await dbRef
        .orderByChild('receiverId')
        .equalTo(currentUser.id)
        .get();

    if (!snapshot.exists) return [];

    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
      snapshot.value as Map,
    );

    return data.entries.map((entry) {
      final Map<String, dynamic> request = Map<String, dynamic>.from(
        entry.value,
      );
      request['uuid'] = entry.key; // Add the Firebase-generated key
      return request;
    }).toList();
  }
}

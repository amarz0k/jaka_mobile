import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/entities/request_entity.dart';
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

  @override
  Future<UserModel?> getUserById(String customId) async {
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

      return user;
    }

    return null;
  }

  @override
  Future<void> sendFriendRequest(String id) async {
    final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
        .call();

    if (currentUser.id == id) {
      throw FirebaseAuthException(
        code: 'CURRENT_USER',
        message: 'Can\'t send friend request to yourself',
      );
    }
    final friend = await getUserById(id);
    final requestId =
        '${_createSafeFirebasePath(currentUser.id)}_${_createSafeFirebasePath(friend!.id)}';

    final dbRef = getIt<FirebaseDatabase>().ref().child('friends/$requestId');

    if (await requestExists(currentUser.id, friend.id)) {
      throw FirebaseAuthException(
        code: 'REQUEST_EXISTS',
        message: 'Request already sent to this user',
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
      'receiverId': friend.id,
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
        .child('friends/${safeSenderId}_$safeReceiverId')
        .once();

    final snapshot2 = await getIt<FirebaseDatabase>()
        .ref()
        .child('friends/${safeReceiverId}_$safeSenderId')
        .once();

    return snapshot.snapshot.exists || snapshot2.snapshot.exists;
  }

  @override
  Stream<List<Map<String, String>>> getIncomingRequestsStream() async* {
    try {
      final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
          .call();
      final dbRef = getIt<FirebaseDatabase>().ref().child('friends');

      await for (final event in dbRef.onValue) {
        if (!event.snapshot.exists) {
          yield [];
          continue;
        }

        final List<RequestEntity> incomingRequests = [];
        final Map<dynamic, dynamic> allRequests =
            event.snapshot.value as Map<dynamic, dynamic>;

        allRequests.forEach((requestId, requestData) {
          final Map<String, dynamic> request = Map<String, dynamic>.from(
            requestData as Map,
          );

          // Check if this request is for the current user (they are the receiver)
          if (request['receiverId'] == currentUser.id &&
              request['status'] == 'pending') {
            incomingRequests.add(
              RequestEntity(
                senderId: request['senderId'] as String,
                receiverId: request['receiverId'] as String,
                sentAt: request['sentAt'] as String,
                status: request['status'] as String,
              ),
            );
          }
        });

        // Sort by sentAt timestamp (most recent first)
        incomingRequests.sort((a, b) => b.sentAt.compareTo(a.sentAt));

        List<Map<String, String>> incomingRequestsData = [];

        // Get friend data for each request
        for (final request in incomingRequests) {
          try {
            final friend = await getUserById(request.senderId);
            if (friend != null) {
              incomingRequestsData.add({
                'friendPhotoUrl': friend.photoUrl ?? '',
                'friendName': friend.name,
                'senderId': request.senderId,
                'sentAt': request.sentAt,
              });
            }
          } catch (e) {
            // Log error but continue with other requests
            print('Error fetching friend data for ${request.senderId}: $e');
          }
        }

        yield incomingRequestsData;
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'GET_REQUESTS_STREAM_FAILED',
        message: 'Failed to get incoming requests stream: ${e.toString()}',
      );
    }
  }

  @override
  Stream<List<Map<String, String>>> getOutgoingRequestsStream() async* {
    try {
      final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
          .call();
      final dbRef = getIt<FirebaseDatabase>().ref().child('friends');

      await for (final event in dbRef.onValue) {
        if (!event.snapshot.exists) {
          yield [];
          continue;
        }

        final List<RequestEntity> outgoingRequests = [];
        final Map<dynamic, dynamic> allRequests =
            event.snapshot.value as Map<dynamic, dynamic>;

        allRequests.forEach((requestId, requestData) {
          final Map<String, dynamic> request = Map<String, dynamic>.from(
            requestData as Map,
          );

          // Check if this request is from the current user (they are the sender)
          if (request['senderId'] == currentUser.id &&
              request['status'] == 'pending') {
            outgoingRequests.add(
              RequestEntity(
                senderId: request['senderId'] as String,
                receiverId: request['receiverId'] as String,
                sentAt: request['sentAt'] as String,
                status: request['status'] as String,
              ),
            );
          }
        });

        // Sort by sentAt timestamp (most recent first)
        outgoingRequests.sort((a, b) => b.sentAt.compareTo(a.sentAt));

        List<Map<String, String>> outgoingRequestsData = [];

        // Get friend data for each request
        for (final request in outgoingRequests) {
          try {
            final friend = await getUserById(request.receiverId);
            if (friend != null) {
              outgoingRequestsData.add({
                'friendPhotoUrl': friend.photoUrl ?? '',
                'friendName': friend.name,
                'receiverId': request.receiverId,
                'sentAt': request.sentAt,
              });
            }
          } catch (e) {
            // Log error but continue with other requests
            print('Error fetching friend data for ${request.receiverId}: $e');
          }
        }

        yield outgoingRequestsData;
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'GET_OUTGOING_REQUESTS_STREAM_FAILED',
        message: 'Failed to get outgoing requests stream: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> rejectFriendRequest(String friendId) async {
    try {
      final currentUser = await getIt<GetUserFromRealtimeDatabaseUsecase>()
          .call();

      final path1 =
          'friends/${_createSafeFirebasePath(friendId)}_${_createSafeFirebasePath(currentUser.id)}';
      final path2 =
          'friends/${_createSafeFirebasePath(currentUser.id)}_${_createSafeFirebasePath(friendId)}';

      // Remove both possible paths (only one will exist)
      await getIt<FirebaseDatabase>().ref().child(path1).remove();

      await getIt<FirebaseDatabase>().ref().child(path2).remove();
    } catch (e) {
      throw FirebaseAuthException(
        code: 'REJECT_FRIEND_REQUEST_FAILED',
        message: 'Failed to reject friend request: ${e.toString()}',
      );
    }
  }

  @override
  Future<DatabaseReference> getFriendsDatabaseReference() async {
    try {
      final friendsDbRef = getIt<FirebaseDatabase>().ref().child('friends');
      return friendsDbRef;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'GET_FRIEND_DB_REFERENCE_FAILED',
        message: 'Failed to get friend database reference: ${e.toString()}',
      );
    }
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/entities/friend_entity.dart';
import 'package:chat_app/domain/entities/request_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/accept_friend_request_usecase.dart';
import 'package:chat_app/domain/usecases/get_friends_db_reference_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_by_id_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_database_reference_usecase.dart';
import 'package:chat_app/domain/usecases/reject_friend_request_usecase.dart';
import 'package:chat_app/domain/usecases/remove_all_messages_between_usecase.dart';
import 'package:chat_app/domain/usecases/send_friend_request_usecase.dart';
import 'package:chat_app/domain/usecases/update_user_profile_usecase.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final GetUserDatabaseReferenceUsecase _getUserDatabaseReferenceUsecase;
  final GetFriendsDbReferenceUsecase _getFriendsDbReferenceUsecase;
  final SendFriendRequestUsecase _sendFriendRequestUsecase;
  final RejectFriendRequestUsecase _rejectFriendRequestUsecase;
  final GetUserByIdUsecase _getUserByIdUsecase;
  final AcceptFriendRequestUsecase _acceptFriendRequestUsecase;
  final RemoveAllMessagesBetweenUsecase _removeAllMessagesBetweenUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;
  String? _currentUserId;
  StreamSubscription? _userDataSubscription;
  StreamSubscription? _friendRequestsSubscription;

  UserDataCubit({required UserRepository userRepository})
    : _getUserDatabaseReferenceUsecase =
          getIt<GetUserDatabaseReferenceUsecase>(),
      _sendFriendRequestUsecase = getIt<SendFriendRequestUsecase>(),
      _rejectFriendRequestUsecase = getIt<RejectFriendRequestUsecase>(),
      _getFriendsDbReferenceUsecase = getIt<GetFriendsDbReferenceUsecase>(),
      _getUserByIdUsecase = getIt<GetUserByIdUsecase>(),
      _acceptFriendRequestUsecase = getIt<AcceptFriendRequestUsecase>(),
      _removeAllMessagesBetweenUsecase =
          getIt<RemoveAllMessagesBetweenUsecase>(),
      _updateUserProfileUsecase = getIt<UpdateUserProfileUsecase>(),
      super(InitialState()) {
    initialize();
  }

  Future<void> initialize() async {
    await _loadUserData();
    await _loadFriendRequests();
  }

  Future<void> _loadUserData() async {
    emit(LoadingState());
    try {
      final userDbRef = await _getUserDatabaseReferenceUsecase.call();

      final snapshot = await userDbRef.get();
      if (snapshot.value != null) {
        final user = UserModel.fromJson(
          Map<String, dynamic>.from(snapshot.value as Map),
        ).toEntity();
        _currentUserId = user.id;
        log("afterr current user id: $_currentUserId");
        emit(UserDataLoadedState(user: user));
      }

      _userDataSubscription = userDbRef.onValue.listen((event) {
        if (event.snapshot.value != null) {
          try {
            final user = UserModel.fromJson(
              Map<String, dynamic>.from(event.snapshot.value as Map),
            ).toEntity();
            _currentUserId = user.id;
            emit(UserDataLoadedState(user: user));
          } catch (e) {
            emit(FailureState(error: e.toString()));
          }
        }
      });
    } catch (e) {
      emit(FailureState(error: e.toString()));
    }
  }

  Future<void> _loadFriendRequests() async {
    log("_loadFriendRequests: current user id: $_currentUserId");

    try {
      final friendsDbRef = await _getFriendsDbReferenceUsecase.call();
      _friendRequestsSubscription = friendsDbRef.onValue.listen((event) {
        _processFriendRequests(event.snapshot.value);
      });
    } catch (e) {
      log('Error setting up friend requests stream: $e');
      emit(FailureState(error: 'Failed to load friend requests'));
    }
  }

  Future<Map<String, List<FriendEntity>>> _processFriendRequestsData(
    dynamic data,
  ) async {
    Map<String, List<FriendEntity>> result = {
      "incomingRequests": [],
      "outgoingRequests": [],
      "friends": [],
    };

    if (data == null || _currentUserId == null) {
      return result;
    }

    final allFriends = data as Map<dynamic, dynamic>;
    final List<RequestEntity> incomingRequests = [];
    final List<RequestEntity> outgoingRequests = [];
    final List<RequestEntity> acceptedRequests = [];

    // Separate incoming and outgoing requests
    allFriends.forEach((key, value) {
      final Map<String, dynamic> friend = Map<String, dynamic>.from(
        value as Map,
      );

      if (friend['status'] == 'pending') {
        final request = RequestEntity(
          senderId: friend['senderId'] as String,
          receiverId: friend['receiverId'] as String,
          sentAt: friend['sentAt'] as String,
          status: friend['status'] as String,
        );

        if (friend['receiverId'] == _currentUserId) {
          incomingRequests.add(request);
        } else if (friend['senderId'] == _currentUserId) {
          outgoingRequests.add(request);
        }
      }

      if (friend['status'] == 'accepted') {
        if (friend['acceptedAt'] != null &&
            friend['acceptedAt'] != "" &&
            friend['receiverId'] == _currentUserId) {
          final request = RequestEntity(
            senderId: friend['senderId'] as String,
            receiverId: friend['receiverId'] as String,
            sentAt: friend['sentAt'] as String,
            status: friend['status'] as String,
            lastMessage: friend['lastMessage'] as String?,
            lastMessageDate: friend['lastMessageDate'] != null
                ? DateTime.parse(friend['lastMessageDate'] as String)
                : null,
          );

          acceptedRequests.add(request);
        } else if (friend['acceptedAt'] != null &&
            friend['acceptedAt'] != "" &&
            friend['senderId'] == _currentUserId) {
          final request = RequestEntity(
            senderId: friend['receiverId'] as String,
            receiverId: friend['senderId'] as String,
            sentAt: friend['sentAt'] as String,
            status: friend['status'] as String,
            lastMessage: friend['lastMessage'] as String?,
            lastMessageDate: friend['lastMessageDate'] != null
                ? DateTime.parse(friend['lastMessageDate'] as String)
                : null,
          );
          acceptedRequests.add(request);
        }
      }
    });

    // Process incoming requests
    final List<FriendEntity> incomingRequestsData = [];
    for (final request in incomingRequests) {
      try {
        log("request: $request");
        final friendData = await _getUserByIdUsecase.call(request.senderId);
        if (friendData != null) {
          incomingRequestsData.add(
            FriendEntity(
              id: request.senderId,
              name: friendData.name,
              photoUrl: friendData.photoUrl,
            ),
          );
        }
      } catch (e) {
        log('Error fetching friend data for ${request.senderId}: $e');
      }
    }

    // Process outgoing requests
    final List<FriendEntity> outgoingRequestsData = [];
    for (final request in outgoingRequests) {
      try {
        final friendData = await _getUserByIdUsecase.call(request.receiverId);
        if (friendData != null) {
          outgoingRequestsData.add(
            FriendEntity(
              id: request.receiverId,
              name: friendData.name,
              photoUrl: friendData.photoUrl,
            ),
          );
        }
      } catch (e) {
        log('Error fetching friend data for ${request.receiverId}: $e');
      }
    }

    final List<FriendEntity> friendsData = [];
    for (final request in acceptedRequests) {
      try {
        final friendData = await _getUserByIdUsecase.call(request.senderId);
        if (friendData != null) {
          friendsData.add(
            FriendEntity(
              id: request.senderId,
              name: friendData.name,
              photoUrl: friendData.photoUrl,
              lastMessage: request.lastMessage,
              lastMessageDate: request.lastMessageDate,
            ),
          );
        }
      } catch (e) {
        log('Error fetching friend data for ${request.senderId}: $e');
      }
    }

    result["incomingRequests"] = incomingRequestsData;
    result["outgoingRequests"] = outgoingRequestsData;
    result["friends"] = friendsData;

    return result;
  }

  Future<void> _processFriendRequests(dynamic data) async {
    try {
      final requestsData = await _processFriendRequestsData(data);

      final currentState = state;
      if (currentState is UserDataLoadedState) {
        log("incomingRequests: ${requestsData["incomingRequests"]}");
        log("outgoingRequests: ${requestsData["outgoingRequests"]}");
        log("friends: ${requestsData["friends"]}");
        emit(
          currentState.copyWith(
            incomingRequests: requestsData["incomingRequests"],
            outgoingRequests: requestsData["outgoingRequests"],
            friends: requestsData["friends"],
            clearMessage: true,
            clearError: true,
          ),
        );
      }
    } catch (e) {
      log('Error processing friend requests: $e');
      emit(FailureState(error: 'Failed to load friend requests'));
    }
  }

  Future<void> addFriend(String id) async {
    final currentState = state;
    if (currentState is! UserDataLoadedState) {
      log('Cannot add friend: User data not loaded');
      return;
    }

    try {
      await _sendFriendRequestUsecase.call(id);
      emit(
        currentState.copyWith(
          message: "Friend request sent successfully",
          clearMessage: true,
          clearError: true,
        ),
      );
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        errorMessage = e.message ?? "Something went wrong";
      } else {
        errorMessage = "Something went wrong";
      }
      emit(currentState.copyWith(error: errorMessage));
    }
  }

  Future<void> rejectFriendRequest(String id) async {
    final currentState = state;
    if (currentState is! UserDataLoadedState) {
      log('Cannot reject friend request: User data not loaded');
      return;
    }

    try {
      await _rejectFriendRequestUsecase.call(id);
      emit(
        currentState.copyWith(message: "Friend request rejected successfully"),
      );
      _loadFriendRequests();
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        errorMessage = e.message ?? "Something went wrong";
      } else {
        errorMessage = "Something went wrong";
      }
      emit(currentState.copyWith(error: errorMessage));
    }
  }

  Future<void> acceptFriendRequest(String id) async {
    final currentState = state;
    if (currentState is! UserDataLoadedState) {
      log('Cannot accept friend request: User data not loaded');
      return;
    }

    try {
      await _acceptFriendRequestUsecase.call(id);
      emit(
        currentState.copyWith(message: "Friend request accepted successfully"),
      );
      _loadFriendRequests();
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        errorMessage = e.message ?? "Something went wrong";
      } else {
        errorMessage = "Something went wrong";
      }
      emit(currentState.copyWith(error: errorMessage));
    }
  }

  Future<void> removeAllMessagesBetween(String receiverId) async {
    try {
      // final currentState = state;
      await _removeAllMessagesBetweenUsecase.call(_currentUserId!, receiverId);
      // if (currentState is UserDataLoadedState) {
      //   emit(
      //     currentState.copyWith(message: "All messages removed successfully"),
      //   );
      // }
      _loadFriendRequests();
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        errorMessage = e.message ?? "Something went wrong";
      } else {
        errorMessage = "Something went wrong";
      }
      emit(FailureState(error: errorMessage));
    }
  }

  Future<void> updateUserProfile(String? name, String? photoUrl) async {
    try {
      final currentState = state;
      await _updateUserProfileUsecase.call(name, photoUrl);
      emit(
        currentState is UserDataLoadedState
            ? currentState.copyWith(
                message: "Profile updated successfully",
                clearMessage: true,
                clearError: true,
              )
            : currentState,
      );
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        errorMessage = e.message ?? "Something went wrong";
      } else {
        errorMessage = "Something went wrong";
      }
      emit(FailureState(error: errorMessage));
    }
  }

  @override
  Future<void> close() async {
    try {
      log('UserDataCubit: Starting complete cleanup...');

      // Clear all internal data
      _currentUserId = null;

      // Cancel all subscriptions safely
      await _userDataSubscription?.cancel();
      await _friendRequestsSubscription?.cancel();

      // Clear subscription references
      _userDataSubscription = null;
      _friendRequestsSubscription = null;

      log(
        "Subscriptions cancelled - UserData: ${_userDataSubscription == null}",
      );
      log(
        "Subscriptions cancelled - FriendRequests: ${_friendRequestsSubscription == null}",
      );

      // Clear all states by emitting initial state
      emit(InitialState());

      log('UserDataCubit: Complete cleanup finished successfully');
    } catch (e) {
      log('UserDataCubit: Error during cleanup: $e');
      // Force cleanup even if there's an error
      _currentUserId = null;
      _userDataSubscription = null;
      _friendRequestsSubscription = null;
      emit(InitialState());
    }

    // Call super.close() after cleanup
    await super.close();
  }
}

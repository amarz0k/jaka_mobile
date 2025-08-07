import 'dart:async';
import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
// import 'package:chat_app/domain/usecases/get_user_from_local_database_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_database_reference_usecase.dart';
import 'package:chat_app/domain/usecases/send_friend_request_usecase.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataCubit extends Cubit<UserDataState> {
  // final GetUserFromLocalDatabaseUsecase _getUserFromLocalDatabaseUsecase;
  final GetUserDatabaseReferenceUsecase _getUserFromRealtimeDatabaseUsecase;
  final SendFriendRequestUsecase _sendFriendRequestUsecase;
  StreamSubscription? _userDataSubscription;
  StreamSubscription? _authStateSubscription;
  String? _currentUserId;

  UserDataCubit({required UserRepository userRepository})
    : // _getUserFromLocalDatabaseUsecase =
      //       getIt<GetUserFromLocalDatabaseUsecase>(),
      _getUserFromRealtimeDatabaseUsecase =
          getIt<GetUserDatabaseReferenceUsecase>(),
      _sendFriendRequestUsecase = getIt<SendFriendRequestUsecase>(),
      super(InitialState()) {
    _listenToAuthChanges();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Cancel any existing subscription
    await _userDataSubscription?.cancel();
    
    emit(LoadingState());
    try {
      final dbRef = await _getUserFromRealtimeDatabaseUsecase.call();
      
      // Store the subscription so we can cancel it later
      _userDataSubscription = dbRef.onValue.listen(
        (event) {
          if (event.snapshot.value != null) {
            try {
              final userModel = UserModel.fromJson(
                Map<String, dynamic>.from(event.snapshot.value as Map),
              );
              emit(LoadedState(user: userModel.toEntity()));
            } catch (e) {
              log('Error parsing user data: $e');
              emit(FailureState(error: 'Failed to load user data'));
            }
          } else {
            log('User data is null');
            emit(FailureState(error: 'User data not found'));
          }
        },
        onError: (error) {
          log('Stream error: $error');
          emit(FailureState(error: 'Failed to load user data'));
        },
      );
    } catch (e) {
      log('Error getting database reference: $e');
      emit(FailureState(error: e.toString()));
    }
  }

  Future<void> addFriend(String id) async {
    emit(LoadingState());
    try {
      await _sendFriendRequestUsecase.call(id);
      emit(SuccessState(message: "Friend request sent successfully"));
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        emit(FailureState(error: e.message));
      }
      emit(FailureState(error: "Something went wrong"));
    }
  }

  /// Listen to Firebase Auth state changes to detect user changes
  void _listenToAuthChanges() {
    _authStateSubscription = getIt<FirebaseAuth>().authStateChanges().listen((User? user) {
      final newUserId = user?.uid;
      
      // If user changed (including sign out or sign in with different user)
      if (_currentUserId != newUserId) {
        log('Auth state changed. Old user: $_currentUserId, New user: $newUserId');
        _currentUserId = newUserId;
        
        if (newUserId != null) {
          // User signed in (or changed), reload data
          _loadUserData();
        } else {
          // User signed out, reset state
          emit(InitialState());
        }
      }
    });
  }

  /// Refreshes user data (useful after sign in with different user)
  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  @override
  Future<void> close() async {
    await _userDataSubscription?.cancel();
    await _authStateSubscription?.cancel();
    return super.close();
  }
}

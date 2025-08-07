import 'dart:async';
import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/get_incoming_requests_stream_usecase.dart';
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
  StreamSubscription? _incomingRequestsSubscription;
  String? _currentUserId;
  final GetIncomingRequestsStreamUsecase _getIncomingRequestsStreamUsecase;

  UserDataCubit({required UserRepository userRepository})
    : // _getUserFromLocalDatabaseUsecase =
      //       getIt<GetUserFromLocalDatabaseUsecase>(),
      _getUserFromRealtimeDatabaseUsecase =
          getIt<GetUserDatabaseReferenceUsecase>(),
      _sendFriendRequestUsecase = getIt<SendFriendRequestUsecase>(),
      _getIncomingRequestsStreamUsecase =
          getIt<GetIncomingRequestsStreamUsecase>(),
      super(InitialState()) {
    _listenToAuthChanges();
    _loadUserData();
    _loadIncomingRequests();
  }

  Future<void> _loadUserData() async {
    // Cancel any existing subscription
    await _userDataSubscription?.cancel();

    // Only emit loading state if we don't already have user data loaded
    if (state is! UserDataLoadedState &&
        state is! IncomingRequestsLoadedState) {
      emit(LoadingState());
    }

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

              // Preserve existing incoming requests data if available
              final currentState = state;
              List<Map<String, String>>? existingRequests;
              if (currentState is UserDataLoadedState) {
                existingRequests = currentState.incomingRequests;
              } else if (currentState is IncomingRequestsLoadedState) {
                existingRequests = currentState.incomingRequests;
              }

              emit(
                UserDataLoadedState(
                  user: userModel.toEntity(),
                  incomingRequests: existingRequests,
                ),
              );
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

  /// Listen to Firebase Auth state changes to detect user changes
  void _listenToAuthChanges() {
    _authStateSubscription = getIt<FirebaseAuth>().authStateChanges().listen((
      User? user,
    ) async {
      final newUserId = user?.uid;

      // If user changed (including sign out or sign in with different user)
      if (_currentUserId != newUserId) {
        log(
          'Auth state changed. Old user: $_currentUserId, New user: $newUserId',
        );
        _currentUserId = newUserId;

        if (newUserId != null) {
          // User signed in (or changed), reload data
          _loadUserData();
          _loadIncomingRequests();
        } else {
          // User signed out, reset state
          await _incomingRequestsSubscription?.cancel();
          emit(InitialState());
        }
      }
    });
  }

  // Refreshes user data (useful after sign in with different user)
  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  Future<void> addFriend(String id) async {
    final currentState = state;

    try {
      await _sendFriendRequestUsecase.call(id);

      // Update current state with success message
      if (currentState is UserDataLoadedState) {
        emit(
          currentState.copyWith(message: "Friend request sent successfully"),
        );

        // Clear the message after a short delay
        Timer(Duration(seconds: 2), () {
          if (state is UserDataLoadedState) {
            emit((state as UserDataLoadedState).clearMessage());
          }
        });
      } else {
        emit(SuccessState(message: "Friend request sent successfully"));
      }
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        errorMessage = e.message ?? "Something went wrong";
      } else {
        errorMessage = "Something went wrong";
      }

      // Update current state with error message
      if (currentState is UserDataLoadedState) {
        emit(currentState.copyWith(error: errorMessage));

        // Clear the error message after a short delay
        Timer(Duration(seconds: 3), () {
          if (state is UserDataLoadedState) {
            emit((state as UserDataLoadedState).clearMessage());
          }
        });
      } else {
        emit(FailureState(error: errorMessage));
      }
    }
  }

  /// Load incoming requests with real-time updates using _loadData pattern
  Future<void> _loadIncomingRequests() async {
    // Cancel any existing incoming requests subscription
    await _incomingRequestsSubscription?.cancel();

    try {
      // Store the subscription so we can cancel it later
      _incomingRequestsSubscription = _getIncomingRequestsStreamUsecase.call().listen(
        (incomingRequests) {
          try {
            // Update the current state with incoming requests data
            final currentState = state;
            if (currentState is UserDataLoadedState) {
              // Update existing UserDataLoadedState with incoming requests
              emit(currentState.copyWith(incomingRequests: incomingRequests));
            } else {
              // Emit as IncomingRequestsLoadedState if user data not loaded yet
              emit(
                IncomingRequestsLoadedState(incomingRequests: incomingRequests),
              );
            }
            log(
              'Incoming requests updated: ${incomingRequests.length} requests',
            );
          } catch (e) {
            log('Error processing incoming requests: $e');
            emit(FailureState(error: 'Failed to load incoming requests'));
          }
        },
        onError: (error) {
          log('Incoming requests stream error: $error');
          emit(FailureState(error: 'Failed to load incoming requests'));
        },
      );
    } catch (e) {
      log('Error setting up incoming requests stream: $e');
      emit(FailureState(error: e.toString()));
    }
  }

  /// Public method to start listening to incoming requests
  void getIncomingRequests() {
    emit(LoadingState());
    _loadIncomingRequests();
  }

  @override
  Future<void> close() async {
    await _userDataSubscription?.cancel();
    await _authStateSubscription?.cancel();
    await _incomingRequestsSubscription?.cancel();
    return super.close();
  }
}

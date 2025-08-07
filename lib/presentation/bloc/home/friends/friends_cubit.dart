import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/send_friend_request_usecase.dart';
import 'package:chat_app/presentation/bloc/home/friends/friends_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsCubit extends Cubit<FriendsState> {
  final SendFriendRequestUsecase _sendFriendRequestUsecase;

  FriendsCubit({required UserRepository userRepository})
    : _sendFriendRequestUsecase = getIt<SendFriendRequestUsecase>(),
      super(FriendsIntialState());

  Future<void> addFriend(String id) async {
    emit(FriendsLoadingState());
    try {
      await _sendFriendRequestUsecase.call(id);
      emit(FriendsSuccessState(message: "Friend request sent successfully"));
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}");
        emit(FriendsFailureState(error: e.message));
      }
      emit(FriendsFailureState(error: "Something went wrong"));
    }
  }
}

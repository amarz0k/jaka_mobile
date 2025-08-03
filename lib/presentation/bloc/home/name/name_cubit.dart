import 'dart:async';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/get_user_from_local_database_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:chat_app/presentation/bloc/home/name/name_event.dart';
import 'package:chat_app/presentation/bloc/home/name/name_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NameCubit extends Bloc<NameEvent, NameState> {
  final GetUserFromLocalDatabaseUsecase _getUserFromLocalDatabaseUsecase;
  final GetUserDatabaseReferenceUsecase _getUserFromRealtimeDatabaseUsecase;
  late StreamSubscription internetSub;
  bool hasInternetConn = false;

  NameCubit({required UserRepository userRepository})
    : _getUserFromLocalDatabaseUsecase =
          getIt<GetUserFromLocalDatabaseUsecase>(),
      _getUserFromRealtimeDatabaseUsecase =
          getIt<GetUserDatabaseReferenceUsecase>(),
      super(NameInitialState()) {
    on<CheckUserDataEvent>(checkUserData);
  }

  Future<void> checkUserData(
    CheckUserDataEvent event,
    Emitter<NameState> emit,
  ) async {
    emit(NameLoadingState());

    final connectionStream = getIt<InternetConnectionChecker>().onStatusChange;

    await for (final status in connectionStream) {
      final isConnected = status == InternetConnectionStatus.connected;
      emit(InternetConnectionState(isConnected: isConnected));

      if (isConnected) {
        final dbRef = await _getUserFromRealtimeDatabaseUsecase.call();

        await emit.forEach(
          dbRef.onValue,
          onData: (event) {
            final userModel = UserModel.fromJson(
              Map<String, dynamic>.from(event.snapshot.value as Map),
            );
            return NameSuccessState(user: userModel.toEntity());
          },
          onError: (_, __) => NameFailureState(error: 'Database error'),
        );
      } else {
        final user = await _getUserFromLocalDatabaseUsecase.call();
        emit(NameSuccessState(user: user));
      }

      break; // 👉 stop after first event (optional)
    }
  }
}

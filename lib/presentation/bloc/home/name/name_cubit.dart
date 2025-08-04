import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/get_user_from_local_database_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:chat_app/presentation/bloc/home/name/name_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameCubit extends Cubit<NameState> {
  final GetUserFromLocalDatabaseUsecase _getUserFromLocalDatabaseUsecase;
  final GetUserDatabaseReferenceUsecase _getUserFromRealtimeDatabaseUsecase;

  NameCubit({required UserRepository userRepository})
    : _getUserFromLocalDatabaseUsecase =
          getIt<GetUserFromLocalDatabaseUsecase>(),
      _getUserFromRealtimeDatabaseUsecase =
          getIt<GetUserDatabaseReferenceUsecase>(),
      super(InitialState()) {
    _checkIsConnectedToInternet();
  }

  Future<void> _checkIsConnectedToInternet() async {
    emit(LoadingState());
    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity()
          .checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet)) {
        emit(InternetConnectionState(isConnected: true));
        print("Internet connection restored");
        final dbRef = await _getUserFromRealtimeDatabaseUsecase.call();
        dbRef.onValue.listen((event) {
          final userModel = UserModel.fromJson(
            Map<String, dynamic>.from(event.snapshot.value as Map),
          );

          emit(SuccessState(user: userModel.toEntity()));
        });
      } else {
        emit(InternetConnectionState(isConnected: false));
        final user = await _getUserFromLocalDatabaseUsecase.call();
        emit(SuccessState(user: user));
      }
    } catch (e) {
      emit(FailureState(error: e.toString()));
    }
  }
}

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
// import 'package:chat_app/domain/usecases/get_user_from_local_database_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataCubit extends Cubit<UserDataState> {
  // final GetUserFromLocalDatabaseUsecase _getUserFromLocalDatabaseUsecase;
  final GetUserDatabaseReferenceUsecase _getUserFromRealtimeDatabaseUsecase;

  UserDataCubit({required UserRepository userRepository})
    : 
    // _getUserFromLocalDatabaseUsecase =
    //       getIt<GetUserFromLocalDatabaseUsecase>(),
      _getUserFromRealtimeDatabaseUsecase =
          getIt<GetUserDatabaseReferenceUsecase>(),
      super(InitialState()) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    emit(LoadingState());
    try {
      final dbRef = await _getUserFromRealtimeDatabaseUsecase.call();
      dbRef.onValue.listen((event) {
        final userModel = UserModel.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as Map),
        );
        emit(SuccessState(user: userModel.toEntity()));
      });
    } catch (e) {
      emit(FailureState(error: e.toString()));
    }
  }
}

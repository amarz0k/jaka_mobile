import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/get_user_from_local_database_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_from_realtime_database_usecase.dart';
import 'package:chat_app/domain/usecases/save_user_to_realtime_database_usecase.dart';
import 'package:chat_app/domain/usecases/save_user_to_local_usecase.dart';
import 'package:chat_app/presentation/bloc/home/name/name_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameCubit extends Cubit<NameState> {
  final GetUserFromLocalDatabaseUsecase _getUserFromLocalDatabaseUsecase;
  final GetUserDatabaseReferenceUsecase _getUserFromRealtimeDatabaseUsecase;
  final SaveUserToRealtimeDatabaseUsecase _saveUserToRealtimeDatabaseUsecase =
      getIt<SaveUserToRealtimeDatabaseUsecase>();
  final SaveUserToLocalUsecase _saveUserToLocalUsecase =
      getIt<SaveUserToLocalUsecase>();

  NameCubit({required UserRepository userRepository})
    : _getUserFromLocalDatabaseUsecase =
          getIt<GetUserFromLocalDatabaseUsecase>(),
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

  Future<void> updateUserName(String newName) async {
    try {
      emit(NameUpdatingState());
      final userEntity = await _getUserFromLocalDatabaseUsecase.call();
      final updatedUser = userEntity.copyWith(name: newName);
      // Save to local
      await _saveUserToLocalUsecase.call(updatedUser);
      // Save to realtime
      final userModel = UserModel(
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
        password: updatedUser.password,
        photoUrl: updatedUser.photoUrl,
        isOnline: updatedUser.isOnline,
        lastSeen: updatedUser.lastSeen,
      );
      await _saveUserToRealtimeDatabaseUsecase.call(userModel);
      emit(NameUpdateSuccessState());
      // Reload user data to update UI
      await _loadUserData();
    } catch (e) {
      emit(NameUpdateFailureState(e.toString()));
      await _loadUserData();
    }
  }
}

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/update_user_notifications_usecase.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UpdateUserNotificationsUsecase _updateUserNotificationsUsecase;

  SettingsCubit({required UserRepository userRepository})
    : _updateUserNotificationsUsecase = getIt<UpdateUserNotificationsUsecase>(),
      super(SettingsInitialState());

  Future<void> updateUserNotifications(bool value) async {
    emit(SettingsLoadingState());
    try {
      await _updateUserNotificationsUsecase.call(value);
      emit(SettingsSuccessState());
    } catch (e) {
      emit(SettingsFailureState(error: e.toString()));
    }
  }
}

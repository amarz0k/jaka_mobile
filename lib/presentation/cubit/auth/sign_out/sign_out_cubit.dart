import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_out_usecase.dart';
import 'package:chat_app/presentation/cubit/auth/sign_out/sign_out_event.dart';
import 'package:chat_app/presentation/cubit/auth/sign_out/sign_out_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutCubit extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUsecase _signOutUsecase;

  SignOutCubit({required AuthRepository authRepository})
    : _signOutUsecase = getIt<SignOutUsecase>(),
      super(AuthInitialState()) {
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<SignOutState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await _signOutUsecase.call();
      emit(AuthInitialState());
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }
}

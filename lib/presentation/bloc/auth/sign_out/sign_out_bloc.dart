import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/domain/usecases/sign_out_usecase.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_event.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_state.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUsecase _signOutUsecase;

  SignOutBloc({required AuthRepository authRepository})
    : _signOutUsecase = getIt<SignOutUsecase>(),
      super(AuthInitialState()) {
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<SignOutState> emit,
  ) async {
    final UserDataCubit userDataCubit = UserDataCubit(
      userRepository: getIt<UserRepository>(),
    );

    emit(AuthLoadingState());
    try {
      await userDataCubit.close();
      await _signOutUsecase.call();
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }
}

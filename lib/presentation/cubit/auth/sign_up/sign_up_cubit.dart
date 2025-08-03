import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:chat_app/presentation/cubit/auth/sign_up/sign_up_event.dart';
import 'package:chat_app/presentation/cubit/auth/sign_up/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Bloc<SignUpEvent, SignUpState> {
  final SignUpWithEmailUsecase _signUpWithEmail;

  SignUpCubit({required AuthRepository authRepository})
    : _signUpWithEmail = getIt<SignUpWithEmailUsecase>(),
      super(AuthInitialState()) {
    on<AuthSignUpWithEmailAndPasswordEvent>(_onSignUpWithEmailAndPassword);
  }

  Future<void> _onSignUpWithEmailAndPassword(
    AuthSignUpWithEmailAndPasswordEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _signUpWithEmail.call(
        event.email,
        event.password,
        event.name,
      );
      emit(AuthSuccessState(user: result));
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }
}

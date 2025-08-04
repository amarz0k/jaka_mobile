import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_event.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpWithEmailUsecase _signUpWithEmail;

  SignUpBloc({required AuthRepository authRepository})
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
      await _signUpWithEmail.call(event.email, event.password, event.name);
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }
}

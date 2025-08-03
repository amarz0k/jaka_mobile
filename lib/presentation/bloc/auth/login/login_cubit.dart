import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:chat_app/presentation/bloc/auth/login/login_event.dart';
import 'package:chat_app/presentation/bloc/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Bloc<LoginEvent, LoginState> {
  final SignInWithEmailUsecase _signInWithEmail;

  LoginCubit({required AuthRepository authRepository})
    : _signInWithEmail = getIt<SignInWithEmailUsecase>(),
      super(AuthInitialState()) {
    on<AuthSignInWithEmailAndPasswordEvent>(_onSignInWithEmailAndPassword);
  }

  Future<void> _onSignInWithEmailAndPassword(
    AuthSignInWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await _signInWithEmail.call(event.email, event.password);
      emit(AuthSuccessState());
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }
}

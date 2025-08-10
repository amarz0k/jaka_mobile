import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_event.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpWithEmailUsecase _signUpWithEmail;
  String? _displayNameError;

  SignUpBloc({required AuthRepository authRepository})
    : _signUpWithEmail = getIt<SignUpWithEmailUsecase>(),
      super(AuthInitialState()) {
    on<AuthSignUpWithEmailAndPasswordEvent>(_onSignUpWithEmailAndPassword);
    on<AuthValidateDisplayNameEvent>(_onValidateDisplayName);
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

  void _onValidateDisplayName(
    AuthValidateDisplayNameEvent event,
    Emitter<SignUpState> emit,
  ) {
    if (event.displayName.isEmpty) {
      _displayNameError = null; // Don't show error for empty field
    } else if (event.displayName.length < 3) {
      _displayNameError = "Display name must be at least 3 characters";
    } else if (event.displayName.length > 20) {
      _displayNameError = "Display name must be at most 20 characters";
    } else {
      _displayNameError = null;
    }

    emit(AuthDisplayNameValidationState(error: _displayNameError));
  }
}

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:chat_app/presentation/cubit/auth/google_sign_in/google_sign_in_event.dart';
import 'package:chat_app/presentation/cubit/auth/google_sign_in/google_sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleSignInCubit extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final SignInWithGoogleUsecase _signInWithGoogle;

  GoogleSignInCubit({required AuthRepository authRepository})
    : _signInWithGoogle = getIt<SignInWithGoogleUsecase>(),
      super(AuthInitialState()) {
    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleEvent event,
    Emitter<GoogleSignInState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _signInWithGoogle.call();
      emit(AuthSuccessState(user: result));
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }
}

import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:chat_app/domain/usecases/sign_out_usecase.dart';
import 'package:chat_app/presentation/cubit/auth/auth_event.dart';
import 'package:chat_app/presentation/cubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Bloc<AuthEvent, AuthStates> {
  final SignInWithGoogleUsecase _signInWithGoogle;

  AuthCubit({required AuthRepository authRepository})
    : _signInWithGoogle = getIt<SignInWithGoogleUsecase>(),
      super(AuthInitial()) {
    on<AuthSignInWithGoogle>(_onSignInWithGoogle);
    // on<AuthSignInWithEmail>(_onSignInWithEmail);
    on<AuthSignOut>(_onSignOut);
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogle event,
    Emitter<AuthStates> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _signInWithGoogle.call();
      emit(AuthSuccess(user: result));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  //   Future<void> _onSignInWithEmail(
  //     AuthSignInWithEmail event,
  //     Emitter<AuthStates> emit,
  //   ) async {}

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthStates> emit) async {
    emit(AuthLoading());
    // Print all over states here using log
    // Import 'dart:developer' at the top of your file if not already imported
    // import 'dart:developer';
    log('AuthLoading emitted');
    try {
      await getIt<SignOutUsecase>().call();
      emit(AuthSuccess());
      log('AuthSuccess emitted');
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
      log('AuthFailure emitted: ${e.toString()}');
    }
  }
}

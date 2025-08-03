import 'dart:developer';

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:chat_app/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:chat_app/domain/usecases/sign_out_usecase.dart';
import 'package:chat_app/presentation/cubit/auth/auth_event.dart';
import 'package:chat_app/presentation/cubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Bloc<AuthEvent, AuthStates> {
  final SignInWithGoogleUsecase _signInWithGoogle;
  final SignOutUsecase _signOutUsecase;
  final SignInWithEmailUsecase _signInWithEmail;

  AuthCubit({required AuthRepository authRepository})
    : _signInWithGoogle = getIt<SignInWithGoogleUsecase>(),
      _signOutUsecase = getIt<SignOutUsecase>(),
      _signInWithEmail = getIt<SignInWithEmailUsecase>(),
      super(AuthInitialState()) {
    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AuthSignInWithEmailAndPasswordEvent>(_onSignInWithEmailAndPassword);
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _signInWithGoogle.call();
      emit(AuthSuccessState(user: result));
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }

  Future<void> _onSignInWithEmailAndPassword(
    AuthSignInWithEmailAndPasswordEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _signInWithEmail.call(event.email, event.password);
      emit(AuthSuccessState(user: result));
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(AuthLoadingState());
    log('AuthCubit: Starting sign out process');
    try {
      await _signOutUsecase.call();
      log('AuthCubit: Sign out successful');
      emit(AuthInitialState()); // Reset to initial state after sign out
    } catch (e) {
      log('AuthCubit: Sign out failed: ${e.toString()}');
      emit(AuthFailureState(error: e.toString()));
    }
  }
}

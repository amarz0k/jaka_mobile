import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/usecases/sign_in_with_google.dart';
import 'package:chat_app/presentation/cubit/auth/auth_event.dart';
import 'package:chat_app/presentation/cubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Bloc<AuthEvent, AuthStates> {
  final SignInWithGoogle _signInWithGoogle;

  AuthCubit({required AuthRepository authRepository})
    : _signInWithGoogle = getIt<SignInWithGoogle>(),
      super(AuthInitial()) {
    on<AuthSignInWithGoogle>(_onSignInWithGoogle);
    // on<AuthSignInWithEmail>(_onSignInWithEmail);
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
}

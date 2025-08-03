import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/cubit/auth/google_sign_in/google_sign_in_cubit.dart';
import 'package:chat_app/presentation/cubit/auth/login/login_cubit.dart';
import 'package:chat_app/presentation/cubit/auth/sign_out/sign_out_cubit.dart';
import 'package:chat_app/presentation/cubit/auth/sign_up/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService().init();

  // Initialize dependency injection
  setUpServiceLocator();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider<GoogleSignInCubit>(
          create: (_) =>
              GoogleSignInCubit(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider<SignOutCubit>(
          create: (_) => SignOutCubit(authRepository: getIt<AuthRepository>()),
        ),
      ],
      child: ToastificationWrapper(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Trebuc', useMaterial3: true),
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }
}

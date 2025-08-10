import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/presentation/bloc/auth/google_sign_in/google_sign_in_bloc.dart';
import 'package:chat_app/presentation/bloc/auth/login/login_bloc.dart';
import 'package:chat_app/presentation/bloc/auth/sign_out/sign_out_bloc.dart';
import 'package:chat_app/presentation/bloc/auth/sign_up/sign_up_bloc.dart';
import 'package:chat_app/presentation/bloc/home/settings/settings_cubit.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_cubit.dart';
import 'package:chat_app/presentation/bloc/connectivity/connectivity_cubit.dart';
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
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider<GoogleSignInBloc>(
          create: (_) =>
              GoogleSignInBloc(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider<SignOutBloc>(
          create: (_) => SignOutBloc(authRepository: getIt<AuthRepository>()),
        ),

        BlocProvider<UserDataCubit>(
          create: (_) => UserDataCubit(userRepository: getIt<UserRepository>()),
        ),

        BlocProvider<ConnectivityCubit>(create: (_) => ConnectivityCubit()),

        BlocProvider<SettingsCubit>(create: (_) => getIt<SettingsCubit>()),
      ],
      child: ToastificationWrapper(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'TTCommons',
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          ),
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }
}

import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/core/hive_service.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:chat_app/utils/routes.dart';
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
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(authRepository: getIt<AuthRepository>()),
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

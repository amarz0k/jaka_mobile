import 'package:chat_app/presentation/pages/home_page.dart';
import 'package:chat_app/presentation/pages/login_page.dart';
import 'package:chat_app/presentation/pages/sign_up_page.dart';
import 'package:chat_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.signUp: (context) => const SignUpPage(),
      },
    );
  }
}

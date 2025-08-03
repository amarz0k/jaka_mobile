import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/di/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    log("AuthGuard: Checking authentication status...");

    final user = getIt<FirebaseAuth>().currentUser;

    if (user == null) {
      log("AuthGuard: No user found, redirecting to login");
      router.replaceNamed('/login');
      return;
    }

    // log("AuthGuard: User found with UID: ${user.uid}");

    try {
      final token = await user.getIdToken();
      if (token != null) {
        log("AuthGuard: Token valid, allowing navigation");
        resolver.next(true);
        return;
      } else {
        log("AuthGuard: No valid token, redirecting to login");
        router.replaceNamed('/login');
        return;
      }
    } catch (e) {
      log("AuthGuard: Error getting token: $e, redirecting to login");
      router.replaceNamed('/login');
      return;
    }
  }
}

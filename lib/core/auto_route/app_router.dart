import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/auto_route/auth_gaurd.dart';
import 'package:chat_app/core/di/service_locator.dart';
import 'package:chat_app/presentation/pages/conversation_page.dart';
import 'package:chat_app/presentation/pages/home_page.dart';
import 'package:chat_app/presentation/pages/login_page.dart';
import 'package:chat_app/presentation/pages/setting_page.dart';
import 'package:chat_app/presentation/pages/sign_up_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: SignUpRoute.page, path: '/signup'),

    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      guards: [getIt<AuthGuard>()],
      initial: true,
    ),
    AutoRoute(
      page: SettingRoute.page,
      path: '/settings',
      guards: [getIt<AuthGuard>()],
    ),
    AutoRoute(
      page: ConversationRoute.page,
      path: '/conversation',
      guards: [getIt<AuthGuard>()],
    ),
  ];
}

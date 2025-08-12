// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ConversationRoute.name: (routeData) {
      final args = routeData.argsAs<ConversationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConversationPage(
          key: args.key,
          friendId: args.friendId,
          friendName: args.friendName,
          friendPhotoUrl: args.friendPhotoUrl,
        ),
      );
    },
    FriendDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<FriendDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FriendDetailsPage(
          key: args.key,
          friendId: args.friendId,
          friendName: args.friendName,
          friendPhotoUrl: args.friendPhotoUrl,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignUpPage(),
      );
    },
    UserProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserProfilePage(),
      );
    },
  };
}

/// generated route for
/// [ConversationPage]
class ConversationRoute extends PageRouteInfo<ConversationRouteArgs> {
  ConversationRoute({
    Key? key,
    required String friendId,
    required String friendName,
    String? friendPhotoUrl,
    List<PageRouteInfo>? children,
  }) : super(
          ConversationRoute.name,
          args: ConversationRouteArgs(
            key: key,
            friendId: friendId,
            friendName: friendName,
            friendPhotoUrl: friendPhotoUrl,
          ),
          initialChildren: children,
        );

  static const String name = 'ConversationRoute';

  static const PageInfo<ConversationRouteArgs> page =
      PageInfo<ConversationRouteArgs>(name);
}

class ConversationRouteArgs {
  const ConversationRouteArgs({
    this.key,
    required this.friendId,
    required this.friendName,
    this.friendPhotoUrl,
  });

  final Key? key;

  final String friendId;

  final String friendName;

  final String? friendPhotoUrl;

  @override
  String toString() {
    return 'ConversationRouteArgs{key: $key, friendId: $friendId, friendName: $friendName, friendPhotoUrl: $friendPhotoUrl}';
  }
}

/// generated route for
/// [FriendDetailsPage]
class FriendDetailsRoute extends PageRouteInfo<FriendDetailsRouteArgs> {
  FriendDetailsRoute({
    Key? key,
    required String friendId,
    required String friendName,
    String? friendPhotoUrl,
    List<PageRouteInfo>? children,
  }) : super(
          FriendDetailsRoute.name,
          args: FriendDetailsRouteArgs(
            key: key,
            friendId: friendId,
            friendName: friendName,
            friendPhotoUrl: friendPhotoUrl,
          ),
          initialChildren: children,
        );

  static const String name = 'FriendDetailsRoute';

  static const PageInfo<FriendDetailsRouteArgs> page =
      PageInfo<FriendDetailsRouteArgs>(name);
}

class FriendDetailsRouteArgs {
  const FriendDetailsRouteArgs({
    this.key,
    required this.friendId,
    required this.friendName,
    this.friendPhotoUrl,
  });

  final Key? key;

  final String friendId;

  final String friendName;

  final String? friendPhotoUrl;

  @override
  String toString() {
    return 'FriendDetailsRouteArgs{key: $key, friendId: $friendId, friendName: $friendName, friendPhotoUrl: $friendPhotoUrl}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserProfilePage]
class UserProfileRoute extends PageRouteInfo<void> {
  const UserProfileRoute({List<PageRouteInfo>? children})
      : super(
          UserProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

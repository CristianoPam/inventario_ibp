import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventario_ibp/pages/pages.dart';
import 'package:inventario_ibp/services/auth_services.dart';
import '../pages/email_verify_page.dart';
import '../pages/login_page.dart';
import '../pages/settings_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/settings',
    redirect: (BuildContext context, GoRouterState state) {
      if (authService.status == AuthStatus.signedOut) {
        return '/login';
      } else if (authService.status == AuthStatus.emailVerifyPending) {
        return '/email-verify';
      } else if (authService.status == AuthStatus.signedIn &&
          state.location.contains('/login')) {
        return '/settings';
      }
      return '/page';
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/email-verify',
        builder: (BuildContext context, GoRouterState state) {
          return const EmailVerifyPage();
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {          
          return const SettingsPage();
        },
      ),
      GoRoute(
        path: '/page',
        builder: (BuildContext context, GoRouterState state) {
          return const Pages();
        },
      ),
      
    ],
  );
});

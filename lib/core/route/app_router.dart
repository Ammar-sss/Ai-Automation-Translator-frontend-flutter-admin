import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_translater_admin/core/route/app_routes.dart';
import 'package:smart_translater_admin/core/widgets/main_shell.dart';
import 'package:smart_translater_admin/feature/auth/presentation/controller/auth_bloc.dart';
import 'package:smart_translater_admin/feature/auth/presentation/pages/login_page.dart';
import 'package:smart_translater_admin/feature/dashboard/presentation/pages/dashboard.dart';
import 'package:smart_translater_admin/feature/sitting/presentation/pages/sitting.dart';

class OnRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  OnRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthBloc _authBloc;

  AppRouter({required this._authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: OnRouterRefreshStream(_authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) async {
      final authState = _authBloc.state;
      final String currentLocation = state.matchedLocation;

      final bool isLoggingIn = currentLocation == AppRoutes.login;
      final bool isSplash = currentLocation == AppRoutes.splash;

      if (authState is AuthInitial) {
        return isSplash ? null : AppRoutes.splash;
      }

      final bool isAuthenticated = authState is AuthAuthenticated;

      if (!isAuthenticated && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (isAuthenticated && (isSplash || isLoggingIn)) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text("splash screen"))),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const Dashboard(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const Sitting(),
          ),
        ],
      ),
    ],
  );
}

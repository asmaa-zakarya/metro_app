import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/models/station.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/metro_map/map_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.map,
        name: RouteNames.map,
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: RouteNames.booking,
        name: RouteNames.booking,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final from = extra?['from'] as Station?;
          final to = extra?['to'] as Station?;
          return Scaffold(
            body: Center(
              child: Text('Booking: ${from?.nameAr} -> ${to?.nameAr}'),
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.ticket,
        name: RouteNames.ticket,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Tickets Screen')),
        ),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings Screen')),
        ),
      ),
    ],
  );
}
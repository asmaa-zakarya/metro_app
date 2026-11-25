// lib/core/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/home/models/station.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/metro_map/map_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/tickets/screens/ticketsData.dart';
import '../../features/tickets/screens/tickets_screen.dart';
import 'booking_arguments.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/metro_map/map_screen.dart';
import '../../features/tickets/screens/tickets_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
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
        // لو اتفتحت من غير محطات نرجع للرئيسية
        redirect: (context, state) {
          final extra = state.extra;
          final valid = extra is Map &&
              extra['from'] is Station &&
              extra['to'] is Station;
          return valid ? null : RouteNames.home;
        },
        builder: (context, state) {
          final arguments = state.extra is BookingArguments
              ? state.extra as BookingArguments
              : null;
          return BookingScreen(arguments: arguments);
        },
      ),
      GoRoute(
        path: RouteNames.ticket,
        name: RouteNames.ticket,
        builder: (context, state) => const TicketsScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

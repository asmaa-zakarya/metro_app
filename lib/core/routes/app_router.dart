// lib/core/routes/app_router.dart
import 'package:material_ui/material_ui.dart';
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
import '../../features/booking/models/trip_booking.dart';
import '../../features/booking/screens/booking_review_screen.dart';
import '../../features/booking/screens/booking_setup_screen.dart';
import '../../features/booking/screens/booking_success_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/booking/screens/trip_details_screen.dart';
import '../../features/tickets/screens/ticket_details_screen.dart';

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
          final extra = state.extra as Map<String, dynamic>;
          return RoutesScreen(
            from: extra['from'] as Station,
            to: extra['to'] as Station,
          );
        },
      ),
      GoRoute(
        path: RouteNames.ticket,
        name: RouteNames.ticket,
        // فاضية لحد ما المستخدم يحجز
        builder: (context, state) =>
            TicketsScreen(tickets: List.of(TicketsData.booked)),      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      ..._bookingFlowRoutes,
    ],
  );

  /// Booking flow screens. Without a booking in `extra` (a refresh or a deep
  /// link) they go back Home; the last two also need a paid booking.
  static final List<GoRoute> _bookingFlowRoutes = [
    _bookingRoute(
      RouteNames.tripDetails,
      (booking, _) => TripDetailsScreen(booking: booking),
    ),
    _bookingRoute(
      RouteNames.bookingSetup,
      (booking, _) => BookingSetupScreen(booking: booking),
    ),
    _bookingRoute(
      RouteNames.bookingReview,
      (booking, _) => BookingReviewScreen(booking: booking),
    ),
    _bookingRoute(
      RouteNames.payment,
      (booking, _) => PaymentScreen(booking: booking),
    ),
    _bookingRoute(
      RouteNames.bookingSuccess,
      (booking, _) => BookingSuccessScreen(booking: booking),
      requiresPayment: true,
    ),
    // `?ticket=<id>` opens the pager on that ticket (from the Tickets tab).
    _bookingRoute(
      RouteNames.ticketDetails,
      (booking, state) => TicketDetailsScreen(
        booking: booking,
        initialTicketId: state.uri.queryParameters['ticket'],
      ),
      requiresPayment: true,
    ),
  ];

  static GoRoute _bookingRoute(
    String path,
    Widget Function(TripBooking booking, GoRouterState state) screen, {
    bool requiresPayment = false,
  }) {
    return GoRoute(
      path: path,
      name: path,
      redirect: (context, state) {
        final extra = state.extra;
        final isValid =
            extra is TripBooking &&
            (!requiresPayment || extra.bookingNumber != null);
        return isValid ? null : RouteNames.home;
      },
      builder: (context, state) => screen(state.extra as TripBooking, state),
    );
  }
}

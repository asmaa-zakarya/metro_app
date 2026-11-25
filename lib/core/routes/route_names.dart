class RouteNames {
  RouteNames._();

  static const String home = '/';
  static const String booking = '/booking';
  static const String map = '/map';
  static const String settings = '/settings';
  static const String ticket = '/ticket';

  // Booking flow (each expects a TripBooking as `extra`).
  static const String tripDetails = '/trip-details';
  static const String bookingSetup = '/booking-setup';
  static const String bookingReview = '/booking-review';
  static const String payment = '/payment';
  static const String bookingSuccess = '/booking-success';
  static const String ticketDetails = '/ticket-details';
}

import '../../home/models/station.dart';
import '../logic/fareCalculator.dart';
import '../logic/routePlanner.dart';

enum PaymentMethod { bankCard, eWallet }

/// Everything the booking flow collects, passed from screen to screen.
class TripBooking {
  static const int minTickets = 1;
  static const int maxTickets = 10;

  final Station from;
  final Station to;
  final RouteOption route;
  final DateTime travelDate;
  final int ticketCount;
  final PaymentMethod paymentMethod;

  /// Set once the booking is paid.
  final String? bookingNumber;

  const TripBooking({
    required this.from,
    required this.to,
    required this.route,
    required this.travelDate,
    required this.ticketCount,
    required this.paymentMethod,
    this.bookingNumber,
  });

  /// A new booking for today: one ticket, paid by bank card.
  factory TripBooking.start({
    required Station from,
    required Station to,
    required RouteOption route,
    required DateTime today,
  }) {
    return TripBooking(
      from: from,
      to: to,
      route: route,
      travelDate: DateTime(today.year, today.month, today.day),
      ticketCount: minTickets,
      paymentMethod: PaymentMethod.bankCard,
    );
  }

  int get pricePerTicket => FareCalculator.calculateFare(
    route.stationCount,
    PassengerType.general,
  ).price;

  int get totalPrice => pricePerTicket * ticketCount;

  /// One id per ticket, e.g. CM-9460589 → T-460589-1, T-460589-2.
  List<String> get ticketIds {
    final number = bookingNumber;
    if (number == null) return const [];
    final digits = number.replaceAll(RegExp(r'\D'), '');
    final shortCode = digits.substring(digits.length - 6);
    return [for (var n = 1; n <= ticketCount; n++) 'T-$shortCode-$n'];
  }

  TripBooking copyWith({
    DateTime? travelDate,
    int? ticketCount,
    PaymentMethod? paymentMethod,
    String? bookingNumber,
  }) {
    return TripBooking(
      from: from,
      to: to,
      route: route,
      travelDate: travelDate ?? this.travelDate,
      ticketCount: (ticketCount ?? this.ticketCount).clamp(
        minTickets,
        maxTickets,
      ),
      paymentMethod: paymentMethod ?? this.paymentMethod,
      bookingNumber: bookingNumber ?? this.bookingNumber,
    );
  }

  /// CM- followed by the last seven digits of the current time.
  static String newBookingNumber(DateTime now) {
    final digits = now.microsecondsSinceEpoch.toString().padLeft(7, '0');
    return 'CM-${digits.substring(digits.length - 7)}';
  }
}

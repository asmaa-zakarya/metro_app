import 'trip_booking.dart';

/// Paid bookings kept in memory for this app session, so a ticket in the
/// Tickets tab can reopen its QR screen with the full booking.
class PaidBookings {
  PaidBookings._();

  static final Map<String, TripBooking> _byTicketId = {};

  static void add(TripBooking booking) {
    for (final ticketId in booking.ticketIds) {
      _byTicketId[ticketId] = booking;
    }
  }

  static TripBooking? forTicket(String ticketId) => _byTicketId[ticketId];
}

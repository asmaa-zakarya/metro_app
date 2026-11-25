// lib/features/tickets/models/ticket.dart
import '../../home/models/station.dart';

class Ticket {
  final String id;
  final Station from;
  final Station to;
  final DateTime date;
  final int? price;

  const Ticket({
    required this.id,
    required this.from,
    required this.to,
    required this.date,
    this.price,
  });
}

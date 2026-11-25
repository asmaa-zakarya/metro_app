// lib/features/tickets/data/tickets_data.dart
import 'package:metro_app/features/tickets/screens/ticket.dart';

import '../../home/data/station_data.dart';
import '../../home/models/station.dart';

/// بيانات تجريبية لحد ما تربطي الحجز الحقيقي

/// التذاكر المحجوزة (في الذاكرة بس حالياً)
class TicketsData {
  TicketsData._();

  static final List<Ticket> booked = [];

  /// الأحدث يظهر فوق
  static void add(Ticket ticket) => booked.insert(0, ticket);
}
import '../../features/home/models/station.dart';

class BookingArguments {
  final Station from;
  final Station to;

  const BookingArguments({required this.from, required this.to});
}

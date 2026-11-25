import 'routePlanner.dart';

/// One ride on one line, as the trip details timeline shows it.
class JourneyLeg {
  final int line;
  final String boardStation;
  final String endStation;

  /// Stations the train passes between [boardStation] and [endStation].
  final List<String> stationsBetween;

  const JourneyLeg({
    required this.line,
    required this.boardStation,
    required this.endStation,
    required this.stationsBetween,
  });
}

/// A station on the trip, tagged with the line the rider arrives on.
class RouteStop {
  final String station;
  final int line;

  const RouteStop({required this.station, required this.line});
}

List<JourneyLeg> journeyLegs(RouteOption route) {
  return [
    for (final leg in route.legs)
      JourneyLeg(
        line: leg.line,
        boardStation: leg.stations.first,
        endStation: leg.stations.last,
        stationsBetween: leg.stations.length > 2
            ? leg.stations.sublist(1, leg.stations.length - 1)
            : const [],
      ),
  ];
}

List<RouteStop> routeStops(RouteOption route) {
  final stops = <RouteStop>[];
  for (final leg in route.legs) {
    // A transfer station already closes the previous leg.
    final stations = stops.isEmpty ? leg.stations : leg.stations.skip(1);
    for (final station in stations) {
      stops.add(RouteStop(station: station, line: leg.line));
    }
  }
  return stops;
}

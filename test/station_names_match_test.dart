import 'package:flutter_test/flutter_test.dart';
import 'package:metro_app/features/booking/data.dart';
import 'package:metro_app/features/booking/logic/routePlanner.dart';
import 'package:metro_app/features/home/data/station_data.dart';

/// The route planner (MetroData) finds stations by the English name the user
/// picked on Home (StationsData). When the two lists spell a station
/// differently, every trip to or from it shows "no route".
void main() {
  test('the route planner knows every station listed on Home', () {
    final missing = StationsData.all
        .where((station) => MetroData.network.findStation(station.nameEn) == null)
        .map((station) => '${station.nameEn} (${station.nameAr})')
        .toList();

    expect(missing, isEmpty, reason: 'Spelled differently in booking/data.dart');
  });

  test('the route planner shows the same Arabic name as Home', () {
    // Route screens name stations by the planner's own spelling.
    String plannerArabic(String nameEn) => MetroData.stationName(
          MetroData.network.findStation(nameEn) ?? nameEn,
          isArabic: true,
        );
    final different = StationsData.all
        .where((station) => plannerArabic(station.nameEn) != station.nameAr)
        .map((station) =>
            '${station.nameEn}: Home "${station.nameAr}", '
            'planner "${plannerArabic(station.nameEn)}"')
        .toList();

    expect(different, isEmpty);
  });

  test('every Home station has a route to and from Sadat', () {
    // Sadat is the central interchange (lines 1 and 2); a station that
    // reaches it both ways is connected to the rest of the network.
    const hub = 'Sadat';
    const planner = RoutePlanner(MetroData.network);
    final noRoute = <String>[];
    for (final station in StationsData.all) {
      if (station.nameEn == hub) continue;
      if (planner.planRoutes(station.nameEn, hub).isEmpty) {
        noRoute.add('${station.nameEn} -> $hub');
      }
      if (planner.planRoutes(hub, station.nameEn).isEmpty) {
        noRoute.add('$hub -> ${station.nameEn}');
      }
    }

    expect(noRoute, isEmpty);
  });
}

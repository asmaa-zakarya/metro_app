import 'metroLine.dart';
import 'metroNetwork.dart';


/// جزء من الرحلة على خط واحد
class RouteLeg {
  final int line;
  final List<String> stations;

  /// نهاية الخط في اتجاه الركوب (ممكن اتنين في تفريعة الخط التالت)
  final List<String> toward;

  const RouteLeg({
    required this.line,
    required this.stations,
    required this.toward,
  });
}

class RouteOption {
  final List<RouteLeg> legs;
  final int minutes;

  const RouteOption({required this.legs, required this.minutes});

  List<String> get path => [
    ...legs.first.stations,
    for (final leg in legs.skip(1)) ...leg.stations.skip(1),
  ];

  int get stationCount => path.length;
  int get transfers => legs.length - 1;
}

class RoutePlanner {
  final MetroNetwork network;
  final int minutesPerStation = 2;
  final int transferMinutes = 5;

  const RoutePlanner(this.network);

  /// أحسن الطرق (لحد تبديلين) مرتبة من الأسرع
  List<RouteOption> planRoutes(String startInput, String endInput, {int limit = 3}) {
    final start = network.findStation(startInput);
    final end = network.findStation(endInput);
    if (start == null || end == null || start == end) return [];

    // أسرع طريق لكل تركيبة خطوط، عشان الاختيارات تبقى مختلفة فعلاً
    final best = <String, RouteOption>{};

    void search(String from, List<RouteLeg> legs, Set<String> visited) {
      for (final line in network.lines) {
        if (!line.containsStation(from)) continue;

        // آخر خطوة: نوصل للوجهة على الخط ده
        final targets = [
          if (line.containsStation(end)) end,
          if (legs.length < 2)
            ...network.transferStations.where(
                  (t) => t != from && t != end && line.containsStation(t),
            ),
        ];

        for (final to in targets) {
          if (legs.isNotEmpty && legs.last.line == line.number) {
            // نفس الخط مرتين مسموح بس للتبديل بين تفريعتين الخط التالت
            final previousStart = legs.last.stations.first;
            final sameTrain = network.lines.any((l) =>
            l.number == line.number &&
                l.containsStation(previousStart) &&
                l.containsStation(to));
            if (sameTrain) continue;
          }

          final stations = line.getSubRoute(from, to);
          if (stations.skip(1).any(visited.contains)) continue;

          final newLegs = [...legs, _leg(line, stations)];
          if (to == end) {
            _keepIfBetter(best, newLegs);
          } else {
            search(to, newLegs, {...visited, ...stations});
          }
        }
      }
    }

    search(start, [], {start});

    final routes = best.values.toList()
      ..sort((a, b) {
        final byTime = a.minutes.compareTo(b.minutes);
        return byTime != 0 ? byTime : a.transfers.compareTo(b.transfers);
      });
    if (routes.isEmpty) return [];

    // نستبعد الطرق الأطول بكتير من الأسرع
    final maxMinutes = routes.first.minutes * 1.7;
    return routes.where((r) => r.minutes <= maxMinutes).take(limit).toList();
  }

  RouteLeg _leg(MetroLine line, List<String> stations) {
    final toward = <String>{
      for (final l in network.lines)
        if (l.number == line.number && stations.every(l.containsStation))
          l.terminalToward(stations.first, stations.last),
    };
    return RouteLeg(line: line.number, stations: stations, toward: toward.toList());
  }

  void _keepIfBetter(Map<String, RouteOption> best, List<RouteLeg> legs) {
    final hops = legs.fold<int>(0, (sum, leg) => sum + leg.stations.length - 1);
    final option = RouteOption(
      legs: legs,
      minutes: hops * minutesPerStation + (legs.length - 1) * transferMinutes,
    );
    final key = legs.map((leg) => leg.line).join('-');
    final current = best[key];
    if (current == null || option.minutes < current.minutes) best[key] = option;
  }
}

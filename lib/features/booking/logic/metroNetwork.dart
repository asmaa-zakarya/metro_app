import 'metroLine.dart';

class MetroNetwork {
  final List<MetroLine> lines;
  final List<String> transferStations;

  const MetroNetwork({required this.lines, required this.transferStations});

  String clean(String name) =>
      name.toLowerCase().replaceAll(RegExp(r'[\-\.\s]'), '').trim();

  /// يرجع الاسم الرسمي للمحطة أو null
  String? findStation(String name) {
    final target = clean(name);
    for (final line in lines) {
      for (final station in line.stations) {
        if (clean(station) == target) return station;
      }
    }
    return null;
  }

  List<String> getAllUniqueStations() {
    final unique = <String>{};
    for (final line in lines) {
      unique.addAll(line.stations);
    }
    return unique.toList()..sort();
  }
}

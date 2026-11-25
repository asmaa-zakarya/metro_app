/// خط مترو: اسم + محطات بالترتيب
class MetroLine {
  final String name;
  final List<String> stations;

  const MetroLine({required this.name, required this.stations});

  /// رقم الخط من اسمه، مثلاً 'Line 3' -> 3
  int get number => int.parse(name.split(' ').last);

  String _clean(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'[\-\.\s]'), '').trim();

  int _indexOf(String station) =>
      stations.indexWhere((s) => _clean(s) == _clean(station));

  bool containsStation(String name) => _indexOf(name) != -1;

  /// آخر محطة في اتجاه الحركة
  String terminalToward(String start, String end) =>
      _indexOf(start) < _indexOf(end) ? stations.last : stations.first;

  List<String> getSubRoute(String start, String end) {
    final s = _indexOf(start);
    final e = _indexOf(end);

    if (s == -1 || e == -1) return [];
    return s <= e
        ? stations.sublist(s, e + 1)
        : stations.sublist(e, s + 1).reversed.toList();
  }
}

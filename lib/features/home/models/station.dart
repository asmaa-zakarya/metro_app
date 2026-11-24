class Station {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<int> lines;
  final double lat;
  final double lng;
  final double? distanceKm;

  const Station({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.lines,
    required this.lat,
    required this.lng,
    this.distanceKm,
  });

  bool get isInterchange => lines.length > 1;

  Station copyWith({double? distanceKm}) {
    return Station(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      lines: lines,
      lat: lat,
      lng: lng,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}
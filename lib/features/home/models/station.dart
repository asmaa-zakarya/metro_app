
class Station {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<int> lines;

  // Coordinates are nullable until verified.
  final double? lat;
  final double? lng;

  final double? distanceKm;

  const Station({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.lines,
    this.lat,
    this.lng,
    this.distanceKm,
  });

  bool get isInterchange => lines.length > 1;

  bool get hasCoordinates => lat != null && lng != null;

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

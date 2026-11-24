import 'package:geolocator/geolocator.dart';
import '../models/station.dart';

class StationsData {
  StationsData._();

  static const List<Station> all = [
    Station(id: '1', nameAr: 'إمبابة', nameEn: 'Imbaba', lines: [3], lat: 30.0755, lng: 31.2085),
    Station(id: '2', nameAr: 'البوهي', nameEn: 'El-Bohi', lines: [3], lat: 30.0702, lng: 31.2015),
    Station(id: '3', nameAr: 'الطريق الدائري', nameEn: 'Ring Road', lines: [3], lat: 30.0640, lng: 31.1950),
    Station(id: '4', nameAr: 'محور روض الفرج', nameEn: 'Rod El-Farag Axis', lines: [3], lat: 30.0585, lng: 31.1900),
    Station(id: '5', nameAr: 'التوفيقية', nameEn: 'El-Tawfikeya', lines: [3], lat: 30.0525, lng: 31.1945),
    Station(id: '6', nameAr: 'وادي النيل', nameEn: 'Wadi El-Nil', lines: [3], lat: 30.0532, lng: 31.2012),
    Station(id: '7', nameAr: 'جامعة الدول', nameEn: 'Gamaet El-Dewal', lines: [3], lat: 30.0478, lng: 31.2045),
    Station(id: '8', nameAr: 'بولاق الدكرور', nameEn: 'Boulaq El-Dakrour', lines: [3], lat: 30.0365, lng: 31.1985),
    Station(id: '9', nameAr: 'السودان', nameEn: 'El-Sudan', lines: [3], lat: 30.0430, lng: 31.2030),
    Station(id: '10', nameAr: 'جامعة القاهرة', nameEn: 'Cairo University', lines: [2, 3], lat: 30.0261, lng: 31.2011),
    Station(id: '11', nameAr: 'الدقي', nameEn: 'Dokki', lines: [2], lat: 30.0384, lng: 31.2122),
    Station(id: '12', nameAr: 'الأوبرا', nameEn: 'Opera', lines: [2], lat: 30.0419, lng: 31.2244),
    Station(id: '13', nameAr: 'العتبة', nameEn: 'Ataba', lines: [2, 3], lat: 30.0525, lng: 31.2468),
    Station(id: '14', nameAr: 'مسرة', nameEn: 'Masarra', lines: [2], lat: 30.0825, lng: 31.2456),
    Station(id: '15', nameAr: 'شبرا الخيمة', nameEn: 'Shubra El-Kheima', lines: [2], lat: 30.1225, lng: 31.2448),
    Station(id: '16', nameAr: 'عدلي منصور', nameEn: 'Adly Mansour', lines: [3], lat: 30.1456, lng: 31.4214),
    Station(id: '17', nameAr: 'هليوبوليس', nameEn: 'Heliopolis', lines: [3], lat: 30.0908, lng: 31.3248),
    Station(id: '18', nameAr: 'حلوان', nameEn: 'Helwan', lines: [1], lat: 29.8490, lng: 31.3342),
    Station(id: '19', nameAr: 'المعادي', nameEn: 'Maadi', lines: [1], lat: 29.9602, lng: 31.2578),
    Station(id: '20', nameAr: 'الزهراء', nameEn: 'El-Zahraa', lines: [1], lat: 29.9955, lng: 31.2312),
    Station(id: '21', nameAr: 'السيدة زينب', nameEn: 'Sayeda Zeinab', lines: [1], lat: 30.0294, lng: 31.2355),
    Station(id: '22', nameAr: 'سعد زغلول', nameEn: 'Saad Zaghloul', lines: [1], lat: 30.0368, lng: 31.2382),
    Station(id: '23', nameAr: 'السادات', nameEn: 'Sadat', lines: [1, 2], lat: 30.0444, lng: 31.2357),
    Station(id: '24', nameAr: 'جمال عبد الناصر', nameEn: 'Gamal Abdel Nasser', lines: [1, 3], lat: 30.0535, lng: 31.2387),
    Station(id: '25', nameAr: 'عرابي', nameEn: 'Orabi', lines: [1], lat: 30.0568, lng: 31.2422),
  ];

  static List<Station> nearestFromLocation(double userLat, double userLng, {int limit = 4}) {
    final withDistance = all.map((station) {
      final meters = Geolocator.distanceBetween(
        userLat,
        userLng,
        station.lat,
        station.lng,
      );
      final km = double.parse((meters / 1000).toStringAsFixed(1));
      return station.copyWith(distanceKm: km);
    }).toList();

    withDistance.sort((a, b) => (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));
    return withDistance.take(limit).toList();
  }
}
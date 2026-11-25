import 'arabicFormat.dart';

/// Day and month names in Arabic and English, without the intl package.
class DateLabels {
  DateLabels._();

  // Indexed by DateTime.weekday - 1 (Monday first).
  static const _arabicWeekdays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];
  static const _englishWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Indexed by DateTime.month - 1.
  static const _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  static const _englishMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String weekday(DateTime date, {required bool isArabic}) =>
      (isArabic ? _arabicWeekdays : _englishWeekdays)[date.weekday - 1];

  static String dayNumber(DateTime date, {required bool isArabic}) =>
      ArabicFormat.number(date.day, isArabic: isArabic);

  /// e.g. "٢٥ نوفمبر ٢٠٢٦" / "25 November 2026".
  static String fullDate(DateTime date, {required bool isArabic}) {
    final month = (isArabic ? _arabicMonths : _englishMonths)[date.month - 1];
    final year = ArabicFormat.number(date.year, isArabic: isArabic);
    return '${dayNumber(date, isArabic: isArabic)} $month $year';
  }
}

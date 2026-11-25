class ArabicFormat {
  ArabicFormat._();

  static String number(int value, {required bool isArabic}) {
    final text = value.toString();
    if (!isArabic) return text;
    const digits = '٠١٢٣٤٥٦٧٨٩';
    return text.replaceAllMapped(
      RegExp(r'[0-9]'),
          (m) => digits[int.parse(m[0]!)],
    );
  }

  static String stations(int count, {required bool isArabic}) {
    if (!isArabic) return count == 1 ? '1 station' : '$count stations';
    if (count == 1) return 'محطة واحدة';
    if (count == 2) return 'محطتان';
    final word = count % 100 >= 3 && count % 100 <= 10 ? 'محطات' : 'محطة';
    return '${number(count, isArabic: true)} $word';
  }

  static String transfers(int count, {required bool isArabic}) {
    if (count == 0) return isArabic ? 'بدون تبديل' : 'No transfers';
    if (!isArabic) return count == 1 ? '1 transfer' : '$count transfers';
    if (count == 1) return 'تبديل واحد';
    if (count == 2) return 'تبديلان';
    return '${number(count, isArabic: true)} تبديلات';
  }
}

// lib/core/constants/metro_constants.dart
import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class MetroConstants {
  MetroConstants._();

  static Color lineColor(int lineNumber) {
    switch (lineNumber) {
      case 1:
        return AppColors.line1;
      case 2:
        return AppColors.line2;
      case 3:
        return AppColors.line3;
      default:
        return AppColors.activeBlue;
    }
  }

  static String lineLabel(int lineNumber, {bool isArabic = true}) {
    return isArabic ? 'خط $lineNumber' : 'Line $lineNumber';
  }
}
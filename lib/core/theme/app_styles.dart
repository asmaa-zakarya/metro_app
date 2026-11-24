import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  AppStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
  }) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle get appTitle => _base(
    size: 18,
    weight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static TextStyle get heroTitle => _base(
    size: 28,
    weight: FontWeight.w800,
    color: Colors.white,
    height: 1.25,
  );

  static TextStyle get heroSubtitle => _base(
    size: 13,
    weight: FontWeight.w400,
    color: Colors.white,
    height: 1.45,
  );

  static TextStyle get cardTitle => _base(
    size: 15,
    weight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle get bodyMuted => _base(
    size: 12,
    weight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle get buttonLabel => _base(
    size: 14,
    weight: FontWeight.w700,
    color: Colors.white,
  );
}
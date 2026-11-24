import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_assets.dart';

class HeroBanner extends StatelessWidget {
  final bool isArabic;

  const HeroBanner({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final imagePath =
    isArabic ? AppAssets.heroPlatform : AppAssets.heroPlatformEn;

    return SizedBox(
      height: 265.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF14222B),
              child: Icon(
                Icons.train_rounded,
                size: 72.sp,
                color: Colors.white24,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x730B1318),
                  Color(0xE60B1318),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 56.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isArabic
                      ? 'مرحباً بك في مترو القاهرة'
                      : 'Welcome to Cairo Metro',
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isArabic ? 'إلى أين تريد\nالذهاب؟' : 'Where do you\nwant to go?',
                  style: GoogleFonts.cairo(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.18,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  isArabic
                      ? 'خطّط رحلتك عبر خطوط مترو القاهرة، وتعرّف إلى الاتجاهات ومحطات التبديل قبل الانطلاق.'
                      : 'Plan your trip across Cairo Metro lines, directions, and transfer stations before departure.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.95),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
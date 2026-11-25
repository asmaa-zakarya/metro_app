import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class MapHeaderSection extends StatelessWidget {
  final bool isArabic;

  const MapHeaderSection({
    super.key,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'خريطة مترو القاهرة' : 'Cairo Metro Map',
            style: GoogleFonts.cairo(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.25,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            isArabic
                ? 'استعرض خطوط الشبكة ومحطاتها، واستخدم أدوات التكبير لقراءة التفاصيل.'
                : 'Browse network lines and stations, and use zoom controls to read details.',
            style: GoogleFonts.cairo(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
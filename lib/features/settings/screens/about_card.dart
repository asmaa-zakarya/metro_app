// lib/features/settings/view/widgets/about_card.dart
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';


class AboutCard extends StatelessWidget {
  final bool isArabic;

  const AboutCard({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryRed, width: 6.4.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFF08526D),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(Icons.train_rounded, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            isArabic ? 'عن المشروع' : 'About the Project',
            style: AppStyles.cardTitle.copyWith(
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            isArabic
                ? 'خطّط رحلاتك داخل شبكة مترو القاهرة، وقارن الطرق واحفظ تذاكرك في مكان واحد.'
                : 'Plan your trips across the Cairo Metro network, compare routes, and keep your tickets in one place.',
            style: AppStyles.bodyMuted.copyWith(
              fontSize: 11.sp,
              height: 1.9,
              color: const Color(0xFFB8CAC4),
            ),
          ),
          SizedBox(height: 18.h),
          // ألوان الخطوط التلاتة
          Row(
            children: [
              _lineStrip(const Color(0xFF1654A3)),
              SizedBox(width: 4.w),
              _lineStrip(const Color(0xFFD82932)),
              SizedBox(width: 4.w),
              _lineStrip(const Color(0xFF008C70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _lineStrip(Color color) {
    return Expanded(child: Container(height: 6.h, color: color));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class MapCard extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onTap;

  const MapCard({
    super.key,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.r),
      side: const BorderSide(color: AppColors.border),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        color: AppColors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.map_outlined,
                    color: AppColors.primaryRed,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'الخريطة' : 'Metro Map',
                        style: AppStyles.cardTitle.copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        isArabic
                            ? 'استكشف الخطوط ومحطات التبديل'
                            : 'Explore lines and transfer stations',
                        style: AppStyles.bodyMuted.copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textMuted,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
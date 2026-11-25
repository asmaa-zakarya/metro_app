import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../../home/view/widgets/line_badge.dart';
import '../logic/fareCalculator.dart';
import '../logic/routePlanner.dart';

class RouteCard extends StatelessWidget {
  final RouteOption route;
  final bool isFastest;
  final bool isArabic;
  final VoidCallback onDetails;

  const RouteCard({
    super.key,
    required this.route,
    required this.isFastest,
    required this.isArabic,
    required this.onDetails,
  });

  static const Color _green = Color(0xFF168A4A);

  @override
  Widget build(BuildContext context) {
    final fare = FareCalculator.calculateFare(
      route.stationCount,
      PassengerType.general,
    );
    final lines = route.legs.map((leg) => leg.line).toSet();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isFastest ? _green : AppColors.border,
          width: isFastest ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isFastest)
            Container(
              color: _green,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Icon(Icons.bolt_rounded, color: Colors.white, size: 16.sp),
                  SizedBox(width: 7.w),
                  Text(
                    isArabic ? 'الأسرع تقديريًا' : 'Estimated fastest',
                    style: AppStyles.buttonLabel.copyWith(fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      ArabicFormat.number(route.minutes, isArabic: isArabic),
                      style: AppStyles.heroTitle.copyWith(
                        fontSize: 34.sp,
                        height: 1,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isArabic ? 'دقيقة' : 'min',
                      style: AppStyles.bodyMuted.copyWith(fontSize: 11.sp),
                    ),
                    const Spacer(),
                    for (final line in lines)
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 5.w),
                        child: LineBadge(lineNumber: line, isArabic: isArabic),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),
                const Divider(height: 1, color: AppColors.border),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      _info(
                        Icons.location_on_outlined,
                        ArabicFormat.stations(route.stationCount, isArabic: isArabic),
                      ),
                      _info(
                        Icons.swap_horiz_rounded,
                        ArabicFormat.transfers(route.transfers, isArabic: isArabic),
                      ),
                      _info(
                        Icons.payments_outlined,
                        '${ArabicFormat.number(fare.price, isArabic: isArabic)} '
                            '${isArabic ? 'جنيه للفرد' : 'EGP each'}',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                if (isFastest) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(9.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F6EB),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      isArabic
                          ? 'نقترحه لأنه الأسرع وفق الزمن التقديري'
                          : 'Suggested because it has the shortest estimated time',
                      style: AppStyles.bodyMuted.copyWith(
                        fontSize: 10.sp,
                        color: const Color(0xFF0F6F3A),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(48.h),
                    foregroundColor: AppColors.textDark,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                  child: Text(
                    isArabic ? 'تفاصيل الطريق' : 'Route details',
                    style: AppStyles.cardTitle.copyWith(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textMuted),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppStyles.bodyMuted.copyWith(fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }
}

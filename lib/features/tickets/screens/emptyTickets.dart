// lib/features/tickets/view/widgets/empty_tickets.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class EmptyTickets extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onPlanTrip;

  const EmptyTickets({
    super.key,
    required this.isArabic,
    required this.onPlanTrip,
  });

  static const Color _buttonColor = Color(0xFF1877F2);
  static const Color _buttonShadow = Color(0xFF0F5FC4);
  static const Color _iconBg = Color(0xFFF8E9EA);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 90.h, 20.w, 55.h),
      child: Column(
        children: [
          Transform.rotate(
            angle: -0.09,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.confirmation_number_outlined,
                color: AppColors.primaryRed,
                size: 40.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            isArabic ? 'لا توجد لديك تذاكر' : 'You have no tickets',
            textAlign: TextAlign.center,
            style: AppStyles.cardTitle.copyWith(fontSize: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            isArabic
                ? 'ابدأ بتحديد محطة الركوب والوصول، وسنقترح عليك أفضل طريق.'
                : 'Choose your departure and arrival stations, and we will suggest the best route.',
            textAlign: TextAlign.center,
            style: AppStyles.bodyMuted.copyWith(fontSize: 14.sp, height: 1.8),
          ),
          SizedBox(height: 26.h),
          Container(
            width: 260.w,
            height: 54.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.r),
              boxShadow: [
                BoxShadow(color: _buttonShadow, offset: Offset(0, 4.h)),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPlanTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.r),
                ),
              ),
              child: Text(
                isArabic ? 'خطط لرحلتك' : 'Plan your trip',
                style: AppStyles.buttonLabel.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

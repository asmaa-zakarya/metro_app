import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../models/trip_booking.dart';

/// Price per person at the start and the total, in red, at the end,
/// between two dividers.
class FareTotalRow extends StatelessWidget {
  final TripBooking booking;
  final bool isArabic;

  const FareTotalRow({
    super.key,
    required this.booking,
    required this.isArabic,
  });

  String _pounds(int amount) => isArabic
      ? '${ArabicFormat.number(amount, isArabic: true)} جنيه'
      : '$amount EGP';

  @override
  Widget build(BuildContext context) {
    final muted = AppStyles.bodyMuted.copyWith(fontSize: 11.sp);
    final perPerson = AppStyles.cardTitle.copyWith(fontSize: 15.sp);
    final total = AppStyles.cardTitle.copyWith(
      fontSize: 26.sp,
      fontWeight: FontWeight.w800,
      color: AppColors.primaryRed,
    );

    return Column(
      children: [
        const Divider(height: 1, color: AppColors.border),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_pounds(booking.pricePerTicket), style: perPerson),
                  Text(isArabic ? 'للفرد' : 'per person', style: muted),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(isArabic ? 'الإجمالي' : 'Total', style: muted),
                  Text(_pounds(booking.totalPrice), style: total),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

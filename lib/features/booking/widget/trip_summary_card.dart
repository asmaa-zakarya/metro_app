import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../home/view/widgets/line_badge.dart';
import '../models/trip_booking.dart';

/// White card with a red top edge: from / to stations and the lines used.
class TripSummaryCard extends StatelessWidget {
  final TripBooking booking;
  final bool isArabic;

  const TripSummaryCard({
    super.key,
    required this.booking,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final nameStyle = AppStyles.cardTitle.copyWith(fontSize: 16.sp);
    final from = isArabic ? booking.from.nameAr : booking.from.nameEn;
    final to = isArabic ? booking.to.nameAr : booking.to.nameEn;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // A one-sided border cannot be combined with rounded corners.
          Container(height: 4.h, color: AppColors.primaryRed),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: _buildStations(from, to, nameStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildStations(String from, String to, TextStyle nameStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StationRow(
          name: from,
          ringColor: AppColors.primaryRed,
          style: nameStyle,
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 9.w),
          child: Container(width: 1.5, height: 22.h, color: AppColors.border),
        ),
        _StationRow(name: to, ringColor: AppColors.line1, style: nameStyle),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            for (final line
                in booking.route.legs.map((leg) => leg.line).toSet())
              LineBadge(lineNumber: line, isArabic: isArabic),
          ],
        ),
      ],
    );
  }
}

class _StationRow extends StatelessWidget {
  final String name;
  final Color ringColor;
  final TextStyle style;

  const _StationRow({
    required this.name,
    required this.ringColor,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 9.w,
            height: 9.w,
            decoration: BoxDecoration(color: ringColor, shape: BoxShape.circle),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

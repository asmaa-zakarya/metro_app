
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../models/station.dart';
import 'line_badge.dart';

class TripCard extends StatelessWidget {
  final Station? pickupStation;
  final Station? arrivalStation;
  final bool isArabic;
  final VoidCallback onPickPickup;
  final VoidCallback onPickArrival;
  final VoidCallback onSwap;
  final VoidCallback? onShowRoutes;

  const TripCard({
    super.key,
    required this.pickupStation,
    required this.arrivalStation,
    required this.isArabic,
    required this.onPickPickup,
    required this.onPickArrival,
    required this.onSwap,
    required this.onShowRoutes,
  });

  bool get _canSearch =>
      pickupStation != null &&
          arrivalStation != null &&
          pickupStation!.id != arrivalStation!.id;

  Color _getStationColor(Station? station) {
    if (station == null || station.lines.isEmpty) {
      return AppColors.activeBlue;
    }

    switch (station.lines.first) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              Column(
                children: [
                  _CompactStationRow(
                    hintLabel: isArabic ? 'محطة الركوب' : 'Pickup',
                    station: pickupStation,
                    isArabic: isArabic,
                    dotColor: _getStationColor(pickupStation),
                    onTap: onPickPickup,
                  ),
                  SizedBox(height: 6.h),
                  _CompactStationRow(
                    hintLabel: isArabic ? 'محطة الوصول' : 'Arrival',
                    station: arrivalStation,
                    isArabic: isArabic,
                    dotColor: _getStationColor(arrivalStation),
                    onTap: onPickArrival,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.w),
                child: Material(
                  color: AppColors.primaryRed,
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onSwap,
                    child: SizedBox(
                      width: 34.w,
                      height: 34.w,
                      child: Icon(
                        Icons.swap_vert_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              onPressed: _canSearch ? onShowRoutes : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activeBlue,
                disabledBackgroundColor: AppColors.disabledGrey,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isArabic ? 'عرض الطرق' : 'Show Routes',
                    style: AppStyles.buttonLabel.copyWith(
                      fontSize: 13.5.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    isArabic
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_forward_rounded,
                    size: 17.sp,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 13.sp,
                color: AppColors.primaryRed,
              ),
              SizedBox(width: 4.w),
              Text(
                isArabic
                    ? 'يُحسب السعر والوقت وفقاً لتفاصيل الرحلة.'
                    : 'Fare and time are calculated per trip details.',
                style: AppStyles.bodyMuted.copyWith(
                  fontSize: 10.5.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactStationRow extends StatelessWidget {
  final String hintLabel;
  final Station? station;
  final bool isArabic;
  final Color dotColor;
  final VoidCallback onTap;

  const _CompactStationRow({
    required this.hintLabel,
    required this.station,
    required this.isArabic,
    required this.dotColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasStation = station != null;

    final text = hasStation
        ? (isArabic ? station!.nameAr : station!.nameEn)
        : (isArabic
        ? '$hintLabel — اختر محطة'
        : '$hintLabel — Select station');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 11.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(
            color: hasStation
                ? dotColor.withValues(alpha: 0.45)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasStation ? dotColor : Colors.transparent,
                border: Border.all(
                  color: dotColor,
                  width: 2.w,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.cardTitle.copyWith(
                  fontSize: 13.sp,
                  fontWeight: hasStation
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: hasStation
                      ? AppColors.textDark
                      : AppColors.textMuted,
                ),
              ),
            ),
            if (hasStation && station!.lines.isNotEmpty) ...[
              LineBadge(
                lineNumber: station!.lines.first,
                isArabic: isArabic,
              ),
              SizedBox(width: 4.w),
            ],
            Icon(
              isArabic
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

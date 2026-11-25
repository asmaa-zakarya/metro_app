import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/metro_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../data.dart';
import '../logic/fareCalculator.dart';
import '../logic/routePlanner.dart';

/// تفاصيل الطريق + اختيار نوع الراكب + الحجز.
/// بيرجع السعر لو المستخدم ضغط "احجز"
class RouteDetailsSheet extends StatefulWidget {
  final RouteOption route;
  final bool isArabic;

  const RouteDetailsSheet({
    super.key,
    required this.route,
    required this.isArabic,
  });

  @override
  State<RouteDetailsSheet> createState() => _RouteDetailsSheetState();
}

class _RouteDetailsSheetState extends State<RouteDetailsSheet> {
  PassengerType _passenger = PassengerType.general;

  String _passengerLabel(PassengerType type) {
    final ar = widget.isArabic;
    switch (type) {
      case PassengerType.general:
        return ar ? 'عادي' : 'General';
      case PassengerType.student:
        return ar ? 'طالب' : 'Student';
      case PassengerType.senior60to70:
        return ar ? 'من ٦٠ إلى ٧٠ سنة' : 'Age 60–70';
      case PassengerType.senior70Plus:
        return ar ? 'فوق ٧٠ سنة' : 'Over 70';
      case PassengerType.disabled:
        return ar ? 'ذوي الهمم' : 'Disability';
    }
  }

  String _name(String station) =>
      MetroData.stationName(station, isArabic: widget.isArabic);

  @override
  Widget build(BuildContext context) {
    final ar = widget.isArabic;
    final fare =
    FareCalculator.calculateFare(widget.route.stationCount, _passenger);

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(16.w),
                children: [
                  Text(
                    ar ? 'تفاصيل الطريق' : 'Route details',
                    style: AppStyles.cardTitle.copyWith(fontSize: 18.sp),
                  ),
                  SizedBox(height: 12.h),
                  for (var i = 0; i < widget.route.legs.length; i++)
                    _buildLeg(widget.route.legs[i], isTransfer: i > 0),
                  SizedBox(height: 8.h),
                  Text(
                    ar ? 'نوع الراكب' : 'Passenger type',
                    style: AppStyles.cardTitle.copyWith(fontSize: 13.sp),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 8.w,
                    children: [
                      for (final type in PassengerType.values)
                        ChoiceChip(
                          label: Text(_passengerLabel(type)),
                          selected: _passenger == type,
                          onSelected: (_) => setState(() => _passenger = type),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, fare.price),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(48.h),
                  backgroundColor: AppColors.activeBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  ar
                      ? 'احجز التذكرة · ${ArabicFormat.number(fare.price, isArabic: true)} جنيه'
                      : 'Book ticket · ${fare.price} EGP',
                  style: AppStyles.buttonLabel.copyWith(fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeg(RouteLeg leg, {required bool isTransfer}) {
    final ar = widget.isArabic;
    final toward = leg.toward.map(_name).join(' / ');

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 10.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(
              color: MetroConstants.lineColor(leg.line),
              width: 4.w,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTransfer)
              Text(
                ar
                    ? 'بدّل في ${_name(leg.stations.first)}'
                    : 'Change at ${_name(leg.stations.first)}',
                style: AppStyles.bodyMuted.copyWith(
                  fontSize: 11.sp,
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            Text(
              '${MetroConstants.lineLabel(leg.line, isArabic: ar)} · '
                  '${ar ? 'اتجاه' : 'toward'} $toward',
              style: AppStyles.cardTitle.copyWith(fontSize: 13.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              leg.stations.map(_name).join(ar ? '، ' : ', '),
              style: AppStyles.bodyMuted.copyWith(fontSize: 11.sp, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}

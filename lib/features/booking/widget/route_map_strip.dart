import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/metro_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../data.dart';
import '../logic/journey.dart';

/// "Route on the map" card: every station of the trip as a pin on a
/// horizontal, scrollable line coloured by metro line.
class RouteMapStrip extends StatefulWidget {
  final List<RouteStop> stops;
  final bool isArabic;

  const RouteMapStrip({super.key, required this.stops, required this.isArabic});

  @override
  State<RouteMapStrip> createState() => _RouteMapStripState();
}

class _RouteMapStripState extends State<RouteMapStrip> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.isArabic;
    final nameStyle = AppStyles.cardTitle.copyWith(fontSize: 11.sp);
    final lineStyle = AppStyles.bodyMuted.copyWith(
      fontSize: 9.sp,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.map_outlined,
                size: 20.sp,
                color: AppColors.primaryRed,
              ),
              SizedBox(width: 8.w),
              Text(
                isArabic ? 'مسار الرحلة على الخريطة' : 'Route on the map',
                style: AppStyles.cardTitle.copyWith(fontSize: 15.sp),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 118.h,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemExtent: 104.w,
                padding: EdgeInsets.only(bottom: 14.h),
                itemCount: widget.stops.length,
                itemBuilder: (context, index) => _StopPin(
                  stop: widget.stops[index],
                  isFirst: index == 0,
                  isLast: index == widget.stops.length - 1,
                  isArabic: isArabic,
                  nameStyle: nameStyle,
                  lineStyle: lineStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopPin extends StatelessWidget {
  final RouteStop stop;
  final bool isFirst;
  final bool isLast;
  final bool isArabic;
  final TextStyle nameStyle;
  final TextStyle lineStyle;

  const _StopPin({
    required this.stop,
    required this.isFirst,
    required this.isLast,
    required this.isArabic,
    required this.nameStyle,
    required this.lineStyle,
  });

  @override
  Widget build(BuildContext context) {
    final color = MetroConstants.lineColor(stop.line);

    return Column(
      children: [
        Container(
          width: 22.w,
          height: 22.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: color, width: 4.w),
          ),
        ),
        Container(width: 4.w, height: 16.h, color: color),
        // Each pin draws its own half of the track on either side.
        Row(
          children: [
            Expanded(
              child: Container(height: 4.h, color: isFirst ? null : color),
            ),
            Expanded(
              child: Container(height: 4.h, color: isLast ? null : color),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            MetroData.stationName(stop.station, isArabic: isArabic),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: nameStyle,
          ),
        ),
        Text(
          MetroConstants.lineLabel(stop.line, isArabic: isArabic),
          style: lineStyle.copyWith(color: color),
        ),
      ],
    );
  }
}

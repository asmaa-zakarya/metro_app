import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/metro_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../data.dart';
import '../logic/journey.dart';

/// Vertical step-by-step journey: where to board, where to change trains,
/// the stations on the way, and the destination.
class JourneyTimeline extends StatelessWidget {
  final List<JourneyLeg> legs;
  final bool isArabic;

  const JourneyTimeline({
    super.key,
    required this.legs,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final styles = _TimelineStyles.create();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < legs.length; index++)
          _LegSection(
            leg: legs[index],
            isFirst: index == 0,
            isLast: index == legs.length - 1,
            isArabic: isArabic,
            styles: styles,
          ),
      ],
    );
  }
}

/// Text styles built once per timeline instead of once per row.
class _TimelineStyles {
  final TextStyle stepLabel;
  final TextStyle stationName;
  final TextStyle lineName;
  final TextStyle muted;
  final TextStyle smallTitle;

  const _TimelineStyles({
    required this.stepLabel,
    required this.stationName,
    required this.lineName,
    required this.muted,
    required this.smallTitle,
  });

  factory _TimelineStyles.create() {
    final muted = AppStyles.bodyMuted.copyWith(fontSize: 11.sp);
    final title = AppStyles.cardTitle;
    return _TimelineStyles(
      stepLabel: muted.copyWith(
        color: AppColors.primaryRed,
        fontWeight: FontWeight.w700,
      ),
      stationName: TextStyle(fontSize: 22.sp, color: AppColors.textDark),
      lineName: title.copyWith(fontSize: 14.sp),
      muted: muted,
      smallTitle: title.copyWith(fontSize: 12.sp),
    );
  }
}

class _LegSection extends StatelessWidget {
  final JourneyLeg leg;
  final bool isFirst;
  final bool isLast;
  final bool isArabic;
  final _TimelineStyles styles;

  const _LegSection({
    required this.leg,
    required this.isFirst,
    required this.isLast,
    required this.isArabic,
    required this.styles,
  });

  String _name(String station) =>
      MetroData.stationName(station, isArabic: isArabic);

  @override
  Widget build(BuildContext context) {
    final color = MetroConstants.lineColor(leg.line);
    final String stepLabel;
    if (isFirst) {
      stepLabel = isArabic ? 'استقل القطار من' : 'Board at';
    } else {
      stepLabel = isArabic ? 'غادر القطار هنا للتبديل' : 'Change trains here';
    }

    return Stack(
      children: [
        PositionedDirectional(
          start: 8.w,
          top: 14.h,
          bottom: isLast ? 0 : -2.h,
          child: Container(width: 4.w, color: color),
        ),
        PositionedDirectional(
          start: 0,
          top: 2.h,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgLight,
              border: Border.all(color: color, width: 4.w),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 36.w, bottom: 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stepLabel, style: styles.stepLabel),
              SizedBox(height: 4.h),
              Text(_name(leg.boardStation), style: styles.stationName),
              SizedBox(height: 12.h),
              _LineCard(leg: leg, isArabic: isArabic, styles: styles),
              if (leg.stationsBetween.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _StationsOnTheWay(
                  stations: leg.stationsBetween.map(_name).toList(),
                  isArabic: isArabic,
                  styles: styles,
                  dotColor: color,
                ),
              ],
              if (isLast) ...[
                SizedBox(height: 16.h),
                Text(
                  isArabic ? 'وصلت وجهتك' : "You've arrived",
                  style: styles.muted,
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 20.sp, color: color),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        _name(leg.endStation),
                        style: styles.lineName.copyWith(fontSize: 17.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LineCard extends StatelessWidget {
  final JourneyLeg leg;
  final bool isArabic;
  final _TimelineStyles styles;

  const _LineCard({
    required this.leg,
    required this.isArabic,
    required this.styles,
  });

  static const _arabicOrdinals = {1: 'الأول', 2: 'الثاني', 3: 'الثالث'};

  String get _lineName {
    if (!isArabic) return 'Line ${leg.line}';
    final ordinal = _arabicOrdinals[leg.line];
    return ordinal == null ? 'خط ${leg.line}' : 'الخط $ordinal';
  }

  @override
  Widget build(BuildContext context) {
    final toward = MetroData.stationName(leg.endStation, isArabic: isArabic);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_subway_outlined,
            size: 26.sp,
            color: MetroConstants.lineColor(leg.line),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_lineName, style: styles.lineName),
                Text(
                  isArabic ? 'في اتجاه $toward' : 'Toward $toward',
                  style: styles.muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Collapsed by default; the station list is only built when opened.
class _StationsOnTheWay extends StatefulWidget {
  final List<String> stations;
  final bool isArabic;
  final _TimelineStyles styles;
  final Color dotColor;

  const _StationsOnTheWay({
    required this.stations,
    required this.isArabic,
    required this.styles,
    required this.dotColor,
  });

  @override
  State<_StationsOnTheWay> createState() => _StationsOnTheWayState();
}

class _StationsOnTheWayState extends State<_StationsOnTheWay> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final count = ArabicFormat.number(
      widget.stations.length,
      isArabic: widget.isArabic,
    );
    final title = widget.isArabic
        ? 'المحطات في الطريق ($count)'
        : 'Stations on the way ($count)';

    return Material(
      color: const Color(0xFFF0F2F5),
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: widget.styles.smallTitle)),
                  Icon(
                    _isExpanded
                        ? Icons.expand_less_rounded
                        // chevron_right mirrors itself in RTL.
                        : Icons.chevron_right_rounded,
                    size: 22.sp,
                    color: AppColors.activeBlue,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(14.w, 0, 14.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final station in widget.stations)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Row(
                        children: [
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: BoxDecoration(
                              color: widget.dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(station, style: widget.styles.muted),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

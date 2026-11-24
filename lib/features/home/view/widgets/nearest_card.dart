import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../data/station_data.dart';
import '../../models/station.dart';
import 'line_badge.dart';

class NearestCard extends StatefulWidget {
  final bool isExpanded;
  final bool isArabic;
  final VoidCallback onToggle;
  final ValueChanged<Station> onSelectStation;

  const NearestCard({
    super.key,
    required this.isExpanded,
    required this.isArabic,
    required this.onToggle,
    required this.onSelectStation,
  });

  @override
  State<NearestCard> createState() => _NearestCardState();
}

class _NearestCardState extends State<NearestCard> {
  bool _loading = false;
  String? _statusMessage;
  List<Station> _nearestStations = [];

  @override
  void initState() {
    super.initState();
    _loadNearestStations();
  }

  Future<void> _loadNearestStations() async {
    setState(() {
      _loading = true;
      _statusMessage = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _loading = false;
          _statusMessage = widget.isArabic
              ? 'يرجى تفعيل خدمة الموقع (GPS) لعرض أقرب محطة.'
              : 'Please enable location services (GPS) to find nearest stations.';
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _loading = false;
          _statusMessage = widget.isArabic
              ? 'لم يتم منح إذن الموقع، فعّليه من الإعدادات لمعرفة أقرب محطة.'
              : 'Location permission denied. Enable it in settings to find nearest stations.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final nearest = StationsData.nearestFromLocation(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      setState(() {
        _nearestStations = nearest;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _statusMessage = widget.isArabic
            ? 'تعذر تحديد موقعك حالياً، حاولي مرة أخرى.'
            : 'Unable to determine your location right now.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final closest = _nearestStations.isNotEmpty ? _nearestStations.first : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              widget.onToggle();
              if (!widget.isExpanded && _nearestStations.isEmpty && !_loading) {
                _loadNearestStations();
              }
            },
            borderRadius: BorderRadius.circular(14.r),
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
                      Icons.my_location_rounded,
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
                          widget.isArabic ? 'المحطات الأقرب إليّ' : 'Nearest Stations',
                          style: AppStyles.cardTitle.copyWith(fontSize: 14.sp),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          closest != null
                              ? (widget.isArabic
                              ? 'الأقرب: ${closest.nameAr} (${closest.distanceKm} كم)'
                              : 'Closest: ${closest.nameEn} (${closest.distanceKm} km)')
                              : (widget.isArabic
                              ? 'استخدم موقعك لعرض أقرب المحطات'
                              : 'Use your location to show nearest stations'),
                          style: AppStyles.bodyMuted.copyWith(
                            fontSize: 11.sp,
                            color: closest != null ? AppColors.activeBlue : AppColors.textMuted,
                            fontWeight: closest != null ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _loadNearestStations,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: AppColors.activeBlue,
                      size: 20.sp,
                    ),
                    tooltip: widget.isArabic ? 'تحديث الموقع' : 'Refresh location',
                  ),
                  Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted,
                    size: 22.sp,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isExpanded) ...[
            const Divider(height: 1, color: AppColors.border),
            if (_loading)
              Padding(
                padding: EdgeInsets.all(16.w),
                child: const CircularProgressIndicator(strokeWidth: 2.2),
              )
            else if (_statusMessage != null)
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  children: [
                    Text(
                      _statusMessage!,
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyMuted.copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: _loadNearestStations,
                      child: Text(
                        widget.isArabic ? 'إعادة المحاولة' : 'Try Again',
                        style: AppStyles.cardTitle.copyWith(
                          color: AppColors.activeBlue,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._nearestStations.asMap().entries.map((entry) {
                final idx = entry.key;
                final station = entry.value;
                final isClosest = idx == 0;

                return InkWell(
                  onTap: () => widget.onSelectStation(station),
                  child: Container(
                    color: isClosest
                        ? AppColors.activeBlue.withValues(alpha: 0.05)
                        : Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Icon(
                          isClosest ? Icons.near_me_rounded : Icons.location_on_outlined,
                          color: isClosest ? AppColors.activeBlue : AppColors.primaryRed,
                          size: 18.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                widget.isArabic ? station.nameAr : station.nameEn,
                                style: AppStyles.cardTitle.copyWith(fontSize: 13.5.sp),
                              ),
                              SizedBox(width: 8.w),
                              LineBadge(
                                lineNumber: station.lines.first,
                                isArabic: widget.isArabic,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.isArabic
                              ? '${station.distanceKm} كم'
                              : '${station.distanceKm} km',
                          style: AppStyles.bodyMuted.copyWith(
                            color: AppColors.activeBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ],
      ),
    );
  }
}
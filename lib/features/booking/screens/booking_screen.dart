import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_language.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../home/models/station.dart';
import '../data.dart';
import '../logic/routePlanner.dart';
import '../models/trip_booking.dart';
import '../widget/route_card.dart';


class RoutesScreen extends StatefulWidget {
  final Station from;
  final Station to;

  const RoutesScreen({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  late final List<RouteOption> _routes = const RoutePlanner(MetroData.network)
      .planRoutes(widget.from.nameEn, widget.to.nameEn);

  /// "تفاصيل الطريق" opens the booking flow (trip details → … → ticket).
  void _openDetails(RouteOption route) {
    context.push(
      RouteNames.tripDetails,
      extra: TripBooking.start(
        from: widget.from,
        to: widget.to,
        route: route,
        today: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Follows the app-wide language like the other screens.
    return ValueListenableBuilder<bool>(
      valueListenable: AppLanguage.isArabic,
      builder: (context, isArabic, _) => _buildPage(context, isArabic),
    );
  }

  Widget _buildPage(BuildContext context, bool isArabic) {
    final from = isArabic ? widget.from.nameAr : widget.from.nameEn;
    final to = isArabic ? widget.to.nameAr : widget.to.nameEn;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        // زرار الرجوع بيظهر لوحده لأن الصفحة مفتوحة بـ push
        appBar: CustomAppBar(
          isArabic: isArabic,
          logoAssetPath: AppAssets.cairoMetroIcon,
          onLanguageChanged: (val) => AppLanguage.isArabic.value = val,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
          children: [
            Text(
              isArabic ? 'الطرق المقترحة' : 'Suggested routes',
              style: AppStyles.appTitle.copyWith(fontSize: 25.sp),
            ),
            SizedBox(height: 6.h),
            Text(
              isArabic ? '$from ← $to' : '$from → $to',
              style: AppStyles.bodyMuted.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => context.pop(),
                icon: Icon(Icons.edit_outlined, size: 16.sp),
                label: Text(isArabic ? 'تعديل الرحلة' : 'Edit trip'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            if (_routes.isEmpty)
              Text(
                isArabic
                    ? 'مفيش طريق متاح بين المحطتين.'
                    : 'No route found between these stations.',
                textAlign: TextAlign.center,
                style: AppStyles.bodyMuted.copyWith(fontSize: 13.sp),
              ),
            for (var i = 0; i < _routes.length; i++) ...[
              RouteCard(
                route: _routes[i],
                isFastest: i == 0,
                isArabic: isArabic,
                onDetails: () => _openDetails(_routes[i]),
              ),
              SizedBox(height: 12.h),
            ],
          ],
        ),
      ),
    );
  }
}
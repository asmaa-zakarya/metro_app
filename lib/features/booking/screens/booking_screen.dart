import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../home/models/station.dart';
import '../../tickets/screens/ticket.dart';
import '../../tickets/screens/ticketsData.dart';
import '../data.dart';
import '../logic/routePlanner.dart';
import '../widget/route_card.dart';
import '../widget/route_details_sheet.dart';


class RoutesScreen extends StatefulWidget {
  final Station from;
  final Station to;
  final bool initialIsArabic;

  const RoutesScreen({
    super.key,
    required this.from,
    required this.to,
    this.initialIsArabic = true,
  });

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  late bool _isArabic = widget.initialIsArabic;

  late final List<RouteOption> _routes = const RoutePlanner(MetroData.network)
      .planRoutes(widget.from.nameEn, widget.to.nameEn);

  Future<void> _openDetails(RouteOption route) async {
    final price = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: RouteDetailsSheet(route: route, isArabic: _isArabic),
      ),
    );

    if (price == null || !mounted) return;

    final now = DateTime.now();
    TicketsData.add(
      Ticket(
        id: now.microsecondsSinceEpoch.toString(),
        from: widget.from,
        to: widget.to,
        date: now,
        price: price,
      ),
    );
    context.go(RouteNames.ticket);
  }

  @override
  Widget build(BuildContext context) {
    final from = _isArabic ? widget.from.nameAr : widget.from.nameEn;
    final to = _isArabic ? widget.to.nameAr : widget.to.nameEn;

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        // زرار الرجوع بيظهر لوحده لأن الصفحة مفتوحة بـ push
        appBar: CustomAppBar(
          isArabic: _isArabic,
          logoAssetPath: AppAssets.cairoMetroIcon,
          onLanguageChanged: (val) => setState(() => _isArabic = val),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
          children: [
            Text(
              _isArabic ? 'الطرق المقترحة' : 'Suggested routes',
              style: AppStyles.appTitle.copyWith(fontSize: 25.sp),
            ),
            SizedBox(height: 6.h),
            Text(
              _isArabic ? '$from ← $to' : '$from → $to',
              style: AppStyles.bodyMuted.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => context.pop(),
                icon: Icon(Icons.edit_outlined, size: 16.sp),
                label: Text(_isArabic ? 'تعديل الرحلة' : 'Edit trip'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            if (_routes.isEmpty)
              Text(
                _isArabic
                    ? 'مفيش طريق متاح بين المحطتين.'
                    : 'No route found between these stations.',
                textAlign: TextAlign.center,
                style: AppStyles.bodyMuted.copyWith(fontSize: 13.sp),
              ),
            for (var i = 0; i < _routes.length; i++) ...[
              RouteCard(
                route: _routes[i],
                isFastest: i == 0,
                isArabic: _isArabic,
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
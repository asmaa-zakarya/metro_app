import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../booking/models/trip_booking.dart';
import 'scanning_qr.dart';

/// One ticket: brand, status, from/to, scannable QR and the references.
class TicketPassCard extends StatelessWidget {
  static const Color _readyBackground = Color(0xFFE4F6EB);
  static const Color _readyText = Color(0xFF1E8E4E);
  static const Color _qrPanelBackground = Color(0xFFE8F2EC);

  final TripBooking booking;
  final String ticketId;
  final bool isArabic;

  const TicketPassCard({
    super.key,
    required this.booking,
    required this.ticketId,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final stationStyle = AppStyles.cardTitle.copyWith(fontSize: 14.sp);
    final muted = AppStyles.bodyMuted.copyWith(fontSize: 11.sp);
    final code = AppStyles.cardTitle.copyWith(
      fontSize: 13.sp,
      letterSpacing: 0.5,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
            child: Row(
              children: [
                Image.asset(
                  AppAssets.cairoMetroIcon,
                  width: 30.w,
                  height: 30.w,
                  cacheWidth: 90,
                ),
                SizedBox(width: 8.w),
                Expanded(child: _BrandName(isArabic: isArabic)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _readyBackground,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    isArabic ? 'جاهزة للاستخدام' : 'Ready to use',
                    style: muted.copyWith(
                      color: _readyText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isArabic ? booking.from.nameAr : booking.from.nameEn,
                    style: stationStyle,
                  ),
                ),
                const _TrainDivider(),
                Expanded(
                  child: Text(
                    isArabic ? booking.to.nameAr : booking.to.nameEn,
                    textAlign: TextAlign.end,
                    style: stationStyle,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: _DashedBorderPainter(
              color: AppColors.textMuted.withValues(alpha: 0.5),
              radius: 16.r,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 22.h),
              decoration: BoxDecoration(
                color: _qrPanelBackground,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  ScanningQr(data: ticketId, size: 150.w),
                  SizedBox(height: 12.h),
                  Text(
                    isArabic ? 'تذكرة مترو القاهرة' : 'Cairo Metro ticket',
                    style: muted,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(ticketId, textDirection: TextDirection.ltr, style: code),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: const Divider(height: 28, color: AppColors.border),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
            child: Row(
              children: [
                Text(isArabic ? 'رقم الحجز' : 'Booking number', style: muted),
                const Spacer(),
                Text(
                  booking.bookingNumber ?? '',
                  textDirection: TextDirection.ltr,
                  style: code,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandName extends StatelessWidget {
  final bool isArabic;

  const _BrandName({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final style = AppStyles.appTitle.copyWith(fontSize: 15.sp);

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: isArabic ? 'مترو ' : 'Cairo '),
          TextSpan(
            text: isArabic ? 'القاهرة' : 'Metro',
            style: style.copyWith(color: AppColors.primaryRed),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TrainDivider extends StatelessWidget {
  const _TrainDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Container(width: 28.w, height: 1, color: AppColors.border),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Icon(
              Icons.directions_subway_outlined,
              size: 22.sp,
              color: AppColors.primaryRed,
            ),
          ),
          Container(width: 28.w, height: 1, color: AppColors.border),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({required this.color, required this.radius});

  static const double _dash = 5;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final metric in outline.computeMetrics()) {
      for (
        double distance = 0;
        distance < metric.length;
        distance += _dash + _gap
      ) {
        canvas.drawPath(metric.extractPath(distance, distance + _dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

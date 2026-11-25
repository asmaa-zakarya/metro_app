import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../../home/view/widgets/line_badge.dart';
import '../logic/journey.dart';
import '../models/trip_booking.dart';
import '../widget/booking_scaffold.dart';
import '../widget/journey_timeline.dart';
import '../widget/primary_action_button.dart';
import '../widget/route_map_strip.dart';

/// PDF pages 1–2: the chosen route, on a strip map and as a timeline.
///
/// Open it with `context.push(RouteNames.tripDetails, extra: TripBooking.start(...))`.
class TripDetailsScreen extends StatefulWidget {
  final TripBooking booking;

  const TripDetailsScreen({super.key, required this.booking});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  // Derived once per screen, not on every language switch.
  late final List<JourneyLeg> _legs = journeyLegs(widget.booking.route);
  late final List<RouteStop> _stops = routeStops(widget.booking.route);

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    return BookingScaffold(
      bodyBuilder: (context, isArabic) {
        final minutes = ArabicFormat.number(
          booking.route.minutes,
          isArabic: isArabic,
        );
        final stations = ArabicFormat.stations(
          booking.route.stationCount,
          isArabic: isArabic,
        );

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
          children: [
            BookingPageTitle(
              title: isArabic ? 'تفاصيل الرحلة' : 'Trip details',
              subtitle: isArabic
                  ? '$minutes دقيقة - $stations'
                  : '$minutes min - $stations',
            ),
            SizedBox(height: 20.h),
            _TripHeaderCard(booking: booking, isArabic: isArabic),
            SizedBox(height: 18.h),
            RouteMapStrip(stops: _stops, isArabic: isArabic),
            SizedBox(height: 28.h),
            JourneyTimeline(legs: _legs, isArabic: isArabic),
          ],
        );
      },
      bottomBuilder: (context, isArabic) => PrimaryActionButton(
        label: isArabic ? 'احجز تذكرتك' : 'Book your ticket',
        icon: Icons.confirmation_number_outlined,
        onPressed: () => context.push(RouteNames.bookingSetup, extra: booking),
      ),
    );
  }
}

/// Dark card: "from —— to" and the lines the trip uses.
class _TripHeaderCard extends StatelessWidget {
  static const Color _background = Color(0xFF2B2B2B);

  final TripBooking booking;
  final bool isArabic;

  const _TripHeaderCard({required this.booking, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final nameStyle = AppStyles.cardTitle.copyWith(
      fontSize: 16.sp,
      color: Colors.white,
    );

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 22.sp,
                color: AppColors.line1,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  isArabic ? booking.from.nameAr : booking.from.nameEn,
                  style: nameStyle,
                ),
              ),
              Container(
                width: 36.w,
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                color: Colors.white54,
              ),
              Flexible(
                child: Text(
                  isArabic ? booking.to.nameAr : booking.to.nameEn,
                  style: nameStyle,
                ),
              ),
            ],
          ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../../../core/utils/date_labels.dart';
import '../models/trip_booking.dart';
import '../widget/booking_scaffold.dart';
import '../widget/fare_total_row.dart';
import '../widget/primary_action_button.dart';
import '../widget/trip_summary_card.dart';

/// PDF page 3: pick the travel date and the number of tickets.
class BookingSetupScreen extends StatefulWidget {
  static const int bookableDays = 7;

  final TripBooking booking;

  const BookingSetupScreen({super.key, required this.booking});

  @override
  State<BookingSetupScreen> createState() => _BookingSetupScreenState();
}

class _BookingSetupScreenState extends State<BookingSetupScreen> {
  // Notifiers keep each change local: picking a date does not rebuild the
  // counter, and changing the count only rebuilds the counter and the total.
  late final ValueNotifier<DateTime> _travelDate = ValueNotifier(
    widget.booking.travelDate,
  );
  late final ValueNotifier<int> _ticketCount = ValueNotifier(
    widget.booking.ticketCount,
  );

  @override
  void dispose() {
    _travelDate.dispose();
    _ticketCount.dispose();
    super.dispose();
  }

  void _review() {
    context.push(
      RouteNames.bookingReview,
      extra: widget.booking.copyWith(
        travelDate: _travelDate.value,
        ticketCount: _ticketCount.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BookingScaffold(
      bodyBuilder: (context, isArabic) => ListView(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
        children: [
          BookingPageTitle(
            title: isArabic ? 'إعداد الحجز' : 'Booking setup',
            subtitle: isArabic ? 'ملخص الرحلة' : 'Trip summary',
          ),
          SizedBox(height: 18.h),
          TripSummaryCard(booking: widget.booking, isArabic: isArabic),
          SizedBox(height: 24.h),
          Text(
            isArabic ? 'تاريخ الرحلة' : 'Travel date',
            style: AppStyles.cardTitle.copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 12.h),
          _DatePicker(
            firstDay: widget.booking.travelDate,
            selected: _travelDate,
            isArabic: isArabic,
          ),
          SizedBox(height: 20.h),
          _TicketCounter(count: _ticketCount, isArabic: isArabic),
          SizedBox(height: 20.h),
          ValueListenableBuilder<int>(
            valueListenable: _ticketCount,
            builder: (context, count, _) => FareTotalRow(
              booking: widget.booking.copyWith(ticketCount: count),
              isArabic: isArabic,
            ),
          ),
        ],
      ),
      bottomBuilder: (context, isArabic) => PrimaryActionButton(
        label: isArabic ? 'مراجعة الحجز' : 'Review booking',
        icon: Icons.arrow_forward_rounded,
        iconAfterLabel: true,
        onPressed: _review,
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  static const Color _selectedColor = Color(0xFF2B2B2B);

  final DateTime firstDay;
  final ValueNotifier<DateTime> selected;
  final bool isArabic;

  const _DatePicker({
    required this.firstDay,
    required this.selected,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final weekdayStyle = AppStyles.bodyMuted.copyWith(fontSize: 10.sp);
    final dayStyle = AppStyles.cardTitle.copyWith(fontSize: 18.sp);

    return SizedBox(
      height: 78.h,
      child: ValueListenableBuilder<DateTime>(
        valueListenable: selected,
        builder: (context, selectedDate, _) => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: BookingSetupScreen.bookableDays,
          separatorBuilder: (_, _) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            final day = DateTime(
              firstDay.year,
              firstDay.month,
              firstDay.day + index,
            );
            final isSelected = day == selectedDate;
            final textColor = isSelected ? Colors.white : AppColors.textDark;

            return Material(
              color: isSelected ? _selectedColor : AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: BorderSide(
                  color: isSelected ? _selectedColor : AppColors.border,
                ),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                onTap: () => selected.value = day,
                child: SizedBox(
                  width: 70.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        index == 0
                            ? (isArabic ? 'اليوم' : 'Today')
                            : DateLabels.weekday(day, isArabic: isArabic),
                        style: weekdayStyle.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textMuted,
                          fontWeight: isSelected ? FontWeight.w700 : null,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        DateLabels.dayNumber(day, isArabic: isArabic),
                        style: dayStyle.copyWith(color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TicketCounter extends StatelessWidget {
  final ValueNotifier<int> count;
  final bool isArabic;

  const _TicketCounter({required this.count, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'عدد التذاكر' : 'Number of tickets',
                  style: TextStyle(fontSize: 17.sp, color: AppColors.textDark),
                ),
                Text(
                  isArabic ? 'الحد الأدنى تذكرة واحدة' : 'Minimum one ticket',
                  style: AppStyles.bodyMuted.copyWith(fontSize: 10.sp),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: count,
            builder: (context, value, _) => Row(
              children: [
                _CounterButton(
                  icon: Icons.remove_rounded,
                  tooltip: isArabic ? 'تذكرة أقل' : 'One ticket less',
                  onPressed: value > TripBooking.minTickets
                      ? () => count.value = value - 1
                      : null,
                ),
                SizedBox(
                  width: 40.w,
                  child: Text(
                    ArabicFormat.number(value, isArabic: isArabic),
                    textAlign: TextAlign.center,
                    style: AppStyles.cardTitle.copyWith(fontSize: 18.sp),
                  ),
                ),
                _CounterButton(
                  icon: Icons.add_rounded,
                  tooltip: isArabic ? 'تذكرة أكثر' : 'One more ticket',
                  onPressed: value < TripBooking.maxTickets
                      ? () => count.value = value + 1
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  static const Color _enabledBackground = Color(0xFFF8E9EA);
  static const Color _disabledBackground = Color(0xFFFCF4F4);

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _CounterButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20.sp),
      color: AppColors.primaryRed,
      disabledColor: AppColors.primaryRed.withValues(alpha: 0.25),
      style: IconButton.styleFrom(
        fixedSize: Size(48.w, 48.w),
        backgroundColor: isEnabled ? _enabledBackground : _disabledBackground,
        disabledBackgroundColor: _disabledBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

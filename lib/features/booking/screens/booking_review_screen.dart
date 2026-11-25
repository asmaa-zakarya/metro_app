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
import '../widget/booking_stepper.dart';
import '../widget/fare_total_row.dart';
import '../widget/primary_action_button.dart';
import '../widget/trip_summary_card.dart';

/// PDF page 4 (step 1): check the booking before paying.
class BookingReviewScreen extends StatelessWidget {
  final TripBooking booking;

  const BookingReviewScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BookingScaffold(
      bodyBuilder: (context, isArabic) => ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          BookingStepper(currentStep: 1, isArabic: isArabic),
          SizedBox(height: 20.h),
          BookingPageTitle(title: isArabic ? 'مراجعة الحجز' : 'Review booking'),
          SizedBox(height: 18.h),
          TripSummaryCard(booking: booking, isArabic: isArabic),
          SizedBox(height: 18.h),
          _TripSummaryDetails(booking: booking, isArabic: isArabic),
          SizedBox(height: 20.h),
          FareTotalRow(booking: booking, isArabic: isArabic),
          SizedBox(height: 18.h),
          _ValidityNote(isArabic: isArabic),
        ],
      ),
      bottomBuilder: (context, isArabic) => PrimaryActionButton(
        label: isArabic ? 'المتابعة إلى الدفع' : 'Continue to payment',
        icon: Icons.arrow_forward_rounded,
        iconAfterLabel: true,
        color: PrimaryActionButton.green,
        shadowColor: PrimaryActionButton.greenShadow,
        onPressed: () => context.push(RouteNames.payment, extra: booking),
      ),
    );
  }
}

/// "Trip summary" card: date, ticket count and payment method, with an
/// Edit chip that goes back to the setup screen.
class _TripSummaryDetails extends StatelessWidget {
  static const Color _editBackground = Color(0xFFE8F1FE);

  final TripBooking booking;
  final bool isArabic;

  const _TripSummaryDetails({required this.booking, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppStyles.bodyMuted.copyWith(fontSize: 12.sp);
    final valueStyle = AppStyles.cardTitle.copyWith(fontSize: 13.sp);
    final paymentMethod = switch (booking.paymentMethod) {
      PaymentMethod.bankCard => isArabic ? 'بطاقة بنكية' : 'Bank card',
      PaymentMethod.eWallet => isArabic ? 'محفظة إلكترونية' : 'E-wallet',
    };

    final rows = [
      (
        isArabic ? 'تاريخ الرحلة' : 'Travel date',
        DateLabels.fullDate(booking.travelDate, isArabic: isArabic),
      ),
      (
        isArabic ? 'عدد التذاكر' : 'Tickets',
        ArabicFormat.number(booking.ticketCount, isArabic: isArabic),
      ),
      (isArabic ? 'طريقة الدفع' : 'Payment method', paymentMethod),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isArabic ? 'ملخص الرحلة' : 'Trip summary',
                  style: AppStyles.cardTitle.copyWith(fontSize: 16.sp),
                ),
              ),
              TextButton.icon(
                onPressed: () => context.pop(),
                icon: Icon(Icons.refresh_rounded, size: 16.sp),
                label: Text(isArabic ? 'تعديل' : 'Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.activeBlue,
                  backgroundColor: _editBackground,
                  textStyle: valueStyle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
          for (final (label, value) in rows) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                children: [
                  Text(label, style: labelStyle),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: valueStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ValidityNote extends StatelessWidget {
  static const Color _background = Color(0xFFFFF6DB);
  static const Color _iconColor = Color(0xFF8A6D1F);

  final bool isArabic;

  const _ValidityNote({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, size: 18.sp, color: _iconColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              isArabic ? 'التذاكر صالحة حتى نهاية تاريخ الرحلة المحدد.' : 'Tickets are valid until the end of the selected trip date.',
              style: AppStyles.bodyMuted.copyWith(fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../models/trip_booking.dart';
import '../widget/booking_scaffold.dart';
import '../widget/booking_stepper.dart';
import '../widget/primary_action_button.dart';

/// PDF page 6 (step 3): the booking is paid.
class BookingSuccessScreen extends StatelessWidget {
  final TripBooking booking;

  const BookingSuccessScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Payment replaced the whole stack, so this is the only page. The Android
    // Back button would otherwise close the app; send it Home instead.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(RouteNames.home);
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return BookingScaffold(
      // The flow is finished; Back leads Home rather than to the payment.
      onBack: () => context.go(RouteNames.home),
      bodyBuilder: (context, isArabic) {
        final muted = AppStyles.bodyMuted.copyWith(fontSize: 12.sp);
        final value = AppStyles.cardTitle.copyWith(fontSize: 14.sp);
        final total = ArabicFormat.number(
          booking.totalPrice,
          isArabic: isArabic,
        );

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            BookingStepper(currentStep: 3, isArabic: isArabic),
            SizedBox(height: 26.h),
            const Center(child: _SuccessBadge()),
            SizedBox(height: 22.h),
            Text(
              isArabic ? 'تم حجز رحلتك بنجاح' : 'Your trip is booked',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26.sp, color: AppColors.textDark),
            ),
            SizedBox(height: 6.h),
            Text(
              isArabic ? 'تذكرة مترو القاهرة' : 'Cairo Metro ticket',
              textAlign: TextAlign.center,
              style: muted,
            ),
            SizedBox(height: 24.h),
            _InfoCard(
              child: Column(
                children: [
                  Text(isArabic ? 'رقم الحجز' : 'Booking number', style: muted),
                  SizedBox(height: 6.h),
                  Text(
                    booking.bookingNumber ?? '',
                    style: AppStyles.appTitle.copyWith(
                      fontSize: 22.sp,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            _InfoCard(
              child: Column(
                children: [
                  _InfoRow(
                    label: isArabic ? 'المبلغ المدفوع' : 'Amount paid',
                    value: isArabic ? '$total جنيه' : '$total EGP',
                    labelStyle: muted,
                    valueStyle: value,
                  ),
                  const Divider(height: 28, color: AppColors.border),
                  _InfoRow(
                    label: isArabic ? 'عدد التذاكر' : 'Tickets',
                    value: ArabicFormat.number(
                      booking.ticketCount,
                      isArabic: isArabic,
                    ),
                    labelStyle: muted,
                    valueStyle: value,
                  ),
                ],
              ),
            ),
            SizedBox(height: 26.h),
            PrimaryActionButton(
              label: isArabic ? 'عرض التذاكر' : 'View tickets',
              icon: Icons.confirmation_number_outlined,
              onPressed: () =>
                  context.push(RouteNames.ticketDetails, extra: booking),
            ),
            SizedBox(height: 14.h),
            OutlinedButton(
              onPressed: () => context.go(RouteNames.home),
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(54.h),
                foregroundColor: PrimaryActionButton.blue,
                side: const BorderSide(
                  color: PrimaryActionButton.blue,
                  width: 1.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                isArabic ? 'العودة إلى الرئيسية' : 'Back to home',
                style: AppStyles.buttonLabel.copyWith(
                  fontSize: 16.sp,
                  color: PrimaryActionButton.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryRed.withValues(alpha: 0.08),
      ),
      child: Container(
        width: 96.w,
        height: 96.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryRed,
        ),
        child: Icon(Icons.check_rounded, size: 48.sp, color: Colors.white),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: labelStyle),
        const Spacer(),
        Text(value, style: valueStyle),
      ],
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../../tickets/screens/ticket.dart';
import '../../tickets/screens/ticketsData.dart';
import '../models/paid_bookings.dart';
import '../models/trip_booking.dart';
import '../widget/booking_scaffold.dart';
import '../widget/booking_stepper.dart';
import '../widget/primary_action_button.dart';

/// PDF page 5 (step 2): choose how to pay, then pay.
class PaymentScreen extends StatefulWidget {
  final TripBooking booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final ValueNotifier<PaymentMethod> _method = ValueNotifier(
    widget.booking.paymentMethod,
  );

  @override
  void dispose() {
    _method.dispose();
    super.dispose();
  }

  void _pay() {
    final paid = widget.booking.copyWith(
      paymentMethod: _method.value,
      bookingNumber: TripBooking.newBookingNumber(DateTime.now()),
    );

    // The Tickets tab lists these tickets and reopens each one's QR screen
    // through PaidBookings.
    PaidBookings.add(paid);
    for (final ticketId in paid.ticketIds) {
      TicketsData.add(
        Ticket(
          id: ticketId,
          from: paid.from,
          to: paid.to,
          date: paid.travelDate,
          price: paid.pricePerTicket,
        ),
      );
    }

    // `go` replaces the flow, so Back cannot return to this screen and pay twice.
    context.go(RouteNames.bookingSuccess, extra: paid);
  }

  @override
  Widget build(BuildContext context) {
    return BookingScaffold(
      bodyBuilder: (context, isArabic) {
        final total = ArabicFormat.number(
          widget.booking.totalPrice,
          isArabic: isArabic,
        );

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            BookingStepper(currentStep: 2, isArabic: isArabic),
            SizedBox(height: 20.h),
            BookingPageTitle(title: isArabic ? 'الدفع' : 'Payment'),
            SizedBox(height: 18.h),
            ValueListenableBuilder<PaymentMethod>(
              valueListenable: _method,
              builder: (context, selected, _) => Column(
                children: [
                  _PaymentOption(
                    icon: Icons.credit_card_rounded,
                    title: isArabic ? 'بطاقة بنكية' : 'Bank card',
                    detail: '4242 4242 4242 4242',
                    isSelected: selected == PaymentMethod.bankCard,
                    onTap: () => _method.value = PaymentMethod.bankCard,
                  ),
                  SizedBox(height: 14.h),
                  _PaymentOption(
                    icon: Icons.account_balance_wallet_outlined,
                    title: isArabic ? 'محفظة إلكترونية' : 'E-wallet',
                    detail: '010 0000 0000',
                    isSelected: selected == PaymentMethod.eWallet,
                    onTap: () => _method.value = PaymentMethod.eWallet,
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.h),
            PrimaryActionButton(
              label: isArabic ? 'ادفع $total جنيه' : 'Pay $total EGP',
              icon: Icons.verified_user_outlined,
              iconAfterLabel: true,
              color: PrimaryActionButton.green,
              shadowColor: PrimaryActionButton.greenShadow,
              onPressed: _pay,
            ),
          ],
        );
      },
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.detail,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
      side: BorderSide(
        color: isSelected ? AppColors.primaryRed : AppColors.border,
        width: isSelected ? 1.6 : 1,
      ),
    );

    return Material(
      color: AppColors.surface,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Row(
            children: [
              Icon(icon, size: 26.sp, color: AppColors.primaryRed),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.cardTitle.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    // Card and phone numbers always read left to right.
                    Text(
                      detail,
                      textDirection: TextDirection.ltr,
                      style: AppStyles.bodyMuted.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              _SelectionMark(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionMark extends StatelessWidget {
  final bool isSelected;

  const _SelectionMark({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primaryRed : AppColors.surface,
        border: isSelected
            ? null
            : Border.all(color: AppColors.border, width: 1.5),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 18.sp, color: Colors.white)
          : null,
    );
  }
}

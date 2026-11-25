import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../../../core/utils/date_labels.dart';
import '../../booking/models/trip_booking.dart';

/// Bottom sheet listing what was paid for the booking.
class ReceiptSheet extends StatelessWidget {
  final TripBooking booking;
  final bool isArabic;

  const ReceiptSheet({
    super.key,
    required this.booking,
    required this.isArabic,
  });

  String _pounds(int amount) => isArabic
      ? '${ArabicFormat.number(amount, isArabic: true)} جنيه'
      : '$amount EGP';

  @override
  Widget build(BuildContext context) {
    final label = AppStyles.bodyMuted.copyWith(fontSize: 12.sp);
    final value = AppStyles.cardTitle.copyWith(fontSize: 13.sp);
    final paymentMethod = switch (booking.paymentMethod) {
      PaymentMethod.bankCard => isArabic ? 'بطاقة بنكية' : 'Bank card',
      PaymentMethod.eWallet => isArabic ? 'محفظة إلكترونية' : 'E-wallet',
    };
    final rows = [
      (isArabic ? 'رقم الحجز' : 'Booking number', booking.bookingNumber ?? ''),
      (
        isArabic ? 'تاريخ الرحلة' : 'Travel date',
        DateLabels.fullDate(booking.travelDate, isArabic: isArabic),
      ),
      (
        isArabic ? 'عدد التذاكر' : 'Tickets',
        ArabicFormat.number(booking.ticketCount, isArabic: isArabic),
      ),
      (
        isArabic ? 'سعر التذكرة' : 'Price per ticket',
        _pounds(booking.pricePerTicket),
      ),
      (isArabic ? 'طريقة الدفع' : 'Payment method', paymentMethod),
    ];

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isArabic ? 'الإيصال' : 'Receipt',
                style: AppStyles.cardTitle.copyWith(fontSize: 18.sp),
              ),
              SizedBox(height: 8.h),
              for (final (name, text) in rows)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      Text(name, style: label),
                      const Spacer(),
                      Text(text, style: value),
                    ],
                  ),
                ),
              const Divider(color: AppColors.border),
              Row(
                children: [
                  Text(isArabic ? 'الإجمالي' : 'Total', style: value),
                  const Spacer(),
                  Text(
                    _pounds(booking.totalPrice),
                    style: value.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

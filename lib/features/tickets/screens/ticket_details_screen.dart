import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/arabicFormat.dart';
import '../../booking/models/trip_booking.dart';
import '../../booking/widget/booking_scaffold.dart';
import '../widget/receipt_sheet.dart';
import '../widget/ticket_pass_card.dart';

/// PDF page 7: the booked tickets, one page each, with the receipt.
///
/// Uses the same direction rules as the other screens, so it is no longer
/// mirrored like the mock.
class TicketDetailsScreen extends StatefulWidget {
  final TripBooking booking;

  /// Ticket to show first; the first ticket when null or unknown.
  final String? initialTicketId;

  const TicketDetailsScreen({
    super.key,
    required this.booking,
    this.initialTicketId,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  late final List<String> _ticketIds = widget.booking.ticketIds;
  late final int _initialPage =
      _ticketIds.indexOf(widget.initialTicketId ?? '').clamp(0, _ticketIds.length);
  late final PageController _pageController =
      PageController(initialPage: _initialPage);
  // Only the "1 of n" label listens to page changes.
  late final ValueNotifier<int> _currentPage = ValueNotifier(_initialPage);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  void _showReceipt(bool isArabic) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (_) => ReceiptSheet(booking: widget.booking, isArabic: isArabic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BookingScaffold(
      bodyBuilder: (context, isArabic) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, page, _) {
                final current = ArabicFormat.number(
                  page + 1,
                  isArabic: isArabic,
                );
                final total = ArabicFormat.number(
                  _ticketIds.length,
                  isArabic: isArabic,
                );
                return BookingPageTitle(
                  title: isArabic ? 'التذكرة' : 'Ticket',
                  subtitle: isArabic
                      ? '$current من $total'
                      : '$current of $total',
                );
              },
            ),
          ),
          // The pager takes the remaining height and each page scrolls, so
          // the card fits any screen size or text scale.
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _ticketIds.length,
              onPageChanged: (page) => _currentPage.value = page,
              itemBuilder: (context, index) => SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TicketPassCard(
                      booking: widget.booking,
                      ticketId: _ticketIds[index],
                      isArabic: isArabic,
                    ),
                    SizedBox(height: 18.h),
                    _ReceiptButton(
                      isArabic: isArabic,
                      onPressed: () => _showReceipt(isArabic),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptButton extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onPressed;

  const _ReceiptButton({required this.isArabic, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.receipt_long_outlined,
        size: 20.sp,
        color: AppColors.primaryRed,
      ),
      label: Text(
        isArabic ? 'الإيصال' : 'Receipt',
        style: AppStyles.cardTitle.copyWith(fontSize: 15.sp),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(64.h),
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

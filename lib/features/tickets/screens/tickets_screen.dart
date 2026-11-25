// lib/features/tickets/view/tickets_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_app/features/tickets/screens/ticket.dart';
import 'package:metro_app/features/tickets/screens/ticketCard.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/main_navigation_shell.dart';
import 'emptyTickets.dart';

class TicketsScreen extends StatefulWidget {
  /// لو القائمة فاضية هتظهر حالة "لا توجد تذاكر"
  final List<Ticket> tickets;

  const TicketsScreen({super.key, this.tickets = const []});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  bool _isArabic = true;

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        break;
      case 2:
        context.go(RouteNames.map);
        break;
      case 3:
        context.go(RouteNames.settings);
        break;
    }
  }

  String _countLabel(int count) {
    if (!_isArabic) return count == 1 ? '1 ticket' : '$count tickets';

    const digits = '٠١٢٣٤٥٦٧٨٩';
    final number = count.toString().split('').map((c) => digits[int.parse(c)]).join();

    if (count == 1) return 'تذكرة واحدة';
    if (count == 2) return 'تذكرتان';
    final lastTwo = count % 100;
    if (lastTwo >= 3 && lastTwo <= 10) return '$number تذاكر';
    return '$number تذكرة';
  }

  @override
  Widget build(BuildContext context) {
    final tickets = widget.tickets;

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: CustomAppBar(
          isArabic: _isArabic,
          logoAssetPath: AppAssets.cairoMetroIcon,
          onLanguageChanged: (val) => setState(() => _isArabic = val),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
          children: [
            Text(
              _isArabic ? 'تذاكري' : 'My Tickets',
              style: AppStyles.appTitle.copyWith(fontSize: 25.sp),
            ),
            if (tickets.isEmpty)
              EmptyTickets(
                isArabic: _isArabic,
                onPlanTrip: () => context.go(RouteNames.home),
              )
            else ...[
              SizedBox(height: 6.h),
              Text(
                _countLabel(tickets.length),
                style: AppStyles.bodyMuted.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                _isArabic ? 'قادمة' : 'Upcoming',
                style: AppStyles.cardTitle.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textDark,
                ),
              ),
              for (final ticket in tickets) ...[
                SizedBox(height: 9.h),
                TicketCard(ticket: ticket, isArabic: _isArabic),
              ],
            ],
          ],
        ),
        bottomNavigationBar: MainNavigation(
          currentIndex: 1,
          isArabic: _isArabic,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}

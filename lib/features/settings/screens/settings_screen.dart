// lib/features/settings/view/settings_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/main_navigation_shell.dart';
import '../../tickets/screens/ticketsData.dart';
import 'Clear_data_card.dart';
import 'about_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isArabic = true;

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.ticket);
        break;
      case 2:
        context.go(RouteNames.map);
        break;
      case 3:
        break;
    }
  }

  Future<void> _confirmClearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          title: Text(
            _isArabic ? 'مسح البيانات المحفوظة؟' : 'Clear saved data?',
            style: AppStyles.cardTitle,
          ),
          content: Text(
            _isArabic
                ? 'هيتم حذف الحجوزات والتفضيلات من هذا الجهاز.'
                : 'Bookings and preferences will be removed from this device.',
            style: AppStyles.bodyMuted,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(_isArabic ? 'إلغاء' : 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFA1262E),
              ),
              child: Text(_isArabic ? 'مسح' : 'Clear'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    // حالياً التذاكر في الذاكرة بس، لما تضيفي تخزين امسحيه هنا كمان
    TicketsData.booked.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isArabic ? 'تم مسح البيانات' : 'Data cleared',
          textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _isArabic ? 'الإعدادات' : 'Settings',
              style: AppStyles.appTitle.copyWith(fontSize: 25.sp),
            ),
            SizedBox(height: 20.h),
            AboutCard(isArabic: _isArabic),
            SizedBox(height: 20.h),
            ClearDataCard(isArabic: _isArabic, onTap: _confirmClearData),
          ],
        ),
        bottomNavigationBar: MainNavigation(
          currentIndex: 3,
          isArabic: _isArabic,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
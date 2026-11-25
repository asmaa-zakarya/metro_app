import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_language.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/main_navigation_shell.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});
  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  bool _isArabic = AppLanguage.isArabic.value;
  @override
  void initState() { super.initState(); AppLanguage.isArabic.addListener(_languageChanged); }
  void _languageChanged() { if (mounted) setState(() => _isArabic = AppLanguage.isArabic.value); }
  @override
  void dispose() { AppLanguage.isArabic.removeListener(_languageChanged); super.dispose(); }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
    child: Scaffold(
      appBar: CustomAppBar(
        isArabic: _isArabic, logoAssetPath: AppAssets.cairoMetroIcon,
        onLanguageChanged: (value) => AppLanguage.isArabic.value = value,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.confirmation_number_outlined, size: 54, color: AppColors.primaryRed),
            const SizedBox(height: 16),
            Text(_isArabic ? 'تذاكري' : 'My Tickets', style: AppStyles.cardTitle.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              _isArabic ? 'قسم التذاكر جاهز للتصميم، وسيتم ربطه بنظام الحجز لاحقًا.' : 'The tickets section is ready for UI work and will be connected to booking later.',
              textAlign: TextAlign.center, style: AppStyles.bodyMuted,
            ),
          ]),
        ),
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: 1, isArabic: _isArabic,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteNames.home); break;
            case 1: break;
            case 2: context.go(RouteNames.map); break;
            case 3: context.go(RouteNames.settings); break;
          }
        },
      ),
    ),
  );
}

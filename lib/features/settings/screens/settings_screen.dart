import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_language.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/main_navigation_shell.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Icon(Icons.language_rounded, color: AppColors.primaryRed),
              const SizedBox(width: 12),
              Expanded(child: Text(_isArabic ? 'لغة التطبيق' : 'App language', style: AppStyles.cardTitle)),
              TextButton(
                onPressed: () => AppLanguage.isArabic.value = !_isArabic,
                child: Text(_isArabic ? 'العربية' : 'English'),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Text(
            _isArabic ? 'الإعدادات الأخرى هتتضاف مع استكمال التطبيق.' : 'More settings will be added as the app is completed.',
            style: AppStyles.bodyMuted,
          ),
        ],
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: 3, isArabic: _isArabic,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteNames.home); break;
            case 1: context.go(RouteNames.ticket); break;
            case 2: context.go(RouteNames.map); break;
            case 3: break;
          }
        },
      ),
    ),
  );
}

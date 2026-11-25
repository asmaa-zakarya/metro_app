
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:metro_app/features/metro_map/widgets/map_header_section.dart';
import 'package:metro_app/features/metro_map/widgets/official_map_card.dart';

import '../../../core/constants/app_language.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/main_navigation_shell.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isArabic = AppLanguage.isArabic.value;

  @override
  void initState() {
    super.initState();
    AppLanguage.isArabic.addListener(_handleLanguageChanged);
  }

  void _handleLanguageChanged() {
    if (mounted) {
      setState(() {
        _isArabic = AppLanguage.isArabic.value;
      });
    }
  }

  @override
  void dispose() {
    AppLanguage.isArabic.removeListener(_handleLanguageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: CustomAppBar(
          isArabic: _isArabic,
          logoAssetPath: AppAssets.cairoMetroIcon,
          onLanguageChanged: (value) {
            AppLanguage.isArabic.value = value;
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            MapHeaderSection(isArabic: _isArabic),

            SizedBox(height: 14.h),

            OfficialMapCard(isArabic: _isArabic),
          ],
        ),
        bottomNavigationBar: MainNavigation(
          currentIndex: 2,
          isArabic: _isArabic,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(RouteNames.home);
                break;
              case 1:
                context.go(RouteNames.ticket);
                break;
              case 2:
                break;
              case 3:
                context.go(RouteNames.settings);
                break;
            }
          },
        ),
      ),
    );
  }
}

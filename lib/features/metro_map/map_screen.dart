import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metro_app/features/metro_map/widgets/map_header_section.dart';
import 'package:metro_app/features/metro_map/widgets/official_map_card.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widgets/custom_app_bar.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isArabic = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: CustomAppBar(
          isArabic: _isArabic,
          logoAssetPath: AppAssets.cairoMetroLogo,
          onLanguageChanged: (val) => setState(() => _isArabic = val),
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
      ),
    );
  }
}
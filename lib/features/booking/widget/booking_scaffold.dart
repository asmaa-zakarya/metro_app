import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_language.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';

typedef LanguageAwareBuilder = Widget Function(
  BuildContext context,
  bool isArabic,
);

/// Shared frame for the booking flow screens: text direction follows the
/// app language, the app bar has a back button, and an optional action
/// stays pinned to the bottom.
class BookingScaffold extends StatelessWidget {
  final LanguageAwareBuilder bodyBuilder;
  final LanguageAwareBuilder? bottomBuilder;

  /// Defaults to popping the current page.
  final VoidCallback? onBack;

  const BookingScaffold({
    super.key,
    required this.bodyBuilder,
    this.bottomBuilder,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppLanguage.isArabic,
      builder: (context, isArabic, _) {
        final bottomBuilder = this.bottomBuilder;
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: AppColors.bgLight,
            appBar: CustomAppBar(
              isArabic: isArabic,
              logoAssetPath: AppAssets.cairoMetroIcon,
              onLanguageChanged: (value) => AppLanguage.isArabic.value = value,
              onBack: onBack ?? () => context.pop(),
            ),
            body: bodyBuilder(context, isArabic),
            bottomNavigationBar: bottomBuilder == null
                ? null
                : SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                      child: bottomBuilder(context, isArabic),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

/// Large screen title with an optional muted subtitle, as on every PDF screen.
class BookingPageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const BookingPageTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 28.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isArabic;
  final ValueChanged<bool> onLanguageChanged;
  final String? logoAssetPath;

  /// When set, shows a back button at the start and centers the brand.
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.isArabic,
    required this.onLanguageChanged,
    this.logoAssetPath,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    if (onBack != null) return _buildWithBackButton();

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBrandTitle(),
          _buildLanguageSwitcher(),
        ],
      ),
    );
  }

  Widget _buildWithBackButton() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          _BackButton(onPressed: onBack!, isArabic: isArabic),
          Expanded(child: Center(child: _buildBrandTitle())),
          _buildLanguageSwitcher(),
        ],
      ),
    );
  }

  Widget _buildBrandTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (logoAssetPath != null)
          Image.asset(
            logoAssetPath!,
            height: 34,
            width: 34,
            // Decode at display size instead of the full image resolution.
            cacheWidth: 102,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildFallbackLogo(),
          )
        else
          _buildFallbackLogo(),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: AppStyles.appTitle,
            children: [
              TextSpan(text: isArabic ? 'مترو ' : 'Cairo '),
              TextSpan(
                text: isArabic ? 'القاهرة' : 'Metro',
                style: AppStyles.appTitle.copyWith(color: AppColors.primaryRed),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryRed, width: 1.2),
      ),
      child: const Icon(
        Icons.train_rounded,
        color: AppColors.primaryRed,
        size: 20,
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangPill(
            label: 'العربية',
            isSelected: isArabic,
            onTap: () => onLanguageChanged(true),
          ),
          _LangPill(
            label: 'English',
            isSelected: !isArabic,
            onTap: () => onLanguageChanged(false),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isArabic;

  const _BackButton({required this.onPressed, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Tooltip(
            message: isArabic ? 'رجوع' : 'Back',
            // arrow_back mirrors itself in RTL, so it points right in Arabic.
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.activeBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: AppStyles.bodyMuted.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

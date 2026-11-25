// lib/shared/widgets/main_navigation_shell.dart
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class MainNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isArabic;

  const MainNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isArabic = true,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(
        label: isArabic ? 'الرئيسية' : 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
      ),
      _NavItem(
        label: isArabic ? 'تذاكري' : 'Tickets',
        icon: Icons.confirmation_number_outlined,
        activeIcon: Icons.confirmation_number_rounded,
      ),
      _NavItem(
        label: isArabic ? 'الخريطة' : 'Map',
        icon: Icons.map_outlined,
        activeIcon: Icons.map_rounded,
      ),
      _NavItem(
        label: isArabic ? 'الإعدادات' : 'Settings',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              const activeColor = AppColors.primaryRed;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: 22.sp,
                        color: isSelected ? activeColor : AppColors.textMuted,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.bodyMuted.copyWith(
                          fontSize: 11.sp,
                          fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? activeColor : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

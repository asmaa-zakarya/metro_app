import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_styles.dart';

/// Full-width action button with the solid bottom shadow used across the PDF.
class PrimaryActionButton extends StatelessWidget {
  static const Color blue = Color(0xFF1877F2);
  static const Color blueShadow = Color(0xFF0F5FC4);
  static const Color green = Color(0xFF168A4A);
  static const Color greenShadow = Color(0xFF0F6F3A);

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color shadowColor;

  /// Puts the icon after the label (the "←" continue arrows in the PDF).
  final bool iconAfterLabel;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = blue,
    this.shadowColor = blueShadow,
    this.iconAfterLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final iconWidget = icon == null
        ? null
        : Icon(icon, size: 20.sp, color: Colors.white);

    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [BoxShadow(color: shadowColor, offset: Offset(0, 4.h))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: Size.fromHeight(54.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null && !iconAfterLabel) ...[
              iconWidget,
              SizedBox(width: 10.w),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.buttonLabel.copyWith(fontSize: 16.sp),
              ),
            ),
            if (iconWidget != null && iconAfterLabel) ...[
              SizedBox(width: 10.w),
              iconWidget,
            ],
          ],
        ),
      ),
    );
  }
}

// lib/features/settings/view/widgets/clear_data_card.dart
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_styles.dart';


class ClearDataCard extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onTap;

  const ClearDataCard({
    super.key,
    required this.isArabic,
    required this.onTap,
  });

  static const Color _titleColor = Color(0xFFA1262E);

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17.r),
      side: const BorderSide(color: Color(0xFFEFC8CB)),
    );

    return Material(
      color: const Color(0xFFFFF7F7),
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(13.w),
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: _titleColor,
                size: 22.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'مسح البيانات المحفوظة' : 'Clear saved data',
                      style: AppStyles.cardTitle.copyWith(
                        fontSize: 14.sp,
                        color: _titleColor,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      isArabic
                          ? 'يحذف الحجوزات والتفضيلات من هذا الجهاز'
                          : 'Removes bookings and preferences from this device',
                      style: AppStyles.bodyMuted.copyWith(
                        fontSize: 10.sp,
                        color: const Color(0xFF8C676A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

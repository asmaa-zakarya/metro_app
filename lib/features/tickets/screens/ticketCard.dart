// lib/features/tickets/view/widgets/ticket_card.dart
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metro_app/features/tickets/screens/ticket.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';


class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final bool isArabic;
  final VoidCallback? onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.isArabic,
    this.onTap,
  });

  static const Color _iconBg = Color(0xFFE4F6EB);
  static const Color _iconColor = Color(0xFF1E8E4E);

  String get _route => isArabic
      ? '${ticket.from.nameAr} ← ${ticket.to.nameAr}'
      : '${ticket.from.nameEn} → ${ticket.to.nameEn}';

  String get _date {
    final d = ticket.date.day.toString().padLeft(2, '0');
    final m = ticket.date.month.toString().padLeft(2, '0');
    final y = ticket.date.year.toString();

    if (!isArabic) return '$d/$m/$y';

    // \u200F تحافظ على ترتيب التاريخ من اليمين لليسار
    return _toArabicDigits('$d\u200F/$m\u200F/$y');
  }

  static String _toArabicDigits(String input) {
    const digits = '٠١٢٣٤٥٦٧٨٩';
    return input.replaceAllMapped(
      RegExp(r'[0-9]'),
          (match) => digits[int.parse(match[0]!)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
      side: const BorderSide(color: AppColors.border),
    );

    return Material(
      color: AppColors.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  color: _iconColor,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _route,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.cardTitle.copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      [
                        _date,
                        if (ticket.price != null)
                          isArabic
                              ? '${_toArabicDigits('${ticket.price}')} جنيه'
                              : '${ticket.price} EGP',
                        isArabic ? 'جاهزة للاستخدام' : 'Ready to use',
                      ].join(' · '),
                      style: AppStyles.bodyMuted.copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // الأيقونة بتتعكس لوحدها في اتجاه RTL
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

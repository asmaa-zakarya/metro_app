import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/metro_constants.dart';
import '../../../../core/theme/app_styles.dart';


class LineBadge extends StatelessWidget {
  final int lineNumber;
  final bool isArabic;

  const LineBadge({
    super.key,
    required this.lineNumber,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: MetroConstants.lineColor(lineNumber),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        MetroConstants.lineLabel(lineNumber, isArabic: isArabic),
        style: AppStyles.bodyMuted.copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
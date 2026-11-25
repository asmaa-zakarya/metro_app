import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routes/booking_arguments.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class BookingScreen extends StatelessWidget {
  final BookingArguments? arguments;
  const BookingScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final args = arguments;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الرحلة')),
        body: args == null
            ? const Center(child: Text('اختاري محطة الركوب والوصول أولًا'))
            : ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('محطة الركوب', style: AppStyles.bodyMuted),
                        SizedBox(height: 4.h),
                        Text(args.from.nameAr, style: AppStyles.cardTitle),
                        SizedBox(height: 18.h),
                        const Divider(),
                        SizedBox(height: 12.h),
                        Text('محطة الوصول', style: AppStyles.bodyMuted),
                        SizedBox(height: 4.h),
                        Text(args.to.nameAr, style: AppStyles.cardTitle),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.interchangeBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Text(
                      'تم تجهيز اختيار المحطات. حساب المسار الفعلي ووقت الرحلة والسعر يحتاج إلى بيانات اتصال المحطات وخوارزمية المسارات، وسيتم إضافته في المرحلة التالية.',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

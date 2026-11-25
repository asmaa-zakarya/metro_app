import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/metro_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../data/station_data.dart';
import 'line_badge.dart';

class StationSheet extends StatefulWidget {
  final String title;
  final bool isArabic;

  const StationSheet({
    super.key,
    required this.title,
    required this.isArabic,
  });

  @override
  State<StationSheet> createState() => _StationSheetState();
}

class _StationSheetState extends State<StationSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = StationsData.all.where((s) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return s.nameAr.contains(_query) || s.nameEn.toLowerCase().contains(q);
    }).toList();

    return Container(
      height: 0.82.sh,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppStyles.bodyMuted.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      widget.isArabic ? 'اختر ${widget.title}' : 'Select ${widget.title}',
                      style: AppStyles.cardTitle.copyWith(fontSize: 18.sp),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      widget.isArabic ? '${StationsData.all.length} محطة متاحة' : '${StationsData.all.length} stations available',
                      style: AppStyles.bodyMuted.copyWith(fontSize: 10.5.sp),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.close_rounded, size: 18.sp, color: AppColors.textDark),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: TextField(
              onChanged: (val) => setState(() => _query = val.trim()),
              decoration: InputDecoration(
                hintText: widget.isArabic ? 'ابحث باسم المحطة' : 'Search station name',
                hintStyle: AppStyles.bodyMuted.copyWith(fontSize: 13.sp),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.activeBlue, size: 20.sp),
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.activeBlue, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      widget.isArabic ? 'مفيش محطة بالاسم ده' : 'No station found',
                      style: AppStyles.bodyMuted.copyWith(fontSize: 13.sp),
                    ),
                  )
                : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, index) {
                final station = filtered[index];
                final mainColor = MetroConstants.lineColor(station.lines.first);

                return InkWell(
                  onTap: () => Navigator.pop(context, station),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isArabic ? station.nameAr : station.nameEn,
                                style: AppStyles.cardTitle.copyWith(fontSize: 14.sp),
                              ),
                              SizedBox(height: 4.h),
                              Wrap(
                                spacing: 6.w,
                                children: [
                                  ...station.lines.map(
                                        (line) => LineBadge(lineNumber: line, isArabic: widget.isArabic),
                                  ),
                                  if (station.isInterchange)
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.interchangeBg,
                                        borderRadius: BorderRadius.circular(5.r),
                                      ),
                                      child: Text(
                                        widget.isArabic ? 'محطة تبديل' : 'Interchange',
                                        style: AppStyles.bodyMuted.copyWith(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryRed,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
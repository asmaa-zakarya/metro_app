import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';

class OfficialMapCard extends StatefulWidget {
  final bool isArabic;

  const OfficialMapCard({
    super.key,
    required this.isArabic,
  });

  @override
  State<OfficialMapCard> createState() => _OfficialMapCardState();
}

class _OfficialMapCardState extends State<OfficialMapCard> {
  final TransformationController _transformationController =
  TransformationController();
  double _scale = 1.0;

  static const double _minScale = 1.0;
  static const double _maxScale = 4.0;
  static const double _step = 0.25;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _setScale(double newScale) {
    final clamped = newScale.clamp(_minScale, _maxScale);
    setState(() {
      _scale = clamped;
      _transformationController.value = Matrix4.identity()..scale(clamped);
    });
  }

  void _zoomIn() => _setScale(_scale + _step);

  void _zoomOut() => _setScale(_scale - _step);

  @override
  Widget build(BuildContext context) {
    final mapImage =
    widget.isArabic ? AppAssets.cairoMetroMap : AppAssets.cairoMetroMapEn;
    final zoomPercent = '${(_scale * 100).round()}%';

    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                widget.isArabic
                    ? 'الخريطة الرسمية للشبكة'
                    : 'Official Network Map',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                _ZoomButton(
                  icon: Icons.add_rounded,
                  onTap: _zoomIn,
                ),
                SizedBox(width: 10.w),
                Text(
                  zoomPercent,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(width: 10.w),
                _ZoomButton(
                  icon: Icons.remove_rounded,
                  onTap: _zoomOut,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: _minScale,
                  maxScale: _maxScale,
                  onInteractionEnd: (_) {
                    final currentScale =
                    _transformationController.value.getMaxScaleOnAxis();
                    setState(() => _scale = currentScale);
                  },
                  child: Center(
                    child: Image.asset(
                      mapImage,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          widget.isArabic
                              ? 'تعذر تحميل الخريطة'
                              : 'Failed to load map',
                          style: GoogleFonts.cairo(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
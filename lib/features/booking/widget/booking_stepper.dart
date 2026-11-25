import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

/// Three-step progress header: Review → Payment → Ticket.
class BookingStepper extends StatelessWidget {
  /// 1-based index of the step the user is on.
  final int currentStep;
  final bool isArabic;

  const BookingStepper({
    super.key,
    required this.currentStep,
    required this.isArabic,
  });

  List<String> get _labels => isArabic
      ? const ['المراجعة', 'الدفع', 'التذكرة']
      : const ['Review', 'Payment', 'Ticket'];

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppStyles.bodyMuted.copyWith(fontSize: 10.sp);
    final labels = _labels;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 15.w),
                child: Container(height: 1.5, color: AppColors.border),
              ),
            ),
          _StepDot(
            number: index + 1,
            label: labels[index],
            state: _stateOf(index + 1),
            labelStyle: labelStyle,
          ),
        ],
      ],
    );
  }

  _StepState _stateOf(int step) {
    if (step < currentStep) return _StepState.done;
    if (step == currentStep) return _StepState.current;
    return _StepState.upcoming;
  }
}

enum _StepState { done, current, upcoming }

class _StepDot extends StatelessWidget {
  final int number;
  final String label;
  final _StepState state;
  final TextStyle labelStyle;

  const _StepDot({
    required this.number,
    required this.label,
    required this.state,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = state != _StepState.upcoming;

    return Column(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primaryRed : AppColors.surface,
            border: isActive
                ? null
                : Border.all(color: AppColors.disabledGrey, width: 1.5),
          ),
          child: state == _StepState.done
              ? Icon(Icons.check_rounded, size: 18.sp, color: Colors.white)
              : Text(
                  // The PDF keeps Latin digits inside the step circles.
                  '$number',
                  style: labelStyle.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.textMuted,
                  ),
                ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: labelStyle.copyWith(
            color: isActive ? AppColors.primaryRed : AppColors.textMuted,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

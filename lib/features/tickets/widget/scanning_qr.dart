import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_colors.dart';

/// The ticket QR with a red scan line moving over it.
///
/// The QR and the line sit in separate repaint layers, so the animation only
/// repaints the line and the QR is drawn once.
class ScanningQr extends StatefulWidget {
  final String data;
  final double size;

  const ScanningQr({super.key, required this.data, required this.size});

  @override
  State<ScanningQr> createState() => _ScanningQrState();
}

class _ScanningQrState extends State<ScanningQr>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          RepaintBoundary(
            child: QrImageView(
              data: widget.data,
              size: size,
              padding: EdgeInsets.zero,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.primaryRed,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.primaryRed,
              ),
            ),
          ),
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Align(
                  alignment: Alignment(0, _controller.value * 2 - 1),
                  child: child,
                ),
                child: Container(
                  height: 2.5.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.35),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

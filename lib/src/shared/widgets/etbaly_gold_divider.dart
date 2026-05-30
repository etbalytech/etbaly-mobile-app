import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../extensions/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Etbaly Gold Divider Component
/// Horizontal gold gradient line matching web's .gold-divider
class EtbalyGoldDivider extends StatelessWidget {
  const EtbalyGoldDivider({
    super.key,
    this.width,
    this.height = 2,
    this.margin,
    this.animate = true,
  });

  final double? width;
  final double height;
  final EdgeInsets? margin;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;

    Widget divider = Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            etbalyColors.gold.withValues(alpha: 0.3),
            etbalyColors.gold,
            etbalyColors.gold.withValues(alpha: 0.3),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );

    if (animate) {
      divider = divider
          .animate()
          .fadeIn(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          )
          .scaleX(
            begin: 0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
    }

    return divider;
  }
}

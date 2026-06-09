import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../etbaly_web_tokens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EtbalyWebSectionShell extends StatelessWidget {
  EtbalyWebSectionShell({
    super.key,
    required this.child,
    this.backgroundPainter,
    this.backgroundColor = EtbalyWebColors.sectionBlack,
    EdgeInsets? margin,
  }) : margin = margin ?? EdgeInsets.only(top: 18.h);

  final Widget child;
  final CustomPainter? backgroundPainter;
  final Color backgroundColor;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(
          horizontal: (context.width < 390 ? 14 : 18).w,
          vertical: (context.width < 600 ? 16 : 28).h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: backgroundPainter == null
            ? child
            : CustomPaint(
                painter: backgroundPainter,
                child: child,
              ),
      ),
    );
  }
}

class EtbalyWebBadge extends StatelessWidget {
  const EtbalyWebBadge({
    super.key,
    required this.label,
    this.accent = EtbalyWebColors.gold,
    this.glowDot,
    this.trailingDot,
    this.websiteStyle = false,
  });

  final String label;
  final Color accent;
  final Color? glowDot;
  final Color? trailingDot;
  final bool websiteStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    if (websiteStyle) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: colors.borderColor),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              colors.bgCard.withValues(alpha: 0.78),
              colors.badgeBg,
              colors.bgCard.withValues(alpha: 0.70),
            ],
            stops: const [0, 0.58, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow,
              blurRadius: 16.r,
              offset: Offset(0.w, 8.h),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: accent,
                fontWeight: FontWeight.w900,
                fontSize: 13.sp,
              ),
            ),
            if (glowDot != null) ...[
              SizedBox(width: 13.w),
              _BadgeDot(color: glowDot!, size: 12.sp, glow: true),
            ],
            if (trailingDot != null) ...[
              SizedBox(width: 12.w),
              _BadgeDot(color: trailingDot!, size: 8.sp),
            ],
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: colors.badgeBg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: accent.withValues(alpha: 0.34)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BadgeDot(color: accent, size: 8.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: accent,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeDot extends StatelessWidget {
  const _BadgeDot({
    required this.color,
    required this.size,
    this.glow = false,
  });

  final Color color;
  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 14.r,
                  spreadRadius: 4.r,
                ),
              ]
            : null,
      ),
    );
  }
}

class EtbalyWebGoldDivider extends StatelessWidget {
  const EtbalyWebGoldDivider({super.key, this.width = 58});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            EtbalyWebColors.gold,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class EtbalyWebResponsiveGrid extends StatelessWidget {
  const EtbalyWebResponsiveGrid({
    super.key,
    required this.children,
    this.gap = 18,
  });

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
        final childWidth = (width - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children)
              SizedBox(width: childWidth, child: child),
          ],
        );
      },
    );
  }
}

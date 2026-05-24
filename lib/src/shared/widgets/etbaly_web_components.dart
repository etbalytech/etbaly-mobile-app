import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../etbaly_web_tokens.dart';

class EtbalyWebSectionShell extends StatelessWidget {
  const EtbalyWebSectionShell({
    super.key,
    required this.child,
    this.backgroundPainter,
    this.backgroundColor = EtbalyWebColors.sectionBlack,
    this.margin = const EdgeInsets.only(top: 18),
  });

  final Widget child;
  final CustomPainter? backgroundPainter;
  final Color backgroundColor;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(
          horizontal: context.width < 390 ? 14 : 18,
          vertical: context.width < 600 ? 34 : 46,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
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
    if (websiteStyle) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0x665C4A36)),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0x44251D33),
              Color(0x55402E2A),
              Color(0x33251D33),
            ],
            stops: [0, 0.58, 1],
          ),
          boxShadow: const [
            BoxShadow(
              color: EtbalyWebColors.shadow,
              blurRadius: 16,
              offset: Offset(0, 8),
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
                fontSize: 13,
              ),
            ),
            if (glowDot != null) ...[
              const SizedBox(width: 13),
              _BadgeDot(color: glowDot!, size: 12, glow: true),
            ],
            if (trailingDot != null) ...[
              const SizedBox(width: 12),
              _BadgeDot(color: trailingDot!, size: 8),
            ],
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: EtbalyWebColors.darkPill,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.34)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BadgeDot(color: accent, size: 8),
          const SizedBox(width: 8),
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
                  blurRadius: 14,
                  spreadRadius: 4,
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
      height: 3,
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

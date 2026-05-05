import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../extensions/context_extension.dart';

/// Etbaly Badge Component
/// Matches web version's .section-badge with dot + shimmer animation
class EtbalyBadge extends StatelessWidget {
  const EtbalyBadge({
    super.key,
    required this.text,
    this.color,
    this.icon,
    this.padding,
    this.animate = true,
  });

  final String text;
  final Color? color;
  final IconData? icon;
  final EdgeInsets? padding;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final badgeColor = color ?? etbalyColors.badgeBg;
    final textColor = etbalyColors.textMuted;

    Widget badge = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: etbalyColors.borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: textColor,
            ),
            const SizedBox(width: 6),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: etbalyColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: context.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );

    if (animate) {
      badge = badge.animate().fadeIn(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    }

    return badge;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../extensions/context_extension.dart';

/// Etbaly Card Component
/// Glassmorphism card with purple border glow matching web's .etbaly-card
class EtbalyCard extends StatelessWidget {
  const EtbalyCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.elevation,
    this.borderColor,
    this.animate = true,
    this.animationDelay = Duration.zero,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? borderColor;
  final bool animate;
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final designTokens = context.designTokens;

    Widget card = Container(
      margin: margin ?? const EdgeInsets.all(8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: etbalyColors.bgCard,
        borderRadius: borderRadius ?? BorderRadius.circular(designTokens.borderRadiusMedium),
        border: Border.all(
          color: borderColor ?? etbalyColors.borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: etbalyColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: etbalyColors.primaryGlow,
            blurRadius: 32,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(designTokens.borderRadiusMedium),
          onTap: onTap,
          child: card,
        ),
      );
    }

    if (animate) {
      card = card.animate().fadeIn(
        duration: const Duration(milliseconds: 600),
        delay: animationDelay,
        curve: Curves.easeOutCubic,
      ).slideY(
        begin: 0.1,
        duration: const Duration(milliseconds: 600),
        delay: animationDelay,
        curve: Curves.easeOutCubic,
      );
    }

    return card;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../extensions/context_extension.dart';

/// Etbaly Service Card Component
/// Icon + Title + Desc + Arrow link matching web's .service-card
class EtbalyServiceCard extends StatelessWidget {
  const EtbalyServiceCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.onTap,
    this.animate = true,
    this.animationDelay = Duration.zero,
  });

  final String title;
  final String description;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool animate;
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final designTokens = context.designTokens;

    Widget card = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: etbalyColors.bgCard,
        borderRadius: BorderRadius.circular(designTokens.borderRadiusMedium),
        border: Border.all(
          color: etbalyColors.borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: etbalyColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: etbalyColors.badgeBg,
                borderRadius: BorderRadius.circular(designTokens.borderRadiusSmall),
              ),
              child: Icon(
                icon,
                color: etbalyColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: etbalyColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: context.textTheme.bodySmall?.copyWith(
              color: etbalyColors.textMuted,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Learn more',
                style: context.textTheme.labelSmall?.copyWith(
                  color: etbalyColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                FontAwesomeIcons.arrowRight,
                color: etbalyColors.gold,
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(designTokens.borderRadiusMedium),
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

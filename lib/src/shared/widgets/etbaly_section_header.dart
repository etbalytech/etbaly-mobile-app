import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../extensions/context_extension.dart';
import 'etbaly_badge.dart';
import 'etbaly_gold_divider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Etbaly Section Header Component
/// Badge + Title + Gold divider + Description matching web's .section-header
class EtbalySectionHeader extends StatelessWidget {
  const EtbalySectionHeader({
    super.key,
    this.badge,
    required this.title,
    this.description,
    this.titleAlignment = TextAlign.center,
    this.descriptionAlignment = TextAlign.center,
    this.badgeIcon,
    this.animate = true,
    this.animationDelay = Duration.zero,
  });

  final String? badge;
  final String title;
  final String? description;
  final TextAlign titleAlignment;
  final TextAlign descriptionAlignment;
  final IconData? badgeIcon;
  final bool animate;
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;

    return Column(
      children: [
        if (badge != null) ...[
          EtbalyBadge(
            text: badge!,
            icon: badgeIcon,
            animate: animate,
          ),
          SizedBox(height: 16.h),
        ],
        Text(
          title,
          textAlign: titleAlignment,
          style: context.textTheme.headlineSmall?.copyWith(
            color: etbalyColors.textMain,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        )
            .animate(
              delay: animationDelay + const Duration(milliseconds: 100),
            )
            .fadeIn(
              duration: const Duration(milliseconds: 600),
            )
            .slideY(
              begin: 0.1,
              duration: const Duration(milliseconds: 600),
            ),
        SizedBox(height: 24.h),
        const EtbalyGoldDivider(
          animate: true,
        ),
        if (description != null) ...[
          SizedBox(height: 24.h),
          Text(
            description!,
            textAlign: descriptionAlignment,
            style: context.textTheme.bodyMedium?.copyWith(
              color: etbalyColors.textMuted,
              height: 1.6,
            ),
          )
              .animate(
                delay: animationDelay + const Duration(milliseconds: 300),
              )
              .fadeIn(
                duration: const Duration(milliseconds: 600),
              )
              .slideY(
                begin: 0.1,
                duration: const Duration(milliseconds: 600),
              ),
        ],
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../extensions/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: etbalyColors.bgCard,
        borderRadius: BorderRadius.circular(designTokens.borderRadiusMedium),
        border: Border.all(
          color: etbalyColors.borderColor.withValues(alpha: 0.3),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: etbalyColors.cardShadow,
            blurRadius: 20.r,
            offset: Offset(0.w, 8.h),
            spreadRadius: 0.r,
          ),
          BoxShadow(
            color: etbalyColors.primaryGlow,
            blurRadius: 32.r,
            offset: Offset(0.w, 8.h),
            spreadRadius: 0.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: etbalyColors.badgeBg,
                borderRadius:
                    BorderRadius.circular(designTokens.borderRadiusSmall),
              ),
              child: Icon(
                icon,
                color: etbalyColors.primary,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: etbalyColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: context.textTheme.bodySmall?.copyWith(
              color: etbalyColors.textMuted,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                'Learn more',
                style: context.textTheme.labelSmall?.copyWith(
                  color: etbalyColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                FontAwesomeIcons.arrowRight,
                color: etbalyColors.gold,
                size: 12.sp,
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
      card = card
          .animate()
          .fadeIn(
            duration: const Duration(milliseconds: 600),
            delay: animationDelay,
            curve: Curves.easeOutCubic,
          )
          .slideY(
            begin: 0.1,
            duration: const Duration(milliseconds: 600),
            delay: animationDelay,
            curve: Curves.easeOutCubic,
          );
    }

    return card;
  }
}
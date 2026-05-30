import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../extensions/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EtbalyPage extends StatelessWidget {
  EtbalyPage({
    super.key,
    required this.children,
    EdgeInsets? padding,
    this.separatorHeight = 18,
  }) : padding = padding ?? EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h);

  final List<Widget> children;
  final EdgeInsets padding;
  final double separatorHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Scaffold(
      backgroundColor: colors.bgMain,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: padding,
              sliver: SliverList.separated(
                itemCount: children.length,
                itemBuilder: (context, index) => children[index],
                separatorBuilder: (context, index) =>
                    SizedBox(height: separatorHeight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EtbalyHero extends StatelessWidget {
  const EtbalyHero({
    super.key,
    required this.badge,
    required this.title,
    required this.description,
    required this.icon,
    this.actions = const [],
    this.stats = const [],
  });

  final String badge;
  final String title;
  final String description;
  final IconData icon;
  final List<Widget> actions;
  final List<EtbalyStat> stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.bgCard,
            colors.bgSubtle,
            colors.primaryDark.withValues(alpha: 0.28),
          ],
        ),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: colors.primaryGlow,
            blurRadius: 36.r,
            offset: Offset(0.w, 16.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconTile(icon: icon),
              SizedBox(width: 12.w),
              Expanded(child: EtbalyPillBadge(label: badge)),
            ],
          ),
          SizedBox(height: 22.h),
          Text(
            title,
            style: context.textTheme.headlineMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.55,
            ),
          ),
          if (actions.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Wrap(spacing: 10.r, runSpacing: 10.r, children: actions),
          ],
          if (stats.isNotEmpty) ...[
            SizedBox(height: 22.h),
            Wrap(
              spacing: 10.r,
              runSpacing: 10.r,
              children: stats.map((stat) => _StatChip(stat: stat)).toList(),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, duration: 450.ms);
  }
}

class EtbalyPageSectionHeader extends StatelessWidget {
  const EtbalyPageSectionHeader({
    super.key,
    required this.badge,
    required this.title,
    this.description,
  });

  final String badge;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtbalyPillBadge(label: badge),
        SizedBox(height: 10.h),
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            color: colors.textMain,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (description != null) ...[
          SizedBox(height: 6.h),
          Text(
            description!,
            style: context.textTheme.bodySmall?.copyWith(
              color: colors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

class EtbalyPillBadge extends StatelessWidget {
  const EtbalyPillBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colors.badgeBg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelMedium?.copyWith(
          color: colors.primaryLight,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class EtbalyActionButton extends StatelessWidget {
  const EtbalyActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Material(
      color: outlined ? Colors.transparent : colors.gold,
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            border: outlined
                ? Border.all(color: colors.gold.withValues(alpha: 0.65))
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 17.sp, color: outlined ? colors.gold : Colors.black),
              SizedBox(width: 8.w),
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: outlined ? colors.gold : Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EtbalyInfoCard extends StatelessWidget {
  const EtbalyInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.accent,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color? accent;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final resolvedAccent = accent ?? colors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(8.r),
            border:
                Border.all(color: colors.borderColor.withValues(alpha: 0.34)),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: 20.r,
                offset: Offset(0.w, 10.h),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconTile(icon: icon, color: resolvedAccent),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: 10.w),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class EtbalyStat {
  EtbalyStat({required this.value, required this.label});

  final String value;
  final String label;
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.stat});

  final EtbalyStat stat;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: 96.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.bgMain.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.value,
            style: context.textTheme.titleLarge?.copyWith(
              color: colors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            stat.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                context.textTheme.labelSmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, this.color});

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final resolvedColor = color ?? colors.primary;

    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: resolvedColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: resolvedColor.withValues(alpha: 0.24)),
      ),
      child: Icon(icon, color: resolvedColor, size: 24.sp),
    );
  }
}
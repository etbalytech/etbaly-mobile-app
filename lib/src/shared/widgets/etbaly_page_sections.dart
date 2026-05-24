import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../extensions/context_extension.dart';

class EtbalyPage extends StatelessWidget {
  const EtbalyPage({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 28),
    this.separatorHeight = 18,
  });

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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
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
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconTile(icon: icon),
              const SizedBox(width: 12),
              Expanded(child: EtbalyPillBadge(label: badge)),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: context.textTheme.headlineMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.55,
            ),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(spacing: 10, runSpacing: 10, children: actions),
          ],
          if (stats.isNotEmpty) ...[
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
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
        const SizedBox(height: 10),
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            color: colors.textMain,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 6),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: colors.badgeBg,
        borderRadius: BorderRadius.circular(999),
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
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: outlined
                ? Border.all(color: colors.gold.withValues(alpha: 0.65))
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 17, color: outlined ? colors.gold : Colors.black),
              const SizedBox(width: 8),
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: colors.borderColor.withValues(alpha: 0.34)),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconTile(icon: icon, color: resolvedAccent),
              const SizedBox(width: 14),
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
                    const SizedBox(height: 6),
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
                const SizedBox(width: 10),
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
  const EtbalyStat({required this.value, required this.label});

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
      width: 96,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: colors.bgMain.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 2),
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
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: resolvedColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: resolvedColor.withValues(alpha: 0.24)),
      ),
      child: Icon(icon, color: resolvedColor, size: 24),
    );
  }
}

part of '../screens/home_page.dart';

class _StatsBandItem extends StatelessWidget {
  const _StatsBandItem({
    required this.value,
    required this.compactValue,
    required this.label,
    required this.compactLabel,
    required this.icon,
  });

  final String value;
  final String compactValue;
  final String label;
  final String compactLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final isMobile = width < 600;
    final isTight = width < 390;
    final resolvedValue = isMobile ? compactValue : value;
    final resolvedLabel = isMobile ? compactLabel : label;
    final iconSize = isTight ? 38.0 : (isMobile ? 44.0 : 52.0);
    final colors = context.etbalyColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.badgeBg,
            border: Border.all(color: colors.gold.withValues(alpha: 0.46)),
          ),
          child: Icon(
            icon,
            color: colors.gold,
            size: isTight ? 19 : 22,
          ),
        ),
        SizedBox(height: isTight ? 8 : 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            resolvedValue,
            maxLines: 1,
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.gold,
              fontSize: isTight ? 22 : (isMobile ? 24 : 30),
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
        SizedBox(height: isTight ? 5 : 6),
        Text(
          resolvedLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.labelMedium?.copyWith(
            color: colors.textMuted,
            fontSize: isTight ? 11 : 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

part of '../screens/home_page.dart';

class _WorkStepIcon extends StatelessWidget {
  const _WorkStepIcon({
    required this.icon,
    required this.accent,
    this.compact = false,
  });

  final IconData icon;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final outerSize = compact ? 58.0 : 76.0;
    final innerSize = compact ? 44.0 : 56.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: outerSize,
          height: outerSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 17 : 22),
            border: Border.all(
              color: accent.withValues(alpha: 0.28),
              width: 1.3,
            ),
          ),
        ),
        Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(compact ? 12 : 14),
            border: Border.all(color: accent.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, color: accent, size: compact ? 22 : 26),
        ),
      ],
    );
  }
}

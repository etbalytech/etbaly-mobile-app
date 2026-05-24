part of '../screens/home_page.dart';

class _WorkStepNumber extends StatelessWidget {
  const _WorkStepNumber({
    required this.number,
    required this.accent,
    this.large = false,
    this.compact = false,
  });

  final String number;
  final Color accent;
  final bool large;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = large ? 70.0 : (compact ? 28.0 : 32.0);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: large ? 0.12 : 0.1),
        shape: large ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: large ? null : BorderRadius.circular(7),
        border: Border.all(
          color: accent.withValues(alpha: large ? 0.48 : 0.34),
          width: large ? 1.7 : 1.1,
        ),
      ),
      child: Text(
        number,
        style: context.textTheme.titleMedium?.copyWith(
          color: accent,
          fontSize: large ? 22 : (compact ? 12 : 13),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

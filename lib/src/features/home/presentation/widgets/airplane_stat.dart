part of '../screens/home_page.dart';

class _AirplaneStat extends StatelessWidget {
  const _AirplaneStat({
    required this.value,
    required this.label,
    required this.isNarrow,
  });

  final String value;
  final String label;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [colors.primaryLight, colors.primary],
          ).createShader(bounds),
          child: SizedBox(
            height: isNarrow ? 30 : 36,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: isNarrow ? 27 : 31,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.textMuted,
            fontSize: isNarrow ? 10 : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          height: 2,
          width: isNarrow ? 58 : 74,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            gradient: LinearGradient(
              colors: [colors.primary, colors.primaryLight],
            ),
          ),
        ),
      ],
    );
  }
}

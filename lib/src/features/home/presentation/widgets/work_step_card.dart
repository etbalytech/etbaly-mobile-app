part of '../screens/home_page.dart';

class _WorkStepCard extends StatelessWidget {
  const _WorkStepCard({required this.step, required this.accent});

  final _WorkStepData step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.width < 600;
    final isNarrow = context.width < 390;
    final colors = context.etbalyColors;

    return Container(
      constraints: BoxConstraints(minHeight: isMobile ? 176 : 280),
      padding: EdgeInsets.all(isMobile ? (isNarrow ? 14.r : 16.r) : 24.r),
      decoration: BoxDecoration(
        color:
            colors.bgCard.withValues(alpha: context.isDarkMode ? 0.90 : 0.96),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.06),
            blurRadius: 34.r,
            spreadRadius: -6.r,
            offset: Offset(0.w, 16.h),
          ),
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 20.r,
            offset: Offset(0.w, 12.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            top: -62.h,
            end: -46,
            child: Container(
              width: 180.w,
              height: 180.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [accent.withValues(alpha: 0.13), Colors.transparent],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -80.h,
            start: -60,
            child: Container(
              width: 180.w,
              height: 180.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [accent.withValues(alpha: 0.06), Colors.transparent],
                ),
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMobile)
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            _WorkStepIcon(
                              icon: step.icon,
                              accent: accent,
                              compact: true,
                            ),
                            const Spacer(),
                            _WorkStepNumber(
                              number: step.number,
                              accent: accent,
                              compact: true,
                            ),
                          ],
                        )
                      else ...[
                        _WorkStepIcon(icon: step.icon, accent: accent),
                        SizedBox(height: 14.h),
                        _WorkStepNumber(number: step.number, accent: accent),
                      ],
                    ],
                  ),
                  SizedBox(height: isMobile ? 18 : 50),
                  Text(
                    step.title,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: colors.textMain,
                      fontSize: isMobile ? (isNarrow ? 20 : 21) : 24,
                      fontWeight: FontWeight.w900,
                      height: 1.22,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 20),
                  Text(
                    step.description,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colors.textMuted,
                      fontSize: isNarrow ? 13 : 14,
                      height: isMobile ? 1.65 : 1.9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 420)).slideY(
          begin: 0.08,
          end: 0,
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
        );
  }
}

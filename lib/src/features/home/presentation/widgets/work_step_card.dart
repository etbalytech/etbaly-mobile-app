part of '../screens/home_page.dart';

class _WorkStepCard extends StatelessWidget {
  const _WorkStepCard({required this.step, required this.accent});

  final _WorkStepData step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.width < 600;
    final isNarrow = context.width < 390;

    return Container(
      constraints: BoxConstraints(minHeight: isMobile ? 176 : 280),
      padding: EdgeInsets.all(isMobile ? (isNarrow ? 14 : 16) : 24),
      decoration: BoxDecoration(
        color: EtbalyWebColors.card.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.06),
            blurRadius: 34,
            spreadRadius: -6,
            offset: const Offset(0, 16),
          ),
          const BoxShadow(
            color: EtbalyWebColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            top: -62,
            end: -46,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [accent.withValues(alpha: 0.13), Colors.transparent],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -80,
            start: -60,
            child: Container(
              width: 180,
              height: 180,
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
                        const SizedBox(height: 14),
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
                      color: EtbalyWebColors.heading,
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
                      color: EtbalyWebColors.body,
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

part of '../screens/home_page.dart';

class _PartnerLogoCard extends StatelessWidget {
  const _PartnerLogoCard({
    required this.index,
    required this.distance,
  });

  final int index;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final isNarrow = width < 390;
    final sideAmount = distance.clamp(0.0, 1.0);
    final activeWidth = isNarrow ? 140.0 : 162.0;
    final activeHeight = isNarrow ? 106.0 : 122.0;
    final sideWidth = isNarrow ? 74.0 : 90.0;
    final sideHeight = isNarrow ? 60.0 : 72.0;
    final cardWidth = activeWidth + (sideWidth - activeWidth) * sideAmount;
    final cardHeight = activeHeight + (sideHeight - activeHeight) * sideAmount;
    final opacity = 1 - (0.62 * sideAmount);
    final blur = 3.0 * sideAmount;
    final scale = 1 - (0.14 * sideAmount);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xE08B5CF6),
                    const Color(0x887C3AED),
                    sideAmount,
                  )!,
                  width: 2 - (0.7 * sideAmount),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x668B5CF6)
                        .withValues(alpha: 0.4 * (1 - sideAmount)),
                    blurRadius: 34,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0x448B5CF6)
                        .withValues(alpha: 0.27 * (1 - sideAmount)),
                    blurRadius: 0,
                    spreadRadius: 3,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppAssets.partnerLogo(index + 1),
                fit: BoxFit.cover,
                cacheWidth: (activeWidth * pixelRatio).round(),
                cacheHeight: (activeHeight * pixelRatio).round(),
                filterQuality: FilterQuality.medium,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Partner ${index + 1}',
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF1E1732),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

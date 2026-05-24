part of '../screens/home_page.dart';

class _ProcessWave extends StatelessWidget {
  const _ProcessWave({required this.wave});

  final _WorkWaveData wave;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.width < 600;
    final waveTextWidth = isMobile
        ? math.max(180, context.width - 150).toDouble()
        : (context.width < 900 ? 300.0 : 420.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _WorkStepNumber(
                    number: wave.number, large: true, accent: wave.accent),
                const SizedBox(width: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: waveTextWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        wave.title,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: EtbalyWebColors.heading,
                          fontSize: isMobile ? 24 : 26,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wave.subtitle,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: EtbalyWebColors.body,
                          fontSize: isMobile ? 13 : 15,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 18),
                  SizedBox(
                    width: context.width < 900 ? 96 : 132,
                    child: SizedBox(
                      height: 44,
                      child: CustomPaint(
                        painter: _WaveConnectorPainter(
                          accent: wave.accent,
                          alternate: wave.alternate,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: isMobile ? 22 : 28),
          EtbalyWebResponsiveGrid(
            children: [
              for (final step in wave.cards)
                _WorkStepCard(step: step, accent: wave.accent),
            ],
          ),
        ],
      ),
    );
  }
}

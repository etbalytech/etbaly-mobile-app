part of '../screens/home_page.dart';

class _ProcessWave extends StatelessWidget {
  const _ProcessWave({required this.wave});

  final _WorkWaveData wave;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.width < 600;
    final waveTextWidth = context.width < 900 ? 300.0 : 420.0;
    final waveText = Column(
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
        SizedBox(height: 8.h),
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
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _WorkStepNumber(
                    number: wave.number, large: true, accent: wave.accent),
                SizedBox(width: 16.w),
                if (isMobile)
                  Expanded(child: waveText)
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: waveTextWidth),
                    child: waveText,
                  ),
                if (!isMobile) ...[
                  SizedBox(width: 18.w),
                  SizedBox(
                    width: context.width < 900 ? 96 : 132,
                    child: SizedBox(
                      height: 44.h,
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

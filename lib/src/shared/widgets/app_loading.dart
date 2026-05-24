import 'dart:math' as math;

import '../../imports/imports.dart';

/// Branded Etbaly loading screen matching the website preloader.
class AppLoading extends StatefulWidget {
  const AppLoading({
    super.key,
    this.message,
    this.size = 78,
    this.strokeWidth = 1.2,
    this.fullScreen = true,
  });

  final String? message;
  final double size;
  final double strokeWidth;
  final bool fullScreen;

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loader = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final width = MediaQuery.sizeOf(context).width;
        final logoSize = widget.size.clamp(58.0, width * 0.2);
        final scaledWidth = width * 0.72;
        final contentWidth = scaledWidth > 300 ? 300.0 : scaledWidth;

        return Container(
          width: widget.fullScreen ? double.infinity : null,
          height: widget.fullScreen ? double.infinity : null,
          color: widget.fullScreen ? const Color(0xFF050604) : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _EtbalyLoaderBackgroundPainter(progress),
                ),
              ),
              SizedBox(
                width: contentWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: logoSize * 1.95,
                      height: logoSize * 1.95,
                      child: CustomPaint(
                        painter: _EtbalyLoaderRingsPainter(
                          progress: progress,
                          strokeWidth: widget.strokeWidth,
                        ),
                        child: Center(
                          child: Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x55D4AF37),
                                  blurRadius: 26,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              AppAssets.logo,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'اطبعلي',
                      textAlign: TextAlign.center,
                      style: context.textTheme.displaySmall?.copyWith(
                        color: const Color(0xFFD4AF37),
                        fontSize: (width < 390 ? 34.0 : 38.0),
                        fontWeight: FontWeight.w500,
                        height: 1,
                        shadows: const [
                          Shadow(
                            color: Color(0x55D4AF37),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _EtbalyLoadingDivider(progress: progress),
                    const SizedBox(height: 20),
                    Text(
                      widget.message ?? 'جاري التحميل',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9D9684),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 42),
                    _EtbalyLoadingDots(progress: progress),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return widget.fullScreen ? loader : Center(child: loader);
  }
}

class _EtbalyLoadingDivider extends StatelessWidget {
  const _EtbalyLoadingDivider({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final glow = 0.45 + math.sin(progress * math.pi * 2).abs() * 0.55;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0x99D4AF37),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withValues(alpha: glow),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: glow * 0.5),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EtbalyLoadingDots extends StatelessWidget {
  const _EtbalyLoadingDots({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0x44D4AF37),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 11),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final local = (progress + index * 0.14) % 1;
            final pulse = math.sin(local * math.pi * 2).abs();
            return Container(
              width: 4 + pulse * 1.5,
              height: 4 + pulse * 1.5,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(
                  alpha: 0.35 + pulse * 0.65,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(
                      alpha: pulse * 0.35,
                    ),
                    blurRadius: 10,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _EtbalyLoaderRingsPainter extends CustomPainter {
  const _EtbalyLoaderRingsPainter({
    required this.progress,
    required this.strokeWidth,
  });

  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.31;
    final faintPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = const Color(0x33D4AF37);
    final darkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = const Color(0x22302512);
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFD4AF37);

    canvas.drawCircle(center, radius, faintPaint);
    canvas.drawCircle(center, radius * 1.3, darkPaint);
    canvas.drawCircle(center, radius * 1.6, darkPaint);

    final rect = Rect.fromCircle(center: center, radius: radius * 1.42);
    canvas.drawArc(
      rect,
      -math.pi / 2 + progress * math.pi * 2,
      math.pi * 0.65,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _EtbalyLoaderRingsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _EtbalyLoaderBackgroundPainter extends CustomPainter {
  const _EtbalyLoaderBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x331F1A08),
          Color(0x221D1607),
          Colors.transparent,
        ],
        stops: [0, 0.42, 1],
      ).createShader(
        Rect.fromCircle(center: center, radius: size.shortestSide * 0.55),
      );
    canvas.drawRect(Offset.zero & size, glowPaint);

    final vignettePaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Colors.transparent,
          Color(0x99000000),
        ],
        stops: [0.45, 1],
      ).createShader(
        Rect.fromCircle(center: center, radius: size.longestSide * 0.62),
      );
    canvas.drawRect(Offset.zero & size, vignettePaint);

    final texturePaint = Paint()
      ..color = const Color(0x071F1B12)
      ..strokeWidth = 1;
    const gap = 7.0;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        final wave = math.sin((x * 0.18) + (y * 0.12) + progress * math.pi * 2);
        if (wave > 0.88) {
          canvas.drawCircle(Offset(x, y), 0.55, texturePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EtbalyLoaderBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

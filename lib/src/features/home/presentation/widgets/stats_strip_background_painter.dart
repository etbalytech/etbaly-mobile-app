part of '../screens/home_page.dart';

class _StatsStripBackgroundPainter extends CustomPainter {
  _StatsStripBackgroundPainter({
    required this.progress,
    required this.colors,
    required this.isDark,
  });

  final double progress;
  final EtbalyColorsExtension colors;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.09 : 0.05)
      ..strokeWidth = 1;
    const step = 64.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final beamPaint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.52 : 0.26)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.02, size.height * 0.34),
      beamPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.38, 0),
      Offset(size.width * 0.14, size.height * 0.55),
      beamPaint,
    );

    final glowLeft = Paint()
      ..shader = RadialGradient(
        colors: [
          colors.primary.withValues(alpha: isDark ? 0.40 : 0.12),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(0, size.height * 0.1),
          radius: size.width * 0.65,
        ),
      );
    canvas.drawCircle(
        Offset(0, size.height * 0.1), size.width * 0.65, glowLeft);

    final sparkPaint = Paint()
      ..color = colors.gold.withValues(alpha: isDark ? 0.60 : 0.28);
    for (var i = 0; i < 12; i++) {
      final seed = i * 0.211;
      final x = size.width * ((seed * 4.9) % 1);
      final y = size.height * (0.02 + ((seed * 7.1) % 0.55));
      final radius =
          1.4 + math.sin((progress + seed) * math.pi * 2).abs() * 2.2;
      canvas.drawCircle(Offset(x, y), radius, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StatsStripBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.isDark != isDark;
  }
}

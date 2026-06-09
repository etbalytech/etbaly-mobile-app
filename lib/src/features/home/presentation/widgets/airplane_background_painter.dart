part of '../screens/home_page.dart';

class _AirplaneBackgroundPainter extends CustomPainter {
  _AirplaneBackgroundPainter({
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
      ..color = colors.primary.withValues(alpha: isDark ? 0.12 : 0.055)
      ..strokeWidth = 1;
    const step = 56.0;
    final shift = progress * step * 0.45;

    for (double x = -step + shift; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = -step + shift; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final center = Offset(size.width * 0.5, size.height * 0.43);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = colors.primary.withValues(alpha: isDark ? 0.14 : 0.10);
    canvas.drawCircle(center, 120, ringPaint);
    canvas.drawCircle(center, 190, ringPaint);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colors.primary.withValues(alpha: isDark ? 0.26 : 0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 210));
    canvas.drawCircle(center, 210, glowPaint);

    final sparkPaint = Paint()
      ..color = colors.primaryLight.withValues(alpha: isDark ? 0.40 : 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    for (var i = 0; i < 10; i++) {
      final seed = i * 0.21;
      final pulse = math.sin((progress + seed) * math.pi * 2);
      final x = size.width * ((seed * 4.7) % 1);
      final y = size.height * (0.14 + ((seed * 7.1) % 0.7));
      canvas.drawCircle(Offset(x, y), 2 + pulse.abs() * 2, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AirplaneBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.isDark != isDark;
  }
}

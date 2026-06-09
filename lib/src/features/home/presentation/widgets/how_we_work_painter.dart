part of '../screens/home_page.dart';

class _HowWeWorkPainter extends CustomPainter {
  const _HowWeWorkPainter({
    required this.colors,
    required this.isDark,
  });

  final EtbalyColorsExtension colors;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.07 : 0.055)
      ..strokeWidth = 1;
    const step = 72.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final leftGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          colors.primary.withValues(alpha: isDark ? 0.38 : 0.12),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(0, size.height * 0.18),
          radius: size.width * 0.7,
        ),
      );
    canvas.drawCircle(
        Offset(0, size.height * 0.18), size.width * 0.7, leftGlow);

    final linePaint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.54 : 0.28)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.05, size.height * 0.24),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.98, 0),
      Offset(size.width * 0.78, size.height * 0.26),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.92, size.height * 0.42),
      Offset(size.width, size.height * 0.56),
      linePaint,
    );

    final dashPaint = Paint()
      ..color = colors.gold.withValues(alpha: isDark ? 0.34 : 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final dashPath = Path()
      ..moveTo(-size.width * 0.05, size.height * 0.38)
      ..quadraticBezierTo(
        size.width * 0.15,
        size.height * 0.3,
        size.width * 0.28,
        size.height * 0.42,
      );
    final metrics = dashPath.computeMetrics();
    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final extract = metric.extractPath(distance, distance + 7);
        canvas.drawPath(extract, dashPaint);
        distance += 14;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HowWeWorkPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.isDark != isDark;
}

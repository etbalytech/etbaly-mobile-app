part of '../screens/home_page.dart';

class _PartnersBackgroundPainter extends CustomPainter {
  _PartnersBackgroundPainter({
    required this.colors,
    required this.isDark,
  });

  final EtbalyColorsExtension colors;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.10 : 0.05)
      ..strokeWidth = 1;
    const step = 72.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colors.primary.withValues(alpha: isDark ? 0.20 : 0.10),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.44),
          radius: size.width * 0.65,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.44),
      size.width * 0.65,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PartnersBackgroundPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.isDark != isDark;
}

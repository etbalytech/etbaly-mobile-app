part of '../screens/home_page.dart';

class _PartnersBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1A6F3FF5)
      ..strokeWidth = 1;
    const step = 72.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x335B21B6), Colors.transparent],
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

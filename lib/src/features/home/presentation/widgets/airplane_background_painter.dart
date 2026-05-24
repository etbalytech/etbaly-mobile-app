part of '../screens/home_page.dart';

class _AirplaneBackgroundPainter extends CustomPainter {
  _AirplaneBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1F6F3FF5)
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
      ..color = const Color(0x213D236C);
    canvas.drawCircle(center, 120, ringPaint);
    canvas.drawCircle(center, 190, ringPaint);

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x446F3FF5), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: 210));
    canvas.drawCircle(center, 210, glowPaint);

    final sparkPaint = Paint()
      ..color = const Color(0x66C084FC)
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
    return oldDelegate.progress != progress;
  }
}

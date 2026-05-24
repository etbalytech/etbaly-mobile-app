part of '../screens/home_page.dart';

class _IdeasSuccessBackgroundPainter extends CustomPainter {
  _IdeasSuccessBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1A6F3FF5)
      ..strokeWidth = 1;
    const step = 64.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final horizonY = size.height * 0.66;
    for (var i = 0; i < 22; i++) {
      final t = i / 21;
      final wavePaint = Paint()
        ..color = Color.lerp(
          const Color(0x995B21B6),
          const Color(0x887C3AED),
          t,
        )!
        ..strokeWidth = 1.1;
      final path = Path()..moveTo(-20, horizonY + (i - 11) * 6);
      for (double x = -20; x <= size.width + 20; x += 18) {
        final y = horizonY +
            (i - 11) * 6 +
            math.sin((x / 54) + progress * math.pi * 2 + i * 0.35) * 13;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, wavePaint);
    }

    final sparklePaint = Paint()
      ..color = const Color(0x88D4AF37)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    for (var i = 0; i < 18; i++) {
      final seed = i * 0.173;
      final x = size.width * ((seed * 5.7) % 1);
      final y = size.height * (0.05 + ((seed * 8.3) % 0.82));
      final pulse = 1 + math.sin((progress + seed) * math.pi * 2).abs() * 2;
      canvas.drawCircle(Offset(x, y), pulse, sparklePaint);
    }

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x336F3FF5), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.48),
          radius: size.width * 0.9,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.48),
      size.width * 0.9,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _IdeasSuccessBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

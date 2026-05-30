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

class _IdeasSuccessWaveBackdropPainter extends CustomPainter {
  _IdeasSuccessWaveBackdropPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0x007C3AED),
          Color(0x665B21B6),
          Color(0x887C3AED),
          Color(0x005B21B6),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, fillPaint);

    final horizonY = size.height * 0.48;
    for (var i = 0; i < 24; i++) {
      final t = i / 23;
      final wavePaint = Paint()
        ..color = Color.lerp(
          const Color(0xAA5B21B6),
          const Color(0x997C3AED),
          t,
        )!
        ..strokeWidth = 1.3;
      final path = Path()..moveTo(-24, horizonY + (i - 12) * 5.6);
      for (double x = -24; x <= size.width + 24; x += 16) {
        final y = horizonY +
            (i - 12) * 5.6 +
            math.sin((x / 48) + progress * math.pi * 2 + i * 0.35) * 11;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _IdeasSuccessWaveBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

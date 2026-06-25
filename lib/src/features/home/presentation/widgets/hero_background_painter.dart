part of '../screens/home_page.dart';

class _HeroBackgroundPainter extends CustomPainter {
  _HeroBackgroundPainter({
    required this.progress,
    required this.colors,
    required this.isDark,
  });

  final double progress;
  final EtbalyColorsExtension colors;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size);
    _paintBeams(canvas, size);
    _paintGoldMesh(canvas, size);
    _paintParticles(canvas, size);
    _paintComets(canvas, size);
  }

  // Gold particle mesh — mirrors the website's heroParticleCanvas animation.
  // Positions are computed deterministically from [progress] so they loop
  // seamlessly when the AnimationController repeats (period = 18 s).
  void _paintGoldMesh(Canvas canvas, Size sz) {
    const count = 20;
    final connectDist = sz.width * 0.36; // ~135 px on a 375-wide phone

    // Build positions
    final pos = List<Offset>.generate(count, (i) {
      final seed = i * 0.137 + 0.5;
      final baseX = (seed * 7.43) % 1.0;
      final baseY = (seed * 5.71) % 1.0;
      final t = progress * math.pi * 2;
      final dx = math.sin(t + seed * 3.7) * 0.07;
      final dy = math.cos(t * 0.73 + seed * 2.3) * 0.055;
      return Offset(
        sz.width * ((baseX + dx).clamp(0.01, 0.99)),
        sz.height * ((baseY + dy).clamp(0.01, 0.99)),
      );
    });

    // Lines between close particles
    final linePaint = Paint()..strokeWidth = isDark ? 0.7 : 0.5;
    for (int i = 0; i < count; i++) {
      for (int j = i + 1; j < count; j++) {
        final dist = (pos[i] - pos[j]).distance;
        if (dist < connectDist) {
          final a = (1 - dist / connectDist) * (isDark ? 0.28 : 0.16);
          linePaint.color = colors.gold.withValues(alpha: a);
          canvas.drawLine(pos[i], pos[j], linePaint);
        }
      }
    }

    // Dots with soft glow
    final dotPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.2);
    for (int i = 0; i < count; i++) {
      final seed = i * 0.137 + 0.5;
      final pulse = 1.0 + math.sin(progress * math.pi * 2 * 1.3 + seed * math.pi * 2) * 0.35;
      final alpha = (0.18 + (seed * 1.61) % 0.22) * (isDark ? 1.0 : 0.65);
      dotPaint.color = colors.gold.withValues(alpha: alpha);
      canvas.drawCircle(pos[i], 1.5 * pulse, dotPaint);
    }
  }

  void _paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.14 : 0.055)
      ..strokeWidth = 1;
    const step = 48.0;
    final shift = progress * step;

    for (double x = -step + shift; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = -step + shift; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintBeams(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          colors.primaryLight.withValues(alpha: isDark ? 0.54 : 0.24),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.4;

    final t = math.sin(progress * math.pi * 2);
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.98),
      Offset(size.width * (0.34 + t * 0.03), size.height * 0.02),
      beamPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.0, size.height * 0.44),
      Offset(size.width * (0.25 + t * 0.02), size.height * 0.36),
      beamPaint,
    );
  }

  void _paintParticles(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.primaryLight.withValues(alpha: isDark ? 0.66 : 0.26)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (var i = 0; i < 18; i++) {
      final seed = i * 0.137;
      final y = (size.height * (0.18 + (seed * 5.3) % 0.72) -
              progress * size.height * (0.22 + (i % 4) * 0.035)) %
          size.height;
      final x = size.width * ((seed * 7.7) % 1);
      final pulse = 1 + math.sin((progress + seed) * math.pi * 2) * 0.45;
      canvas.drawCircle(Offset(x, y), 1.3 * pulse, paint);
    }
  }

  void _paintComets(Canvas canvas, Size size) {
    for (var i = 0; i < 3; i++) {
      final local = (progress + i * 0.33) % 1;
      final startX = -size.width * 0.35;
      final x = startX + local * size.width * 1.55;
      final y = size.height * (0.12 + i * 0.23);
      final path = Path()
        ..moveTo(x, y)
        ..lineTo(x + 120, y - 38);
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            colors.primaryLight.withValues(alpha: isDark ? 0.66 : 0.24),
            colors.primary.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(x, y - 42, 130, 42))
        ..strokeWidth = i == 0 ? 2.2 : 1.4
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeroBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.isDark != isDark;
  }
}

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
    _paintParticles(canvas, size);
    _paintComets(canvas, size);
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

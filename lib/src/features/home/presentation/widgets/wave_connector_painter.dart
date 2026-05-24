part of '../screens/home_page.dart';

class _WaveConnectorPainter extends CustomPainter {
  const _WaveConnectorPainter({required this.accent, required this.alternate});

  final Color accent;
  final bool alternate;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final startY = size.height * 0.5;
    path.moveTo(0, startY);
    path.quadraticBezierTo(
      size.width * 0.5,
      alternate ? size.height : 0,
      size.width,
      startY,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..color = accent.withValues(alpha: 0.62);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 7), paint);
        distance += 14;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WaveConnectorPainter oldDelegate) {
    return oldDelegate.accent != accent || oldDelegate.alternate != alternate;
  }
}

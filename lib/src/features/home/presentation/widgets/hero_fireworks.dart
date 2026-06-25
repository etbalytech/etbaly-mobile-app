part of '../screens/home_page.dart';

// Mirrors the website's hero3d.ts _fireParticles() burst effect.
// Triggered when the brand badge is tapped.

const _kFwPalettes = <List<Color>>[
  [
    Color(0xFFFF6B9D), Color(0xFFA855F7), Color(0xFF38BDF8), Color(0xFFFBBF24),
    Color(0xFF34D399), Color(0xFFF472B6), Color(0xFF818CF8), Color(0xFFFB923C),
    Color(0xFFC084FC), Color(0xFFE879F9), Color(0xFF67E8F9), Color(0xFF4ADE80),
  ],
  [
    Color(0xFFFBBF24), Color(0xFFFFFFFF), Color(0xFFA855F7), Color(0xFF34D399),
    Color(0xFFFF6B9D), Color(0xFF818CF8), Color(0xFFF472B6), Color(0xFF38BDF8),
    Color(0xFFE879F9), Color(0xFF60A5FA), Color(0xFFFACC15), Color(0xFFFB923C),
  ],
  [
    Color(0xFF38BDF8), Color(0xFFFDE68A), Color(0xFFC084FC), Color(0xFFBBF7D0),
    Color(0xFFA855F7), Color(0xFF34D399), Color(0xFFFF6B9D), Color(0xFF818CF8),
    Color(0xFFFACC15), Color(0xFFF472B6), Color(0xFF67E8F9), Color(0xFFFB923C),
  ],
  [
    Color(0xFFA3E635), Color(0xFFE879F9), Color(0xFFFBBF24), Color(0xFF60A5FA),
    Color(0xFFFF6B9D), Color(0xFFA855F7), Color(0xFF34D399), Color(0xFFF472B6),
    Color(0xFFC084FC), Color(0xFFFB923C), Color(0xFFFACC15), Color(0xFF818CF8),
  ],
];

// ── Particle data ────────────────────────────────────────────────────────────

class _FwParticle {
  const _FwParticle({
    required this.cx,
    required this.cy,
    required this.tx,
    required this.ty,
    required this.gravity,
    required this.color,
    required this.radius,
    required this.startMs,
    required this.durationMs,
    required this.isTail,
  });

  final double cx, cy;   // burst center (screen coords)
  final double tx, ty;   // displacement vector
  final double gravity;  // extra downward pull (applied as ease²)
  final Color color;
  final double radius;
  final int startMs, durationMs;
  final bool isTail;     // tails fade linearly; stars pop then shrink
}

// ── Painter ──────────────────────────────────────────────────────────────────

class _FwPainter extends CustomPainter {
  _FwPainter(this.particles, this.elapsedMs);

  final List<_FwParticle> particles;
  final double elapsedMs;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (final p in particles) {
      final rawElapsed = elapsedMs - p.startMs;
      if (rawElapsed <= 0 || rawElapsed >= p.durationMs) continue;

      final t = rawElapsed / p.durationMs;
      final ease = 1.0 - math.pow(1.0 - t, 3.0).toDouble(); // ease-out cubic

      final x = p.cx + p.tx * ease;
      final y = p.cy + p.ty * ease + p.gravity * ease * ease;

      final double alpha;
      if (p.isTail) {
        alpha = (1.0 - t).clamp(0.0, 1.0);
      } else {
        alpha = t < 0.6 ? 1.0 : ((1.0 - t) / 0.4).clamp(0.0, 1.0);
      }
      if (alpha <= 0) continue;

      // Stars: scale 0 → 1.8 (at 7%) → 0.1 (at 100%)
      final double scale;
      if (p.isTail) {
        scale = 1.0;
      } else if (t < 0.07) {
        scale = t / 0.07 * 1.8;
      } else {
        scale = (1.8 + (0.1 - 1.8) * ((t - 0.07) / 0.93)).clamp(0.1, 1.8);
      }

      paint.color = p.color.withAlpha((alpha * 255).round());
      canvas.drawCircle(Offset(x, y), (p.radius * scale).clamp(0.5, 18.0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FwPainter old) => old.elapsedMs != elapsedMs;
}

// ── Overlay widget ───────────────────────────────────────────────────────────

class _FireworksOverlay extends StatefulWidget {
  const _FireworksOverlay({
    required this.origin,
    required this.screenSize,
    required this.onDone,
  });

  final Offset origin;
  final Size screenSize;
  final VoidCallback onDone;

  @override
  State<_FireworksOverlay> createState() => _FireworksOverlayState();
}

class _FireworksOverlayState extends State<_FireworksOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_FwParticle> _particles;

  static const int _kTotalMs = 2500;

  @override
  void initState() {
    super.initState();
    _particles = _buildFwParticles(widget.origin, widget.screenSize);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kTotalMs),
    )..forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          size: widget.screenSize,
          painter: _FwPainter(_particles, _ctrl.value * _kTotalMs),
        ),
      ),
    );
  }
}

// ── Particle factory ─────────────────────────────────────────────────────────

List<_FwParticle> _buildFwParticles(Offset origin, Size screen) {
  final rng = math.Random();
  final particles = <_FwParticle>[];

  final spread = math.min(screen.width, screen.height) * 0.22;
  final mg = spread * 0.5;

  double px(double lo, double hi) =>
      (mg + (screen.width - mg * 2) * (lo + rng.nextDouble() * (hi - lo)))
          .clamp(mg, screen.width - mg);
  double py(double lo, double hi) =>
      (mg + (screen.height - mg * 2) * (lo + rng.nextDouble() * (hi - lo)))
          .clamp(mg, screen.height - mg);

  // 4 burst origins: badge center + 3 random positions
  final bursts = [
    (origin.dx, origin.dy, 0),
    (px(0.55, 0.90), py(0.08, 0.40), 320),
    (px(0.05, 0.40), py(0.08, 0.40), 620),
    (px(0.20, 0.75), py(0.45, 0.80), 900),
  ];

  for (var bi = 0; bi < bursts.length; bi++) {
    final (cx, cy, delay) = bursts[bi];
    final pal = _kFwPalettes[bi % _kFwPalettes.length];

    // 14 stars per burst
    for (var i = 0; i < 14; i++) {
      final angle = (360.0 / 14) * i + rng.nextDouble() * 16 - 8;
      final dist = spread * (0.5 + rng.nextDouble() * 0.6);
      final radius = 2.0 + rng.nextDouble() * 4.0;
      final dur = 950 + (rng.nextDouble() * 430).toInt();

      particles.add(_FwParticle(
        cx: cx, cy: cy,
        tx: math.cos(angle * math.pi / 180) * dist,
        ty: math.sin(angle * math.pi / 180) * dist,
        gravity: 55 + rng.nextDouble() * 45,
        color: pal[i % pal.length],
        radius: radius,
        startMs: delay,
        durationMs: dur,
        isTail: false,
      ));
    }

    // 8 light-trail tails per burst
    for (var i = 0; i < 8; i++) {
      final angle = rng.nextDouble() * 360;
      final dist = spread * (0.35 + rng.nextDouble() * 0.5);
      final radius = 1.0 + rng.nextDouble() * 1.5;
      final dur = 800 + (rng.nextDouble() * 350).toInt();

      particles.add(_FwParticle(
        cx: cx, cy: cy,
        tx: math.cos(angle * math.pi / 180) * dist,
        ty: math.sin(angle * math.pi / 180) * dist,
        gravity: 35 + rng.nextDouble() * 35,
        color: pal[(i + 6) % pal.length],
        radius: radius,
        startMs: delay,
        durationMs: dur,
        isTail: true,
      ));
    }
  }

  return particles;
}

// ── Trigger function ─────────────────────────────────────────────────────────

void _triggerFireworks(
  BuildContext context,
  Offset origin, {
  VoidCallback? onDone,
}) {
  if (!context.mounted) return;
  final overlay = Overlay.of(context);
  final size = MediaQuery.of(context).size;
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _FireworksOverlay(
      origin: origin,
      screenSize: size,
      onDone: () {
        entry.remove();
        onDone?.call();
      },
    ),
  );
  overlay.insert(entry);
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../app_assets.dart';

/// Branded loading screen shown once per app launch, mirroring the website's
/// `#lux-splash`: dashed gold grid, corner ornaments, a breathing glow, the
/// logo inside two counter-rotating rings, the brand name, a diamond divider
/// and a progress bar.
///
/// It sits on top of [child] while the app builds underneath it. The child's
/// tickers stay paused until the splash starts to fade, so the home page's
/// entrance animations play for the user instead of behind the splash.
class EtbalySplashGate extends StatefulWidget {
  const EtbalySplashGate({super.key, required this.child});

  final Widget child;

  @override
  State<EtbalySplashGate> createState() => _EtbalySplashGateState();
}

class _EtbalySplashGateState extends State<EtbalySplashGate>
    with TickerProviderStateMixin {
  /// A language or theme change rebuilds the app; the splash must not replay.
  static bool _played = false;

  static const _introMs = 2000;
  static const _minimumHold = Duration(milliseconds: 2300);
  static const _fadeDuration = Duration(milliseconds: 650);

  late final AnimationController _intro;
  late final AnimationController _loop;
  late final AnimationController _fade;
  Timer? _holdTimer;
  late bool _visible;
  bool _releasing = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _visible = !_played;
    _played = true;
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _introMs),
    );
    _loop =
        AnimationController(vsync: this, duration: const Duration(seconds: 6));
    _fade = AnimationController(vsync: this, duration: _fadeDuration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_visible && !_started) {
      _started = true;
      _begin();
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _intro.dispose();
    _loop.dispose();
    _fade.dispose();
    super.dispose();
  }

  /// The native splash is a plain dark screen, so the logo is decoded first to
  /// keep it from popping in when the native splash is lifted.
  Future<void> _begin() async {
    try {
      await precacheImage(const AssetImage(AppAssets.logo), context)
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // A missing logo must never keep the user on the splash.
    }
    FlutterNativeSplash.remove();
    if (!mounted) return;
    _intro.forward();
    _loop.repeat();
    _holdTimer = Timer(_minimumHold, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    setState(() => _releasing = true);
    await _fade.forward();
    if (!mounted) return;
    _loop.stop();
    setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Stack(
      fit: StackFit.expand,
      children: [
        KeyedSubtree(
          key: const ValueKey('etbaly-app-content'),
          child: TickerMode(
            enabled: !_visible || _releasing,
            child: widget.child,
          ),
        ),
        if (_visible)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: !_releasing,
              child: FadeTransition(
                opacity: ReverseAnimation(_fade),
                child: _SplashScene(
                  intro: _intro,
                  loop: _loop,
                  isDark: isDark,
                  isArabic: isArabic,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum _SplashPalette {
  dark(
    background: Color(0xFF080807),
    gold: Color(0xFFD4AF37),
    brand: Color(0xFFD4AF37),
    muted: Color(0xFF9A968C),
    glow: Color(0x24D4AF37),
  ),
  light(
    background: Color(0xFFF7F3EC),
    gold: Color(0xFFB8941E),
    brand: Color(0xFF8A6800),
    muted: Color(0xFF7A7568),
    glow: Color(0x2EB8941E),
  );

  const _SplashPalette({
    required this.background,
    required this.gold,
    required this.brand,
    required this.muted,
    required this.glow,
  });

  final Color background;
  final Color gold;
  final Color brand;
  final Color muted;
  final Color glow;
}

class _SplashScene extends StatelessWidget {
  const _SplashScene({
    required this.intro,
    required this.loop,
    required this.isDark,
    required this.isArabic,
  });

  final AnimationController intro;
  final AnimationController loop;
  final bool isDark;
  final bool isArabic;

  static const _introSeconds = _EtbalySplashGateState._introMs / 1000;

  /// Eases [from]..[to] (seconds on the intro timeline) into 0..1.
  double _at(double from, double to, [Curve curve = Curves.easeOut]) {
    final seconds = intro.value * _introSeconds;
    return curve.transform(((seconds - from) / (to - from)).clamp(0.0, 1.0));
  }

  /// Same stops as the website's `progress-fill` keyframes.
  double get _progress {
    const stops = [
      [0.3, 0.0],
      [0.78, 0.25],
      [1.26, 0.65],
      [1.66, 0.88],
      [1.9, 1.0],
    ];
    final seconds = intro.value * _introSeconds;
    if (seconds <= stops.first[0]) return 0;
    for (var i = 1; i < stops.length; i++) {
      if (seconds <= stops[i][0]) {
        final a = stops[i - 1];
        final b = stops[i];
        final t = (seconds - a[0]) / (b[0] - a[0]);
        return a[1] + (b[1] - a[1]) * t;
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final p = isDark ? _SplashPalette.dark : _SplashPalette.light;
    final safe = MediaQuery.paddingOf(context);
    final cornerInset = math.max<double>(22, safe.top + 14);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: p.background,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: MediaQuery.withNoTextScaling(
        child: Material(
          color: p.background,
          child: AnimatedBuilder(
            animation: Listenable.merge([intro, loop]),
            builder: (context, _) {
              final breathe = 0.5 - 0.5 * math.cos(loop.value * 4 * math.pi);
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Dashed grid.
                  Opacity(
                    opacity:
                        _at(0.3, 1.5, Curves.easeOut) * (isDark ? 0.3 : 0.6),
                    child: CustomPaint(
                      painter: _GridPainter(
                        color: p.gold.withValues(alpha: isDark ? 1 : 0.45),
                      ),
                    ),
                  ),
                  // Breathing glow behind the logo.
                  Center(
                    child: Opacity(
                      opacity: 0.7 + 0.3 * breathe,
                      child: Transform.scale(
                        scale: 1 + 0.15 * breathe,
                        child: Container(
                          width: 520,
                          height: 520,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [p.glow, p.glow.withValues(alpha: 0)],
                              stops: const [0, 0.7],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _corner(p, Alignment.topLeft, cornerInset, 0.5, false, false),
                  _corner(p, Alignment.topRight, cornerInset, 0.6, true, false),
                  _corner(
                      p, Alignment.bottomLeft, cornerInset, 0.7, false, true),
                  _corner(
                      p, Alignment.bottomRight, cornerInset, 0.8, true, true),
                  Center(child: _centerpiece(p)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _corner(
    _SplashPalette p,
    Alignment alignment,
    double inset,
    double delay,
    bool flipX,
    bool flipY,
  ) {
    final t = _at(delay, delay + 0.8, Curves.easeOutBack);
    return Positioned(
      left: alignment.x < 0 ? inset : null,
      right: alignment.x > 0 ? inset : null,
      top: alignment.y < 0 ? inset : null,
      bottom: alignment.y > 0 ? inset : null,
      child: Opacity(
        opacity: _at(delay, delay + 0.8).clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.5 + 0.5 * t,
          alignment: alignment,
          child: Transform.flip(
            flipX: flipX,
            flipY: flipY,
            child: CustomPaint(
              size: const Size.square(34),
              painter: _CornerPainter(color: p.gold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rise(double from, double to, Widget child, {double dy = 6}) {
    final t = _at(from, to, const Cubic(0.16, 1, 0.3, 1));
    return Opacity(
      opacity: t.clamp(0.0, 1.0),
      child: Transform.translate(offset: Offset(0, dy * (1 - t)), child: child),
    );
  }

  Widget _centerpiece(_SplashPalette p) {
    final logoT = _at(0.2, 1.1, const Cubic(0.16, 1, 0.3, 1));
    final progress = _progress;

    final brandStyle = isArabic
        ? TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w800,
            fontSize: 32,
            height: 1.3,
            color: p.brand,
          )
        : TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 28,
            letterSpacing: 6,
            height: 1.3,
            color: p.brand,
          );
    final subStyle = TextStyle(
      fontFamily: isArabic ? 'Tajawal' : 'Sora',
      fontWeight: isArabic ? FontWeight.w500 : FontWeight.w300,
      fontSize: isArabic ? 14 : 11,
      letterSpacing: isArabic ? 0 : 5,
      color: p.muted,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: logoT.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - logoT)),
            child: Transform.scale(
              scale: 0.92 + 0.08 * logoT,
              child: SizedBox(
                width: 116,
                height: 116,
                child: CustomPaint(
                  painter: _RingsPainter(turn: loop.value, color: p.gold),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                p.gold.withValues(alpha: isDark ? 0.28 : 0.3),
                            blurRadius: 26,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.logo,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (context, error, stack) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _rise(
          0.5,
          1.4,
          Text(isArabic ? 'اطْبَعَلِيٌّ' : 'Etba3ly', style: brandStyle),
        ),
        const SizedBox(height: 8),
        _rise(0.7, 1.4, _divider(p)),
        const SizedBox(height: 14),
        _rise(
          0.85,
          1.55,
          Text(isArabic ? 'جاري التحميل' : 'LOADING', style: subStyle),
        ),
        const SizedBox(height: 40),
        _rise(1, 1.6, _progressBar(p, progress)),
      ],
    );
  }

  Widget _divider(_SplashPalette p) {
    Widget line(bool towardsStart) => Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: towardsStart
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                end: towardsStart
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                colors: [
                  p.gold.withValues(alpha: 0),
                  p.gold.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
        );

    return SizedBox(
      width: 200,
      child: Row(
        children: [
          line(true),
          const SizedBox(width: 10),
          Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 6,
              height: 6,
              color: p.gold.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(width: 10),
          line(false),
        ],
      ),
    );
  }

  Widget _progressBar(_SplashPalette p, double progress) {
    return SizedBox(
      width: 190,
      child: Column(
        children: [
          Container(
            height: 2,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: p.gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: progress,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: p.gold,
                    boxShadow: [
                      BoxShadow(
                        color: p.gold.withValues(alpha: 0.55),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 5; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.gold.withValues(
                      alpha: progress >= (i * 2 + 1) / 10 ? 0.7 : 0.2,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    for (final fx in const [0.2, 0.5, 0.8]) {
      _dashed(canvas, paint, Offset(size.width * fx, 0),
          Offset(size.width * fx, size.height));
    }
    for (final fy in const [0.25, 0.75]) {
      _dashed(canvas, paint, Offset(0, size.height * fy),
          Offset(size.width, size.height * fy));
    }
  }

  void _dashed(Canvas canvas, Paint paint, Offset a, Offset b) {
    const dash = 4.0;
    const gap = 6.0;
    final length = (b - a).distance;
    final dir = (b - a) / length;
    for (var d = 0.0; d < length; d += dash + gap) {
      canvas.drawLine(a + dir * d, a + dir * math.min(d + dash, length), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 40;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(1 * k, 22 * k)
        ..lineTo(1 * k, 1 * k)
        ..lineTo(22 * k, 1 * k),
      stroke,
    );
    canvas.drawCircle(
        Offset(2.5 * k, 2.5 * k), 2.2 * k, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.color != color;
}

/// Two thin rings, each carrying a comet-like arc that spins in opposite
/// directions (the website's `.ring-outer` / `.ring-inner`).
class _RingsPainter extends CustomPainter {
  const _RingsPainter({required this.turn, required this.color});

  /// 0..1 over the 6 second loop.
  final double turn;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.width / 2 - 1;
    final inner = outer - 11;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(
        center, outer, track..color = color.withValues(alpha: 0.14));
    canvas.drawCircle(
        center, inner, track..color = color.withValues(alpha: 0.08));

    _arc(canvas, center, outer,
        rotation: turn * 3 * 2 * math.pi,
        sweep: math.pi * 0.62,
        width: 2,
        color: color,
        headAtEnd: true);
    _arc(canvas, center, inner,
        rotation: -turn * 4 * 2 * math.pi + math.pi,
        sweep: math.pi * 0.5,
        width: 1.3,
        color: color.withValues(alpha: 0.6),
        headAtEnd: false);
  }

  void _arc(
    Canvas canvas,
    Offset center,
    double radius, {
    required double rotation,
    required double sweep,
    required double width,
    required Color color,
    required bool headAtEnd,
  }) {
    // Drawn around 12 o'clock (3π/2 in canvas angles), then rotated.
    final start = 1.5 * math.pi - sweep / 2;
    final rect = Rect.fromCircle(center: Offset.zero, radius: radius);
    final clear = color.withValues(alpha: 0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: headAtEnd ? [clear, color] : [color, clear],
      ).createShader(rect);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.drawArc(rect, start, sweep, false, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RingsPainter old) =>
      old.turn != turn || old.color != color;
}

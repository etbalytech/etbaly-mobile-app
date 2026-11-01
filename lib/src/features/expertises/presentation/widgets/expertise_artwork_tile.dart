import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter/scheduler.dart';

/// Timing of one tile's ambient motion (all loops, like the website's CSS).
class ExpertiseTileMotion {
  const ExpertiseTileMotion({
    required this.edge,
    required this.float,
    required this.sheen,
    required this.floatScale,
    required this.sheenStrength,
    this.sheenWindow = (0.45, 0.8),
  });

  /// One trip of the light around the border.
  final Duration edge;
  final Duration float;
  final Duration sheen;

  /// The artwork breathes between these scales.
  final (double, double) floatScale;

  /// Peak white of the diagonal sheen.
  final double sheenStrength;

  /// The part of the sheen loop in which the light crosses the tile.
  final (double, double) sheenWindow;

  /// Platform cards: 10 s border, 10 s float, 14 s sheen.
  static const card = ExpertiseTileMotion(
    edge: Duration(seconds: 10),
    float: Duration(seconds: 10),
    sheen: Duration(seconds: 14),
    floatScale: (0.992, 0.998),
    sheenStrength: 0.043,
  );

  /// Hero statistics: 7 s border, 6 s float, 8 s sheen.
  static const stat = ExpertiseTileMotion(
    edge: Duration(seconds: 7),
    float: Duration(seconds: 6),
    sheen: Duration(seconds: 8),
    floatScale: (0.975, 0.985),
    sheenStrength: 0.1,
    sheenWindow: (0.35, 0.65),
  );
}

/// An "Our Expertise" artwork (platform card or hero statistic) with the
/// website's travelling border light, slow float and diagonal sheen.
class ExpertiseArtworkTile extends StatefulWidget {
  const ExpertiseArtworkTile({
    super.key,
    required this.imageUrl,
    required this.aspectRatio,
    required this.radius,
    required this.accent,
    required this.secondary,
    required this.motion,
    required this.semanticLabel,
    this.phase = 0,
    this.padding = 0,
    this.borderOpacity = 1,
    this.decodeWidth,
    this.onTap,
  });

  final String imageUrl;
  final double aspectRatio;
  final double radius;
  final Color accent;
  final Color secondary;
  final ExpertiseTileMotion motion;
  final String semanticLabel;

  /// 0–1 offset into every loop, so neighbouring tiles do not move in step.
  final double phase;

  /// Gap between the border and the artwork.
  final double padding;
  final double borderOpacity;

  /// Decode the artwork at this many pixels wide (saves memory).
  final int? decodeWidth;
  final VoidCallback? onTap;

  @override
  State<ExpertiseArtworkTile> createState() => _ExpertiseArtworkTileState();
}

class _ExpertiseArtworkTileState extends State<ExpertiseArtworkTile>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _seconds = ValueNotifier<double>(0);
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(
      (elapsed) => _seconds.value = elapsed.inMicroseconds / 1e6,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Honour "remove animations" in the system accessibility settings.
    final still = MediaQuery.disableAnimationsOf(context);
    if (still && _ticker.isActive) {
      _ticker.stop();
      _seconds.value = 0;
    } else if (!still && !_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    super.dispose();
  }

  double _loop(Duration period) {
    final t = _seconds.value / (period.inMilliseconds / 1000) + widget.phase;
    return t - t.floorToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final colors = context.etbalyColors;
    // Light theme: the website mixes the accent with deep purple for contrast.
    final edge = dark
        ? widget.accent
        : Color.lerp(widget.accent, const Color(0xFF301548), 0.22)!;
    final innerRadius = math.max<double>(0, widget.radius - widget.padding);
    final motion = widget.motion;

    Widget tile = AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: [
            if (_pressed)
              BoxShadow(
                color: widget.accent.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.all(widget.padding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: _seconds,
                      builder: (context, child) {
                        final wave =
                            (1 - math.cos(_loop(motion.float) * 2 * math.pi)) /
                                2;
                        final (low, high) = motion.floatScale;
                        return Transform.scale(
                          scale: low + (high - low) * wave,
                          child: child,
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.contain,
                        memCacheWidth: widget.decodeWidth,
                        fadeInDuration: const Duration(milliseconds: 250),
                        placeholder: (context, url) =>
                            _ArtworkPlaceholder(accent: widget.accent),
                        errorWidget: (context, url, error) => _ArtworkFallback(
                          accent: widget.accent,
                          label: widget.semanticLabel,
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        painter: _SheenPainter(
                          clock: _seconds,
                          progress: () => _loop(motion.sheen),
                          strength: motion.sheenStrength,
                          window: motion.sheenWindow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              child: RepaintBoundary(
                child: Opacity(
                  opacity: widget.borderOpacity,
                  child: CustomPaint(
                    painter: ExpertiseEdgePainter(
                      clock: _seconds,
                      progress: () => _loop(motion.edge),
                      radius: widget.radius,
                      primary: edge,
                      secondary: widget.secondary,
                      head: dark
                          ? const Color(0xFFFFF5DF)
                          : const Color(0xFF4B2786),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.onTap != null) {
      tile = GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1,
          duration: const Duration(milliseconds: 160),
          child: tile,
        ),
      );
    }

    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: tile,
    );
  }
}

/// The website's `app-expertise-card-border`: a faint track plus a bright
/// trail with a light head and a short echo in the secondary colour, all
/// travelling clockwise around the rounded border.
class ExpertiseEdgePainter extends CustomPainter {
  ExpertiseEdgePainter({
    required Listenable clock,
    required this.progress,
    required this.radius,
    required this.primary,
    required this.secondary,
    required this.head,
  }) : super(repaint: clock);

  /// Where the light is, 0–1 around the border.
  final double Function() progress;
  final double radius;
  final Color primary;
  final Color secondary;
  final Color head;

  Size? _size;
  late RRect _rrect;
  late ui.PathMetric _metric;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _size) {
      _size = size;
      _rrect = RRect.fromRectAndRadius(
        const Offset(1.25, 1.25) & Size(size.width - 2.5, size.height - 2.5),
        Radius.circular(math.max(0, radius - 1.25)),
      );
      _metric = (Path()..addRRect(_rrect)).computeMetrics().first;
    }
    final metric = _metric;
    final length = metric.length;

    Paint stroke(Color color, double width, double opacity) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color.withValues(alpha: color.a * opacity);

    // Segment [start, start + span) in "percent of the border" units.
    void segment(double start, double span, Paint paint) {
      final from = (start % 100) / 100 * length;
      final to = from + span / 100 * length;
      canvas.drawPath(metric.extractPath(from, math.min(to, length)), paint);
      if (to > length) {
        canvas.drawPath(metric.extractPath(0, to - length), paint);
      }
    }

    canvas.drawRRect(_rrect, stroke(primary, 1, 0.3));
    final travel = progress() * 100;
    segment(travel, 17, stroke(primary, 4, 0.22));
    segment(travel, 17, stroke(primary, 2, 0.95));
    segment(travel + 14, 3, stroke(head, 2.5, 1));
    segment(travel + 58, 7, stroke(secondary, 1.75, 0.7));
  }

  @override
  bool shouldRepaint(ExpertiseEdgePainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.primary != primary ||
      oldDelegate.secondary != secondary ||
      oldDelegate.head != head;
}

/// A soft diagonal light that crosses the artwork once per loop.
class _SheenPainter extends CustomPainter {
  _SheenPainter({
    required Listenable clock,
    required this.progress,
    required this.strength,
    required this.window,
  }) : super(repaint: clock);

  final double Function() progress;
  final double strength;
  final (double, double) window;

  @override
  void paint(Canvas canvas, Size size) {
    final (start, end) = window;
    final p = progress();
    if (p <= start || p >= end) return;
    final t = (p - start) / (end - start);
    final shift = (-1.4 + 2.8 * t) * size.width;
    final fade = math.sin(t * math.pi);
    final rect = Offset(shift, 0) & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, -0.45),
        end: const Alignment(1, 0.45),
        colors: [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: strength * fade),
          Colors.white.withValues(alpha: 0),
        ],
        stops: const [0.33, 0.49, 0.65],
      ).createShader(rect);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_SheenPainter oldDelegate) =>
      oldDelegate.strength != strength || oldDelegate.window != window;
}

class _ArtworkPlaceholder extends StatelessWidget {
  const _ArtworkPlaceholder({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.14),
            context.etbalyColors.bgCard,
          ],
        ),
      ),
    );
  }
}

class _ArtworkFallback extends StatelessWidget {
  const _ArtworkFallback({required this.accent, required this.label});

  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: accent.withValues(alpha: 0.1)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            label.split('\n').first,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.etbalyColors.textMain,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

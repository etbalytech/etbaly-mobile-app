import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../extensions/context_extension.dart';

/// One picture in the full-screen viewer.
class EtbalyViewerImage {
  const EtbalyViewerImage({
    required this.provider,
    this.title,
    this.subtitle,
    this.heroTag,
  });

  final ImageProvider provider;

  /// Shown in a caption at the bottom (e.g. a person's name).
  final String? title;
  final String? subtitle;

  /// When set, the picture flies from the widget that carries the same [Hero] tag.
  final Object? heroTag;
}

/// Opens a professional full-screen image viewer: blurred dark backdrop,
/// the whole picture (never cropped), pinch and double-tap zoom, swipe between
/// pictures, swipe down to dismiss, and an optional caption.
Future<void> showEtbalyImageViewer(
  BuildContext context, {
  required List<EtbalyViewerImage> images,
  int initialIndex = 0,
}) {
  assert(images.isNotEmpty);
  return Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => _EtbalyImageViewer(
        images: images,
        initialIndex: initialIndex.clamp(0, images.length - 1),
      ),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    ),
  );
}

class _EtbalyImageViewer extends StatefulWidget {
  const _EtbalyImageViewer({required this.images, required this.initialIndex});

  final List<EtbalyViewerImage> images;
  final int initialIndex;

  @override
  State<_EtbalyImageViewer> createState() => _EtbalyImageViewerState();
}

class _EtbalyImageViewerState extends State<_EtbalyImageViewer>
    with SingleTickerProviderStateMixin {
  static const _dismissDistance = 110.0;
  static const _dismissVelocity = 900.0;

  late final PageController _pageController;
  late final AnimationController _settle;
  late int _index;

  bool _zoomed = false;
  bool _chromeVisible = true;
  double _dragY = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: _index);
    _settle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..addListener(() {
        setState(() =>
            _dragY = _dragY * (1 - Curves.easeOut.transform(_settle.value)));
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _settle.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).maybePop();

  void _onDrag(double dy) {
    _settle.stop();
    setState(() => _dragY = dy);
  }

  void _onDragEnd(double velocityY) {
    if (_dragY.abs() > _dismissDistance || velocityY.abs() > _dismissVelocity) {
      _close();
    } else {
      _settle
        ..value = 0
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final safe = MediaQuery.paddingOf(context);
    final colors = context.etbalyColors;
    final image = widget.images[_index];
    final dragProgress = (_dragY.abs() / (size.height * 0.5)).clamp(0.0, 1.0);
    final chromeVisible = _chromeVisible && !_zoomed && _dragY.abs() < 8;
    final hasCaption =
        (image.title ?? '').isNotEmpty || (image.subtitle ?? '').isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred, darkened page behind the picture.
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.9 * (1 - dragProgress)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, _dragY),
            child: Transform.scale(
              scale: 1 - dragProgress * 0.12,
              child: PageView.builder(
                controller: _pageController,
                physics: _zoomed
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                itemCount: widget.images.length,
                onPageChanged: (i) => setState(() {
                  _index = i;
                  _zoomed = false;
                }),
                itemBuilder: (context, i) => _ZoomablePage(
                  key: ValueKey(i),
                  image: widget.images[i],
                  active: i == _index,
                  onZoomChanged: (zoomed) {
                    if (i == _index && zoomed != _zoomed) {
                      setState(() => _zoomed = zoomed);
                    }
                  },
                  onTap: () => setState(() => _chromeVisible = !_chromeVisible),
                  onDrag: _onDrag,
                  onDragEnd: _onDragEnd,
                ),
              ),
            ),
          ),
          // Close button + counter
          Positioned(
            top: safe.top + 10,
            left: 14,
            right: 14,
            child: IgnorePointer(
              ignoring: !chromeVisible,
              child: AnimatedOpacity(
                opacity: chromeVisible ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Row(
                  // The close button stays in the top-right corner in both
                  // languages (an RTL row would flip it to the left).
                  textDirection: TextDirection.ltr,
                  children: [
                    if (widget.images.length > 1)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16)),
                        ),
                        child: Text(
                          '${_index + 1} / ${widget.images.length}',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Semantics(
                      button: true,
                      label: 'Close',
                      child: GestureDetector(
                        onTap: _close,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Center(
                            child: Icon(Icons.close_rounded,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Caption
          if (hasCaption)
            Positioned(
              left: 16,
              right: 16,
              bottom: safe.bottom + 16,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: chromeVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: colors.gold.withValues(alpha: 0.4)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if ((image.title ?? '').isNotEmpty)
                              Text(
                                image.title!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            if ((image.subtitle ?? '').isNotEmpty) ...[
                              SizedBox(height: 3.h),
                              Text(
                                image.subtitle!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.gold,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One zoomable picture: pinch to zoom, drag to pan, double-tap to zoom in/out,
/// and a single-finger vertical drag (when not zoomed) to dismiss the viewer.
class _ZoomablePage extends StatefulWidget {
  const _ZoomablePage({
    super.key,
    required this.image,
    required this.active,
    required this.onZoomChanged,
    required this.onTap,
    required this.onDrag,
    required this.onDragEnd,
  });

  final EtbalyViewerImage image;
  final bool active;
  final ValueChanged<bool> onZoomChanged;
  final VoidCallback onTap;
  final ValueChanged<double> onDrag;
  final ValueChanged<double> onDragEnd;

  @override
  State<_ZoomablePage> createState() => _ZoomablePageState();
}

class _ZoomablePageState extends State<_ZoomablePage>
    with SingleTickerProviderStateMixin {
  static const _doubleTapScale = 2.6;

  final _controller = TransformationController();
  late final AnimationController _anim;
  Animation<Matrix4>? _tween;

  Offset _tapPosition = Offset.zero;
  Offset _startFocal = Offset.zero;
  bool _pinching = false;
  bool _dragging = false;
  bool _lastZoomed = false;

  double get _scale => _controller.value.getMaxScaleOnAxis();

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        final tween = _tween;
        if (tween != null) _controller.value = tween.value;
      });
    _controller.addListener(_reportZoom);
  }

  @override
  void didUpdateWidget(covariant _ZoomablePage old) {
    super.didUpdateWidget(old);
    // A page the user swiped away from starts unzoomed when they come back.
    if (old.active && !widget.active) _controller.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_reportZoom)
      ..dispose();
    _anim.dispose();
    super.dispose();
  }

  void _reportZoom() {
    final zoomed = _scale > 1.02;
    if (zoomed != _lastZoomed) {
      _lastZoomed = zoomed;
      widget.onZoomChanged(zoomed);
    }
  }

  void _animateTo(Matrix4 target) {
    _tween = Matrix4Tween(begin: _controller.value, end: target).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );
    _anim
      ..value = 0
      ..forward();
  }

  void _onDoubleTap() {
    if (_scale > 1.02) {
      _animateTo(Matrix4.identity());
    } else {
      final p = _tapPosition;
      const s = _doubleTapScale;
      _animateTo(
        Matrix4.identity()
          ..translateByDouble(-p.dx * (s - 1), -p.dy * (s - 1), 0, 1)
          ..scaleByDouble(s, s, 1, 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget picture = Image(
      image: widget.image.provider,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSync) {
        if (frame == null && !wasSync) {
          return const Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: Colors.white70),
            ),
          );
        }
        return child;
      },
      errorBuilder: (_, __, ___) => const Center(
        child:
            Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48),
      ),
    );
    if (widget.image.heroTag != null) {
      picture = Hero(tag: widget.image.heroTag!, child: picture);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onDoubleTapDown: (d) => _tapPosition = d.localPosition,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1,
        maxScale: 5,
        onInteractionStart: (d) {
          _anim.stop();
          _startFocal = d.focalPoint;
          _pinching = d.pointerCount > 1;
          _dragging = false;
        },
        onInteractionUpdate: (d) {
          if (d.pointerCount > 1) _pinching = true;
          if (_scale <= 1.02 && !_pinching && d.pointerCount == 1) {
            _dragging = true;
            widget.onDrag(d.focalPoint.dy - _startFocal.dy);
          }
        },
        onInteractionEnd: (d) {
          if (_dragging && !_pinching) {
            widget.onDragEnd(d.velocity.pixelsPerSecond.dy);
          }
          _dragging = false;
          _pinching = false;
        },
        child: SizedBox.expand(child: picture),
      ),
    );
  }
}

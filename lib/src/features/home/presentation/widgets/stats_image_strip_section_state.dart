part of '../screens/home_page.dart';

class _StatsImageStripSectionState extends State<_StatsImageStripSection>
    with TickerProviderStateMixin {
  static const _pixelsPerSecond = 50.0;
  static const _imageCount = 10;

  late final AnimationController _bgController;
  AnimationController? _marqueeController;
  final _dragOffsetNotifier = ValueNotifier<double>(0);
  double _segmentWidth = 0;
  double _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _marqueeController?.dispose();
    _bgController.dispose();
    _dragOffsetNotifier.dispose();
    super.dispose();
  }

  void _ensureMarquee(double segmentWidth) {
    if (_marqueeController != null && _segmentWidth == segmentWidth) return;
    _segmentWidth = segmentWidth;
    _marqueeController?.dispose();
    _marqueeController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (segmentWidth / _pixelsPerSecond * 1000).round(),
      ),
    )..repeat();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails d) {
    final sw = _segmentWidth;
    if (sw == 0) return;
    _dragOffsetNotifier.value =
        ((_dragOffsetNotifier.value - d.delta.dx) % sw + sw) % sw;
  }

  void _onTapUp(TapUpDetails details) {
    final sw = _segmentWidth;
    final iw = _imageWidth;
    if (sw == 0 || iw == 0 || _marqueeController == null) return;
    final currentOffset =
        (_marqueeController!.value * sw + _dragOffsetNotifier.value) % sw;
    final contentX = details.localPosition.dx + currentOffset;
    final itemWidth = iw + 18.0;
    final idx = (contentX / itemWidth).floor() % _imageCount;
    _showStripLightbox(AppAssets.stripImage(idx + 1));
  }

  void _showStripLightbox(String image) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      builder: (ctx) => _StripLightbox(image: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final isNarrow = width < 390;
    final colors = context.etbalyColors;
    final isDark = context.isDarkMode;
    _imageWidth = isNarrow ? 230.0 : 270.0;
    final segmentWidth = (_imageWidth + 18) * _imageCount;
    _ensureMarquee(segmentWidth);

    final combined = Listenable.merge([
      _marqueeController!,
      _dragOffsetNotifier,
    ]);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [Color(0xFF130A2D), Color(0xFF090513)]
                  : [colors.bgSecondary, colors.bgSubtle],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _bgController,
                    builder: (context, _) => CustomPaint(
                      painter: _StatsStripBackgroundPainter(
                        progress: _bgController.value,
                        colors: colors,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 14 : 18,
                  isNarrow ? 8 : 12,
                  isNarrow ? 14 : 18,
                  30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _StripHeader(),
                    SizedBox(height: 28.h),
                    SizedBox(
                      height: isNarrow ? 260 : 300,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: _onTapUp,
                          onHorizontalDragUpdate: _onHorizontalDragUpdate,
                          child: ClipRect(
                            child: RepaintBoundary(
                              child: AnimatedBuilder(
                                animation: combined,
                                builder: (context, child) {
                                  final sw = _segmentWidth;
                                  if (sw == 0) {
                                    return child ?? const SizedBox.expand();
                                  }
                                  final offset =
                                      (_marqueeController!.value * sw +
                                              _dragOffsetNotifier.value) %
                                          sw;
                                  return Transform.translate(
                                    offset: Offset(-offset, 0),
                                    child: child,
                                  );
                                },
                                child: OverflowBox(
                                  alignment: Alignment.centerLeft,
                                  maxWidth: double.infinity,
                                  child: Row(
                                    children: [
                                      for (var rep = 0; rep < 3; rep++)
                                        for (var i = 0; i < _imageCount; i++)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 18.w,
                                            ),
                                            child: _StripImageCard(
                                              image: AppAssets.stripImage(
                                                i + 1,
                                              ),
                                              width: _imageWidth,
                                              onTap: () {},
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    const _StatsBand(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

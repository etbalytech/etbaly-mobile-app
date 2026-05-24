part of '../screens/home_page.dart';

class _AirplaneBrandSectionState extends State<_AirplaneBrandSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final isNarrow = width < 390;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(8),
        ),
        child: Container(
          width: double.infinity,
          height: isNarrow ? 790 : 740,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D051F),
                Color(0xFF080313),
                Color(0xFF100624),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _AirplaneBackgroundPainter(_controller.value),
                  );
                },
              ),
              _FloatingPlane(
                animation: _controller,
                top: isNarrow ? 170 : 188,
                reverse: true,
                flipHorizontally: true,
                size: isNarrow ? 62 : 76,
              ),
              _FloatingPlane(
                animation: _controller,
                top: isNarrow ? 490 : 515,
                size: isNarrow ? 54 : 68,
                delay: 0.42,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 18 : 22,
                  vertical: isNarrow ? 8 : 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _AirplaneBadge()
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 420))
                        .slideY(begin: -0.12),
                    const SizedBox(height: 44),
                    Text(
                      'نصنع علامتك التجارية باحترافية لا تُنسى',
                      textAlign: TextAlign.center,
                      style: context.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: isNarrow ? 36 : 42,
                        fontWeight: FontWeight.w900,
                        height: 1.22,
                        letterSpacing: 0,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 80))
                        .slideY(begin: 0.14),
                    const SizedBox(height: 26),
                    Text(
                      'من الهوية البصرية إلى الحضور الرقمي الكامل. نصنع تجربة علامة تجارية تتحدث عنك قبل أن تتكلم.',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: const Color(0xFFC0BACD),
                        fontSize: isNarrow ? 14 : 15,
                        fontWeight: FontWeight.w600,
                        height: 1.8,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 160))
                        .slideY(begin: 0.14),
                    SizedBox(height: isNarrow ? 34 : 42),
                    _AirplaneStatsCard(isNarrow: isNarrow)
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 240))
                        .slideY(begin: 0.12),
                    SizedBox(height: isNarrow ? 28 : 36),
                    const _AirplaneFeaturePills()
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 320))
                        .slideY(begin: 0.12),
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

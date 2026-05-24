part of '../screens/home_page.dart';

class _IdeasSuccessSectionState extends State<_IdeasSuccessSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
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
    final logo3dTop = (width * 0.085).clamp(26.0, 40.0);
    final logo3dHeight = (width * 0.72).clamp(254.0, 300.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF12072B), Color(0xFF090316)],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter:
                          _IdeasSuccessBackgroundPainter(_controller.value),
                    );
                  },
                ),
              ),
              Positioned(
                top: 14,
                right: 18,
                child: const _IdeasBadge()
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 420))
                    .slideX(begin: 0.18),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 18 : 22,
                  isNarrow ? 64 : 70,
                  isNarrow ? 18 : 22,
                  isNarrow ? 8 : 14,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(
                      const TextSpan(
                        children: [
                          TextSpan(text: 'نحوّل '),
                          TextSpan(
                            text: 'أفكارك\nإلى قصة نجاح\n',
                            style: TextStyle(color: Color(0xFFD4AF37)),
                          ),
                          TextSpan(text: 'على ارض الواقع'),
                        ],
                      ),
                      textAlign: TextAlign.right,
                      style: context.textTheme.displaySmall?.copyWith(
                        color: const Color(0xFFF2EEFF),
                        fontSize: isNarrow ? 42 : 48,
                        fontWeight: FontWeight.w900,
                        height: 1.22,
                        letterSpacing: 0,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 80))
                        .slideY(begin: 0.1),
                    const SizedBox(height: 18),
                    Text(
                      'حوّل علامتك التجارية إلى تجربة رقمية لا تُنسى.',
                      textAlign: TextAlign.right,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFD3CDE2),
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 160))
                        .slideY(begin: 0.1),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _IdeasActionButton(
                          label: 'ابدأ مشروعك',
                          icon: Icons.arrow_forward,
                          filled: true,
                          onTap: () => context.go(AppRoutes.contact),
                        ),
                        _IdeasActionButton(
                          label: 'شاهد أعمالنا',
                          onTap: () => context.go(AppRoutes.portfolio),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 240))
                        .slideY(begin: 0.1),
                    SizedBox(height: isNarrow ? 48 : 60),
                    SizedBox(
                      height: isNarrow ? 430 : 460,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: isNarrow ? 0 : 8,
                            right: isNarrow ? 10 : 28,
                            child: const _IdeasFloatingCard(
                              value: '150.4K',
                              label: 'متابع جديد',
                              icon: Icons.favorite,
                            ),
                          ),
                          Positioned(
                            top: isNarrow ? 324 : 346,
                            right: 0,
                            child: const _IdeasFloatingCard(
                              value: '187%+',
                              label: 'نمو الزيارات',
                              icon: Icons.bar_chart,
                            ),
                          ),
                          Positioned(
                            top: isNarrow ? 324 : 346,
                            left: isNarrow ? 16 : 46,
                            child: const _IdeasFloatingCard(
                              value: '5★',
                              label: 'تقييم العملاء',
                              icon: Icons.star,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: logo3dTop,
                                ),
                                child: Image.asset(
                                  AppAssets.logo3d,
                                  height: logo3dHeight,
                                  fit: BoxFit.contain,
                                ).animate(onPlay: (controller) {
                                  controller.repeat(reverse: true);
                                }).moveY(
                                  begin: -7,
                                  end: 7,
                                  duration: const Duration(seconds: 4),
                                  curve: Curves.easeInOut,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

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
    final logoStats = SizedBox(
      height: isNarrow ? 430 : 460,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _IdeasSuccessWaveBackdropPainter(_controller.value),
                );
              },
            ),
          ),
          Positioned(
            top: isNarrow ? 0 : 8,
            right: isNarrow ? 10 : 28,
            child: _IdeasFloatingCard(
              value: '150.4K',
              label: 'auto.t_d3bed41332'.tr(),
              icon: Icons.favorite,
            ),
          ),
          Positioned(
            top: isNarrow ? 324 : 346,
            right: 0.w,
            child: _IdeasFloatingCard(
              value: '187%+',
              label: 'auto.t_57b5421e7e'.tr(),
              icon: Icons.bar_chart,
            ),
          ),
          Positioned(
            top: isNarrow ? 324 : 346,
            left: isNarrow ? 16 : 46,
            child: _IdeasFloatingCard(
              value: '5★',
              label: 'auto.t_0d19e6d1f4'.tr(),
              icon: Icons.star,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: logo3dTop),
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
    );
    final introContent = Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: const _IdeasBadge()
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 420))
                  .slideX(begin: 0.18),
            ),
            SizedBox(height: 18.h),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'auto.t_eeb51b1fec'.tr()),
                  TextSpan(
                    text: 'auto.t_cf4ac7828f'.tr(),
                    style: const TextStyle(color: Color(0xFFD4AF37)),
                  ),
                  TextSpan(text: 'auto.t_30c70d285b'.tr()),
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
            SizedBox(height: 18.h),
            Text(
              'auto.t_03a56f3980'.tr(),
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
            SizedBox(height: 24.h),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 12.r,
              runSpacing: 12.r,
              children: [
                _IdeasActionButton(
                  label: 'auto.t_5c61c0aa73'.tr(),
                  icon: Icons.arrow_forward,
                  filled: true,
                  onTap: () => context.go(AppRoutes.contact),
                ),
                _IdeasActionButton(
                  label: 'auto.t_2ae93663e5'.tr(),
                  onTap: () => context.go(AppRoutes.portfolio),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 240))
                .slideY(begin: 0.1),
          ],
        ),
      ],
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
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
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 18 : 22,
                  isNarrow ? 14 : 18,
                  isNarrow ? 18 : 22,
                  isNarrow ? 22 : 28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    logoStats,
                    SizedBox(height: isNarrow ? 18 : 24),
                    introContent,
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

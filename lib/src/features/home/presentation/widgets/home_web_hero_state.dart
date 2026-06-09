part of '../screens/home_page.dart';

class _HomeWebHeroState extends State<_HomeWebHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
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
    final horizontalPadding = width < 390 ? 16.0 : 22.0;
    final colors = context.etbalyColors;
    final isDark = context.isDarkMode;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.r),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: isDark
                  ? const [
                      Color(0xFF100728),
                      Color(0xFF160B2E),
                      Color(0xFF0B061B),
                    ]
                  : const [
                      Color(0xFFFFFFFF),
                      Color(0xFFFAFAFE),
                      Color(0xFFF5F3FF),
                    ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _HeroBackgroundPainter(
                        progress: _controller.value,
                        colors: colors,
                        isDark: isDark,
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: _HeroGlow(
                  alignment: Alignment.topRight,
                  color: colors.primary.withValues(alpha: isDark ? 0.46 : 0.12),
                  size: 230.sp,
                ),
              ),
              Positioned.fill(
                child: _HeroGlow(
                  alignment: Alignment.bottomLeft,
                  color: colors.primaryLight
                      .withValues(alpha: isDark ? 0.32 : 0.10),
                  size: 260.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  26,
                  horizontalPadding,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: _HeroBrandBadge(),
                    )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 450))
                        .slideY(begin: -0.16),
                    SizedBox(height: width < 390 ? 26.h : 34.h),
                    Text(
                      'auto.t_33ef1845b6'.tr(),
                      textAlign: TextAlign.right,
                      style: _heroTitleStyle(context, width),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 80))
                        .slideY(begin: 0.18),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          colors.goldLight,
                          colors.gold,
                          colors.goldDark,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'auto.t_1df71b9933'.tr(),
                        textAlign: TextAlign.right,
                        style: _heroTitleStyle(context, width).copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 180))
                        .slideY(begin: 0.18),
                    SizedBox(height: 20.h),
                    Text(
                      'auto.t_e9c5fb7e87'.tr(),
                      textAlign: TextAlign.right,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: colors.textMuted,
                        fontSize: width < 390 ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 280))
                        .slideY(begin: 0.18),
                    SizedBox(height: 28.h),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12.r,
                      runSpacing: 12.r,
                      children: [
                        _HeroActionButton(
                          label: 'auto.t_300f7da948'.tr(),
                          icon: Icons.arrow_forward,
                          onTap: () => context.go(AppRoutes.services),
                        ),
                        _HeroActionButton(
                          label: 'auto.t_629d28fb52'.tr(),
                          outlined: true,
                          onTap: () => context.go(AppRoutes.about),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 360))
                        .slideY(begin: 0.18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _heroTitleStyle(BuildContext context, double width) {
    return (context.textTheme.displaySmall ?? const TextStyle()).copyWith(
      color: context.etbalyColors.textMain,
      fontSize: width < 360
          ? 26.sp
          : width < 390
              ? 30.sp
              : 34.sp,
      fontWeight: FontWeight.w900,
      height: 1.12,
      letterSpacing: 0,
    );
  }
}

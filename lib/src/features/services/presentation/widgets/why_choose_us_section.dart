import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EtbalyWhyChooseUsSection extends StatelessWidget {
  const EtbalyWhyChooseUsSection({super.key});

  static final _items = [
    _WhyChooseUsData(
      slug: 'twelve-years-experience',
      title: 'auto.t_553f73c9cf'.tr(),
      description: 'auto.t_67a7cba159'.tr(),
      icon: Icons.workspace_premium,
    ),
    _WhyChooseUsData(
      slug: 'guaranteed-results',
      title: 'auto.t_28e6b6b446'.tr(),
      description: 'auto.t_59ea3a8c76'.tr(),
      icon: Icons.rocket_launch,
    ),
    _WhyChooseUsData(
      slug: 'transparent-reports',
      title: 'auto.t_8470b479cf'.tr(),
      description: 'auto.t_66da1dd4a0'.tr(),
      icon: Icons.query_stats,
    ),
    _WhyChooseUsData(
      slug: 'support-24-7',
      title: 'auto.t_f5b5bccbee'.tr(),
      description: 'auto.t_e4eef56c5e'.tr(),
      icon: Icons.headset_mic,
    ),
    _WhyChooseUsData(
      slug: 'security-guarantee',
      title: 'auto.t_b6b5d39eee'.tr(),
      description: 'auto.t_96f9963b44'.tr(),
      icon: Icons.shield,
    ),
    _WhyChooseUsData(
      slug: 'documented-achievements',
      title: 'auto.t_cf044d61d6'.tr(),
      description: 'auto.t_6af7b96764'.tr(),
      icon: Icons.emoji_events,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: EtbalyWebSectionShell(
        backgroundPainter: _WhyChooseUsPainter(),
        child: Column(
          children: [
            EtbalyWebBadge(label: 'auto.t_312fc90033'.tr()),
            SizedBox(height: 18.h),
            Text(
              'auto.t_c18fb71739'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.displaySmall?.copyWith(
                color: EtbalyWebColors.heading,
                fontSize: context.width < 390 ? 42 : 50,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            SizedBox(height: 16.h),
            const EtbalyWebGoldDivider(),
            SizedBox(height: 26.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 720.w),
              child: Text(
                'auto.t_aeb13335bf'.tr(),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: EtbalyWebColors.body,
                  fontSize: context.width < 390 ? 14 : 16,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 34.h),
            EtbalyWebResponsiveGrid(
              children: [
                for (final item in _items) _WhyChooseUsCard(item: item),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WhyChooseUsCard extends StatelessWidget {
  const _WhyChooseUsCard({required this.item});

  final _WhyChooseUsData item;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.width < 600;

    return GestureDetector(
      onTap: () => context.push('/why-choose-us/${item.slug}'),
      child: Container(
        constraints: BoxConstraints(minHeight: isMobile ? 128 : 258),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 28,
          vertical: isMobile ? 18 : 36,
        ),
        decoration: BoxDecoration(
          color: EtbalyWebColors.card.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: EtbalyWebColors.border),
          boxShadow: [
            BoxShadow(
              color: EtbalyWebColors.shadow,
              blurRadius: 20.r,
              offset: Offset(0.w, 12.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12.h,
              right: 14.w,
              child: _WhyParticle(alpha: 0.14, size: 5.sp),
            ),
            Positioned(
              bottom: 24.h,
              left: 16.w,
              child: _WhyParticle(alpha: 0.08, size: 4.sp),
            ),
            if (isMobile)
              _WhyChooseUsMobileContent(item: item)
            else
              _WhyChooseUsDesktopContent(item: item),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 420)).slideY(
          begin: 0.08,
          end: 0,
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
        );
  }
}

class _WhyChooseUsMobileContent extends StatelessWidget {
  const _WhyChooseUsMobileContent({required this.item});

  final _WhyChooseUsData item;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _WhyIconTile(icon: item.icon, compact: true),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  item.title,
                  textAlign: TextAlign.right,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontSize: context.width < 390 ? 17 : 18,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            item.description,
            textAlign: TextAlign.right,
            style: context.textTheme.bodyMedium?.copyWith(
              color: EtbalyWebColors.body,
              fontSize: context.width < 390 ? 12.5 : 13,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyChooseUsDesktopContent extends StatelessWidget {
  const _WhyChooseUsDesktopContent({required this.item});

  final _WhyChooseUsData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _WhyIconTile(icon: item.icon),
        SizedBox(height: 22.h),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: context.textTheme.titleLarge?.copyWith(
            color: EtbalyWebColors.heading,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            height: 1.25,
          ),
        ),
        SizedBox(height: 11.h),
        Text(
          item.description,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: EtbalyWebColors.body,
            fontSize: 14.sp,
            height: 1.75,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _WhyIconTile extends StatelessWidget {
  const _WhyIconTile({required this.icon, this.compact = false});

  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final haloSize = compact ? 62.0 : 104.0;
    final tileSize = compact ? 48.0 : 72.0;
    final radius = compact ? 13.0 : 17.0;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: haloSize,
          height: haloSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: EtbalyWebColors.gold.withValues(alpha: 0.025),
            boxShadow: [
              BoxShadow(
                color: EtbalyWebColors.gold.withValues(alpha: 0.09),
                blurRadius: compact ? 16 : 26,
                spreadRadius: compact ? 1 : 4,
              ),
            ],
          ),
        ),
        Container(
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
            color: EtbalyWebColors.iconTile,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: EtbalyWebColors.goldBorder),
            boxShadow: [
              BoxShadow(
                color: EtbalyWebColors.gold.withValues(alpha: 0.17),
                blurRadius: compact ? 12 : 20,
                offset: Offset(0, compact ? 5 : 9),
              ),
              BoxShadow(
                color: const Color(0x55000000),
                blurRadius: 10.r,
                offset: Offset(0.w, 6.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: compact ? 6 : 8,
                left: compact ? 6 : 8,
                child: Container(
                  width: compact ? 20 : 29,
                  height: compact ? 9 : 13,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  icon,
                  color: EtbalyWebColors.gold,
                  size: compact ? 23 : 32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WhyParticle extends StatelessWidget {
  const _WhyParticle({required this.alpha, required this.size});

  final double alpha;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: EtbalyWebColors.gold.withValues(alpha: alpha),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _WhyChooseUsData {
  _WhyChooseUsData({
    required this.slug,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String slug;
  final String title;
  final String description;
  final IconData icon;
}

class _WhyChooseUsPainter extends CustomPainter {
  _WhyChooseUsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = EtbalyWebColors.grid
      ..strokeWidth = 1;
    const step = 70.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Glow effect
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x553B1F75), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width, size.height * 0.5),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawCircle(
      Offset(size.width, size.height * 0.5),
      size.width * 0.6,
      glowPaint,
    );

    // Line decoration
    final linePaint = Paint()
      ..color = EtbalyWebColors.purpleLine
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.1),
      Offset(size.width * 0.35, size.height * 0.25),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:etbaly/src/theme/etbaly_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EtbalyServicesShowcaseSection extends StatelessWidget {
  const EtbalyServicesShowcaseSection({super.key});

  List<_ServiceCardData> _buildServices() => [
        _ServiceCardData(
            slug: 'design',
            number: '01',
            title: 'auto.t_d23c852e02'.tr(),
            description: 'auto.t_a03df99f61'.tr(),
            icon: Icons.brush,
            imagePath: 'assets/images/services/design.webp'),
        _ServiceCardData(
            slug: 'social',
            number: '02',
            title: 'auto.t_fec25e47d8'.tr(),
            description: 'auto.t_90b9c2b24c'.tr(),
            icon: Icons.share,
            imagePath: 'assets/images/services/social.webp'),
        _ServiceCardData(
            slug: 'ads',
            number: '03',
            title: 'auto.t_c18b0ca07e'.tr(),
            description: 'auto.t_7833e9d1d7'.tr(),
            icon: Icons.campaign,
            imagePath: 'assets/images/services/ads.webp'),
        _ServiceCardData(
            slug: 'web',
            number: '04',
            title: 'auto.t_22aaa1064b'.tr(),
            description: 'auto.t_dfd354088f'.tr(),
            icon: Icons.code,
            imagePath: 'assets/images/services/web.webp'),
        _ServiceCardData(
            slug: 'mobile-app',
            number: '05',
            title: 'auto.t_75b4366b3d'.tr(),
            description: 'auto.t_b8d7e8ed60'.tr(),
            icon: Icons.phone_iphone,
            imagePath: 'assets/images/services/mobile.webp'),
        _ServiceCardData(
            slug: 'boost',
            number: '06',
            title: 'auto.t_a926e055d6'.tr(),
            description: 'auto.t_150d4b670a'.tr(),
            icon: Icons.photo_camera,
            imagePath: 'assets/images/services/boost.webp'),
        _ServiceCardData(
            slug: 'video',
            number: '07',
            title: 'auto.t_261ea35f06'.tr(),
            description: 'auto.t_ce74767a58'.tr(),
            icon: Icons.videocam,
            imagePath: 'assets/images/services/video.webp'),
        _ServiceCardData(
            slug: 'seo',
            number: '08',
            title: 'auto.t_943b26af5b'.tr(),
            description: 'auto.t_14f233c2dd'.tr(),
            icon: Icons.manage_search,
            imagePath: 'assets/images/services/seo.webp'),
        _ServiceCardData(
            slug: 'moderator',
            number: '09',
            title: 'auto.t_c7351ab69b'.tr(),
            description: 'auto.t_f9cacc63a6'.tr(),
            icon: Icons.support_agent,
            imagePath: 'assets/images/services/moderator.webp'),
        _ServiceCardData(
            slug: 'brand-plan',
            number: '10',
            title: 'auto.t_f9ebce237f'.tr(),
            description: 'auto.t_4df6936306'.tr(),
            icon: Icons.diamond,
            imagePath: 'assets/images/services/brand-plan.webp'),
      ];

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final services = _buildServices();

    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: EtbalyWebSectionShell(
        backgroundColor: colors.bgSecondary,
        backgroundPainter: _ServicesPainter(
          colors: colors,
          isDark: context.isDarkMode,
        ),
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            EtbalyWebBadge(label: 'auto.t_9a552e5cc5'.tr()),
            SizedBox(height: 18.h),
            Text(
              'auto.t_99b253f069'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.displaySmall?.copyWith(
                color: colors.textMain,
                fontSize: context.width < 390 ? 36 : 46,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
            ),
            SizedBox(height: 12.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 720.w),
              child: Text(
                'auto.t_0c5a74ddba'.tr(),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: colors.textMain.withValues(alpha: 0.9),
                  fontSize: context.width < 390 ? 14 : 16,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 34.h),
            EtbalyWebResponsiveGrid(
              gap: 16,
              children: [
                for (final service in services)
                  _ServiceShowcaseCard(service: service),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceShowcaseCard extends StatelessWidget {
  const _ServiceShowcaseCard({required this.service});

  final _ServiceCardData service;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final borderRadius = BorderRadius.circular(10.r);
    final isCompact = context.width < 600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/services/${service.slug}'),
        borderRadius: borderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: borderRadius,
            border: Border.all(color: colors.borderColor),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: 18.r,
                offset: Offset(0.w, 10.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        service.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: colors.bgSubtle,
                          child: Center(child: Icon(service.icon, color: colors.gold, size: 40.sp)),
                        ),
                      ),
                      // bottom gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 60.h,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                colors.bgCard.withValues(alpha: 0.80),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // service number badge
                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.bgCard.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                                color: colors.gold.withValues(alpha: 0.30)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            child: Text(
                              service.number,
                              style: TextStyle(
                                color: colors.gold,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Text section
              Padding(
                padding: EdgeInsets.all(isCompact ? 16.r : 20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // gold top line accent
                    Container(
                      width: 32.w,
                      height: 2.5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        gradient: LinearGradient(
                          colors: [colors.goldLight, colors.gold],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      service.title,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: colors.textMain,
                        fontSize: isCompact ? 20.sp : 21.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      service.description,
                      textAlign: TextAlign.right,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colors.textMuted,
                        fontSize: isCompact ? 13.sp : 14.sp,
                        height: 1.7,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'auto.t_932d8ab1c1'.tr(),
                          style: context.textTheme.labelLarge?.copyWith(
                            color: colors.gold,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Icon(
                          context.locale.languageCode == 'ar'
                              ? Icons.arrow_forward
                              : Icons.arrow_back,
                          color: colors.gold,
                          size: 17.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class _ServiceCardData {
  _ServiceCardData({
    required this.slug,
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.imagePath,
  });

  final String slug;
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final String imagePath;
}

class _ServicesPainter extends CustomPainter {
  _ServicesPainter({required this.colors, required this.isDark});

  final EtbalyColorsExtension colors;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.07 : 0.055)
      ..strokeWidth = 1;
    const step = 70.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colors.primary.withValues(alpha: isDark ? 0.22 : 0.12),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(0, size.height * 0.2),
          radius: size.width * 0.7,
        ),
      );
    canvas.drawCircle(
      Offset(0, size.height * 0.2),
      size.width * 0.7,
      glowPaint,
    );

    final linePaint = Paint()
      ..color = colors.primary.withValues(alpha: isDark ? 0.5 : 0.32)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.08, size.height * 0.22),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.94, size.height * 0.24),
      Offset(size.width, size.height * 0.08),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height * 0.58),
      Offset(size.width * 0.83, size.height * 0.72),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ServicesPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.isDark != isDark;
}

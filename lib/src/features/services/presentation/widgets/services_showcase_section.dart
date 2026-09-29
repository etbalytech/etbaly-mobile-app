import 'package:etbaly/src/imports/core_imports.dart';
import 'package:etbaly/src/theme/etbaly_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../data/services_catalog_data.dart';

/// The services grid: the same 15 services and copy as the website's
/// "Our services" page (icon, number, description, three highlights).
class EtbalyServicesShowcaseSection extends StatelessWidget {
  const EtbalyServicesShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';

    return EtbalyWebSectionShell(
      backgroundColor: colors.bgSecondary,
      backgroundPainter: _ServicesPainter(
        colors: colors,
        isDark: context.isDarkMode,
      ),
      margin: EdgeInsets.zero,
      child: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            EtbalyWebBadge(label: isAr ? 'خدماتنا' : 'Our Services'),
            SizedBox(height: 18.h),
            Text(
              isAr
                  ? 'كل ما تحتاجه لنجاحك الرقمي'
                  : 'Everything You Need to Succeed Digitally',
              textAlign: TextAlign.center,
              style: context.textTheme.displaySmall?.copyWith(
                color: colors.textMain,
                fontSize: context.width < 390 ? 32 : 42,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
            ),
            SizedBox(height: 12.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 720.w),
              child: Text(
                isAr
                    ? 'حلول تسويقية متكاملة ومتطورة تضع علامتك التجارية في المكان الذي تستحقه'
                    : 'Comprehensive and advanced marketing solutions that put your brand exactly where it deserves to be',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: colors.textMain.withValues(alpha: 0.9),
                  fontSize: context.width < 390 ? 14 : 16,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            EtbalyWebResponsiveGrid(
              gap: 16,
              children: [
                for (final service in catalogServices)
                  _ServiceCard(service: service, isArabic: isAr),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.isArabic});

  final CatalogService service;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final radius = BorderRadius.circular(16.r);
    final accent = service.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/services/${service.slug}'),
        borderRadius: radius,
        child: Ink(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: colors.bgCard,
            border: Border.all(color: colors.borderColor),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                accent.withValues(alpha: 0.13),
                colors.bgCard,
                colors.bgCard,
              ],
              stops: const [0, 0.55, 1],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          accent.withValues(alpha: 0.30),
                          accent.withValues(alpha: 0.08),
                        ],
                      ),
                      border: Border.all(color: accent.withValues(alpha: 0.4)),
                    ),
                    // FaIcon does not center itself inside a sized box.
                    child: Center(
                      child: FaIcon(service.icon, color: accent, size: 22.sp),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    service.number,
                    style: TextStyle(
                      color: colors.gold.withValues(alpha: 0.75),
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                service.title(isArabic),
                style: context.textTheme.titleLarge?.copyWith(
                  color: colors.textMain,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                service.desc(isArabic),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: colors.textMuted,
                  fontSize: 13.sp,
                  height: 1.7,
                ),
              ),
              SizedBox(height: 12.h),
              for (final feature in service.features(isArabic))
                Padding(
                  padding: EdgeInsets.only(bottom: 7.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        margin: EdgeInsets.only(top: 1.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.gold.withValues(alpha: 0.16),
                        ),
                        child: Center(
                          child: Icon(Icons.check_rounded,
                              color: colors.gold, size: 12.sp),
                        ),
                      ),
                      SizedBox(width: 9.w),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            color: colors.textMain,
                            fontSize: 12.sp,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 8.h),
              Container(height: 1, color: colors.borderColor),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Text(
                    isArabic ? 'عرض التفاصيل' : 'View Details',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: colors.gold,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                    color: colors.gold,
                    size: 18.sp,
                  ),
                ],
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
      Offset(size.width * 0.08, size.height * 0.05),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.94, size.height * 0.06),
      Offset(size.width, size.height * 0.02),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ServicesPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.isDark != isDark;
}

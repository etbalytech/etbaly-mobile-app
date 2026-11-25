// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:math' as math;

import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


String _serviceLocaleText(BuildContext context, String ar, String en) =>
    context.locale.languageCode == 'en' ? en : ar;

class ServiceDetailScreen extends StatefulWidget {
  ServiceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool get _isArabic => context.locale.languageCode == 'ar';

  _ServiceDetail get _detail => _details[widget.slug] ?? _details['design']!;

  static String? _assetImage(String slug) {
    if (slug == 'seo') return null;
    final map = {'mobile-app': 'mobile'};
    return 'assets/images/services/${map[slug] ?? slug}.webp';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.etbalyColors.bgMain,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _HeroSection(
                assetImage: _assetImage(widget.slug),
                detail: _detail,
                onBack: () => context.pop(),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 40.h),
              sliver: SliverList.list(
                children: [
                  _InfoSection(
                    detail: _detail,
                    showOrderButton: true,
                    onOrder: () => context.go(AppRoutes.contact),
                  ),
                  if (_detail.showEditPolicy) ...[
                    SizedBox(height: 28.h),
                    const _EditPolicyCard(),
                  ],
                  SizedBox(height: 28.h),
                  _OrderCtaCard(onTap: () => context.go(AppRoutes.contact)),
                  SizedBox(height: 32.h),
                  _ServiceCtaBanner(
                    onTap: () => context.go(AppRoutes.contact),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  _HeroSection({
    required this.assetImage,
    required this.detail,
    required this.onBack,
  });

  final String? assetImage;
  final _ServiceDetail detail;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (assetImage == null)
            ColoredBox(
              color: context.etbalyColors.bgSubtle,
              child: Icon(detail.icon, size: 76.sp, color: context.etbalyColors.gold),
            )
          else
            Image.asset(
              assetImage!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  ColoredBox(color: context.etbalyColors.bgSubtle),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x55000000), context.etbalyColors.bgMain],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 52.h,
            right:
                Directionality.of(context) == TextDirection.rtl ? 16.w : null,
            left: Directionality.of(context) == TextDirection.ltr ? 16.w : null,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999.r),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'auto.t_4561404281'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Section ─────────────────────────────────────────────────────────────

// ignore: unused_element
class _MobileAppComingSoonScreen extends StatelessWidget {
  const _MobileAppComingSoonScreen({
    required this.remaining,
    required this.onBack,
  });

  final Duration remaining;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24);
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return Scaffold(
      backgroundColor: context.etbalyColors.bgMain,
      body: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: _ComingSoonBackgroundPainter())),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height -
                      MediaQuery.paddingOf(context).top -
                      MediaQuery.paddingOf(context).bottom,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 28.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: _ComingSoonBackButton(onTap: onBack),
                      ),
                      SizedBox(height: 18.h),
                      _OrbitLogo(),
                      SizedBox(height: 42.h),
                      _ComingSoonBadge(),
                      SizedBox(height: 34.h),
                      Text(
                        _serviceLocaleText(
                          context,
                          'فريقنا يعمل بكامل طاقته لتقديم تجربة استثنائية. نعدك بشيء رائع يستحق الانتظار',
                          'Our team is working at full capacity to deliver an exceptional experience. Something worth the wait is coming.',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.etbalyColors.textMuted,
                          fontSize: 17.sp,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 34.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _TimeTile(
                                value: days,
                                label:
                                    _serviceLocaleText(context, 'يوم', 'Days')),
                            _TimeSeparator(),
                            _TimeTile(
                                value: hours,
                                label: _serviceLocaleText(
                                    context, 'ساعة', 'Hours')),
                            _TimeSeparator(),
                            _TimeTile(
                                value: minutes,
                                label: _serviceLocaleText(
                                    context, 'دقيقة', 'Minutes')),
                            _TimeSeparator(),
                            _TimeTile(
                                value: seconds,
                                label: _serviceLocaleText(
                                    context, 'ثانية', 'Seconds')),
                          ],
                        ),
                      ),
                      SizedBox(height: 44.h),
                      _ProgressSection(),
                      SizedBox(height: 24.h),
                    ],
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

class _ComingSoonBackButton extends StatelessWidget {
  const _ComingSoonBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.30),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              'auto.t_4561404281'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 126.w,
      height: 126.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112.w,
            height: 112.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.32)),
            ),
          ),
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFB9A3FF).withValues(alpha: 0.24)),
            ),
          ),
          Positioned(
            top: 13.h,
            left: 22.w,
            child: _OrbitDot(color: const Color(0xFFD4AF37), size: 8.w),
          ),
          Positioned(
            bottom: 10.h,
            child: _OrbitDot(color: const Color(0xFF7C3AED), size: 6.w),
          ),
          Container(
            width: 72.w,
            height: 72.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.etbalyColors.bgSubtle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.14),
                  blurRadius: 22.r,
                ),
              ],
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class _OrbitDot extends StatelessWidget {
  const _OrbitDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OrbitDot(color: const Color(0xFFD4AF37), size: 8.w),
          SizedBox(width: 10.w),
          Text(
            _serviceLocaleText(context, 'قادمون قريباً', 'Coming soon'),
            style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 62.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.etbalyColors.bgSubtle.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: const Color(0xFFB9A3FF).withValues(alpha: 0.18)),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: 30.sp,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(
            color: context.etbalyColors.textMuted,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TimeSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h, left: 8.w, right: 8.w),
      child: Text(
        ':',
        style: TextStyle(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.46),
          fontSize: 34.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '25%',
              style: TextStyle(
                color: const Color(0xFFD4AF37),
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            Spacer(),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.code,
                    color: context.etbalyColors.textMuted, size: 13.sp),
                SizedBox(width: 8.w),
                Text(
                  _serviceLocaleText(context, 'نسبة الإنجاز', 'Progress'),
                  style: TextStyle(
                    color: context.etbalyColors.textMuted,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: SizedBox(
            height: 10.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: Colors.white.withValues(alpha: 0.16)),
                FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: 0.25,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6F3FF5),
                          const Color(0xFFD4AF37)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/*
class HomeButton extends StatelessWidget {
  const HomeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: context.etbalyColors.borderColor,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
              color: const Color(0xFFB9A3FF).withValues(alpha: 0.16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الصفحة الرئيسية',
              style: TextStyle(
                color: context.etbalyColors.textMain,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.arrow_forward_rounded,
                color: context.etbalyColors.textMuted, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

*/
class _ComingSoonBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF221447),
          const Color(0xFF0F0E18),
          const Color(0xFF171029),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final dotPaint = Paint()
      ..color = const Color(0xFFB9A3FF).withValues(alpha: 0.045)
      ..strokeWidth = 1;
    const step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.48)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final paths = <Path>[
      Path()
        ..moveTo(size.width * 0.02, size.height * 0.28)
        ..lineTo(size.width * 0.21, size.height * 0.10),
      Path()
        ..moveTo(0, size.height * 0.86)
        ..lineTo(size.width * 0.28, size.height)
        ..lineTo(size.width * 0.55, size.height * 0.86)
        ..lineTo(size.width * 0.76, size.height),
      Path()
        ..moveTo(size.width, size.height * 0.78)
        ..lineTo(size.width * 0.78, size.height * 0.91)
        ..lineTo(size.width * 0.66, size.height * 0.84),
      Path()
        ..moveTo(size.width * 0.46, size.height)
        ..lineTo(size.width * 0.46, size.height * 0.86),
      Path()
        ..moveTo(size.width * 0.92, 0)
        ..lineTo(size.width, size.height * 0.07),
    ];
    for (final path in paths) {
      canvas.drawPath(path, linePaint);
    }

    final radius = math.min(size.width, size.height) * 0.42;
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6F3FF5).withValues(alpha: 0.22),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.52, size.height * 0.56),
          radius: radius,
        ),
      );
    canvas.drawCircle(
        Offset(size.width * 0.52, size.height * 0.56), radius, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfoSection extends StatelessWidget {
  _InfoSection({
    required this.detail,
    required this.showOrderButton,
    required this.onOrder,
  });

  final _ServiceDetail detail;
  final bool showOrderButton;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: Color(0xFFD4AF37).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999.r),
            border:
                Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: Color(0xFFD4AF37), size: 6.sp),
              SizedBox(width: 8.w),
              Icon(detail.icon, color: Color(0xFFD4AF37), size: 14.sp),
              SizedBox(width: 6.w),
              Text(
                'auto.t_300f7da948'.tr(),
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          detail.title,
          style: TextStyle(
            color: colors.textMain,
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            height: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          detail.description,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: 14.sp,
            height: 1.75,
          ),
        ),
        if (showOrderButton) ...[
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onOrder,
              icon: Icon(Icons.send_rounded, size: 17.sp),
              label: Text(
                'auto.t_af67816c17'.tr(),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
        ],
      ],
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: 420))
        .slideY(begin: 0.08);
  }
}

// ─── Edit Policy Card ─────────────────────────────────────────────────────────

class _EditPolicyCard extends StatelessWidget {
  const _EditPolicyCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.borderColor),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color: Color(0xFFD4AF37).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Color(0xFFD4AF37).withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(Icons.edit_note_rounded,
                    color: Color(0xFFD4AF37), size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Text(
                'auto.t_5a6ac77983'.tr(),
                style: TextStyle(
                  color: colors.textMain,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'auto.t_9e16e6281a'.tr(),
            style: TextStyle(
              color: colors.textMuted,
              height: 1.75,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order CTA Card ───────────────────────────────────────────────────────────

class _OrderCtaCard extends StatelessWidget {
  _OrderCtaCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0A2E), Color(0xFF0F0820)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFF7C3AED).withValues(alpha: 0.28)),
      ),
      child: Column(
        children: [
          Text(
            'auto.t_3e331b6b6c'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'auto.t_9cda1ed5f2'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(Icons.send_rounded, size: 18.sp),
              label: Text(
                'auto.t_af67816c17'.tr(),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Service CTA Banner ───────────────────────────────────────────────────────

class _ServiceCtaBanner extends StatelessWidget {
  _ServiceCtaBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 28.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isDark
              ? [Color(0xFF1A0A38), Color(0xFF0F0820), Color(0xFF0A0618)]
              : [
                  colors.bgCard,
                  colors.bgSubtle,
                  colors.gold.withValues(alpha: 0.14),
                ],
        ),
        border: Border.all(
          color: isDark
              ? Color(0xFFD4AF37).withValues(alpha: 0.22)
              : colors.gold.withValues(alpha: 0.38),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Color(0xFFD4AF37).withValues(alpha: 0.06)
                : colors.cardShadow,
            blurRadius: 32.r,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _CtaGridPainter(
          color: colors.primary.withValues(alpha: isDark ? 0.08 : 0.10),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: Color(0xFFD4AF37).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(
                    color: Color(0xFFD4AF37).withValues(alpha: 0.30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_rounded,
                      color: Color(0xFFD4AF37), size: 13.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'auto.t_300f7da948'.tr(),
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'auto.t_b3e8f9c2d1'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMain,
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'auto.t_a4d7c8e9f2'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 13.sp,
                height: 1.65,
              ),
            ),
            SizedBox(height: 22.h),
            Material(
              color: Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(999.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: onTap,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'auto.t_c5b9d4f8e3'.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.black, size: 18.sp),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: 420))
        .slideY(begin: 0.06);
  }
}

class _CtaGridPainter extends CustomPainter {
  _CtaGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 48.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CtaGridPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────

// ─── Data Models ──────────────────────────────────────────────────────────────

class _ServiceDetail {
  _ServiceDetail({
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    this.showEditPolicy = false,
  });

  final String title, description;
  final IconData icon;
  final List<_DetailPoint> points;
  final bool showEditPolicy;
}

class _DetailPoint {
  _DetailPoint({
    required this.title,
    required this.description,
    required this.icon,
    this.accentGold = false,
  });

  final String title, description;
  final IconData icon;
  final bool accentGold;
}

// ─── Service Data ─────────────────────────────────────────────────────────────

Map<String, _ServiceDetail> get _details => <String, _ServiceDetail>{
      'design': _ServiceDetail(
        title: 'auto.t_1ccbb8befd'.tr(),
        description: 'auto.t_ae433e7e1d'.tr(),
        icon: Icons.brush,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_5dbc6132d0'.tr(),
            description: 'auto.t_081f21ba48'.tr(),
            icon: Icons.palette,
          ),
          _DetailPoint(
            title: 'auto.t_5f404405a8'.tr(),
            description: 'auto.t_1710674483'.tr(),
            icon: Icons.auto_awesome,
            accentGold: true,
          ),
          _DetailPoint(
            title: 'auto.t_4ecca60ff5'.tr(),
            description: 'auto.t_c8283f1894'.tr(),
            icon: Icons.inventory_2,
          ),
        ],
      ),
      'social': _ServiceDetail(
        title: 'auto.t_fec25e47d8'.tr(),
        description: 'auto.t_c8bdf704cb'.tr(),
        icon: Icons.groups,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_1282b3ea04'.tr(),
            description: 'auto.t_e1ef9838ba'.tr(),
            icon: Icons.calendar_month,
          ),
          _DetailPoint(
            title: 'auto.t_8ec69ca100'.tr(),
            description: 'auto.t_5279470715'.tr(),
            icon: Icons.forum,
          ),
          _DetailPoint(
            title: 'auto.t_0504b29cd7'.tr(),
            description: 'auto.t_edd53c15c6'.tr(),
            icon: Icons.insights,
            accentGold: true,
          ),
        ],
      ),
      'ads': _ServiceDetail(
        title: 'auto.t_e9e1e060a2'.tr(),
        description: 'auto.t_135228e1e8'.tr(),
        icon: Icons.campaign,
        points: [
          _DetailPoint(
            title: 'auto.t_552a7fb024'.tr(),
            description: 'auto.t_f130e84398'.tr(),
            icon: Icons.tune,
          ),
          _DetailPoint(
            title: 'auto.t_36db49811f'.tr(),
            description: 'auto.t_866299b707'.tr(),
            icon: Icons.science,
            accentGold: true,
          ),
          _DetailPoint(
            title: 'auto.t_b0a85e4b52'.tr(),
            description: 'auto.t_adf7a7f6cb'.tr(),
            icon: Icons.trending_up,
          ),
        ],
      ),
      'web': _ServiceDetail(
        title: 'auto.t_1edbc0fd7b'.tr(),
        description: 'auto.t_a9fc68419e'.tr(),
        icon: Icons.language,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_bee2a1ff6a'.tr(),
            description: 'auto.t_bd35e2ae5d'.tr(),
            icon: Icons.web,
          ),
          _DetailPoint(
            title: 'auto.t_c62e7e8997'.tr(),
            description: 'auto.t_afd7c55790'.tr(),
            icon: Icons.business_center,
          ),
          _DetailPoint(
            title: 'auto.t_770010bb0c'.tr(),
            description: 'auto.t_8fb142b9d0'.tr(),
            icon: Icons.phone_iphone,
            accentGold: true,
          ),
        ],
      ),
      'mobile-app': _ServiceDetail(
        title: 'auto.t_75b4366b3d'.tr(),
        description: 'auto.t_5db77d126a'.tr(),
        icon: Icons.phone_iphone,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_294b49ddbc'.tr(),
            description: 'auto.t_3992a992ce'.tr(),
            icon: Icons.dashboard_customize,
          ),
          _DetailPoint(
            title: 'auto.t_7b4c4622db'.tr(),
            description: 'auto.t_8e95cb0723'.tr(),
            icon: Icons.devices,
            accentGold: true,
          ),
          _DetailPoint(
            title: 'auto.t_5bdb3f8dfd'.tr(),
            description: 'auto.t_480283bf2d'.tr(),
            icon: Icons.support_agent,
          ),
        ],
      ),
      'video': _ServiceDetail(
        title: 'auto.t_c9b57e62ee'.tr(),
        description: 'auto.t_99d3c11a19'.tr(),
        icon: Icons.play_circle,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_d0f5719db6'.tr(),
            description: 'auto.t_d82a5c1d45'.tr(),
            icon: Icons.movie,
          ),
          _DetailPoint(
            title: 'auto.t_0d15adbecc'.tr(),
            description: 'auto.t_eeccc05b35'.tr(),
            icon: Icons.smart_display,
            accentGold: true,
          ),
          _DetailPoint(
            title: 'auto.t_f63905e988'.tr(),
            description: 'auto.t_f2fcdcb3ba'.tr(),
            icon: Icons.animation,
          ),
        ],
      ),
      'seo': _ServiceDetail(
        title: 'auto.t_943b26af5b'.tr(),
        description: 'auto.t_8c020b582c'.tr(),
        icon: Icons.manage_search,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_f82b26c88c'.tr(),
            description: 'auto.t_c28ca048ad'.tr(),
            icon: Icons.key,
          ),
          _DetailPoint(
            title: 'auto.t_e892ef7090'.tr(),
            description: 'auto.t_60ca8af2da'.tr(),
            icon: Icons.article,
          ),
          _DetailPoint(
            title: 'auto.t_a171df3e97'.tr(),
            description: 'auto.t_a37af36351'.tr(),
            icon: Icons.speed,
            accentGold: true,
          ),
        ],
      ),
      'moderator': _ServiceDetail(
        title: 'auto.t_c7351ab69b'.tr(),
        description: 'auto.t_68540d252d'.tr(),
        icon: Icons.support_agent,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_606f2f5b1a'.tr(),
            description: 'auto.t_18dda6f40a'.tr(),
            icon: Icons.mark_chat_read,
          ),
          _DetailPoint(
            title: 'auto.t_a76c295c46'.tr(),
            description: 'auto.t_7289bcc8cd'.tr(),
            icon: Icons.people_alt,
            accentGold: true,
          ),
          _DetailPoint(
            title: 'auto.t_624ace75f5'.tr(),
            description: 'auto.t_ba153a930b'.tr(),
            icon: Icons.fact_check,
          ),
        ],
      ),
      'brand-plan': _ServiceDetail(
        title: 'auto.t_192a0586bb'.tr(),
        description: 'auto.t_c5a4895378'.tr(),
        icon: Icons.diamond,
        showEditPolicy: true,
        points: [
          _DetailPoint(
            title: 'auto.t_0ed3b0ddb2'.tr(),
            description: 'auto.t_2ac18ab812'.tr(),
            icon: Icons.explore,
          ),
          _DetailPoint(
            title: 'auto.t_ed3d29d919'.tr(),
            description: 'auto.t_7c3c3371da'.tr(),
            icon: Icons.record_voice_over,
          ),
          _DetailPoint(
            title: 'auto.t_58c3ee1b8a'.tr(),
            description: 'auto.t_a6e3b52e67'.tr(),
            icon: Icons.map,
            accentGold: true,
          ),
        ],
      ),
    };

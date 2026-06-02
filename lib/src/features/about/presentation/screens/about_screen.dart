// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math' as math;

import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  bool get _isArabic => context.locale.languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 9),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Color(0xFF070511),
        body: SafeArea(
          top: false,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: CustomPaint(
                      painter: _AboutBackgroundPainter(
                        progress: _floatController.value,
                      ),
                      child: child!,
                    ),
                  ),
                ],
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 34.h),
              child: Column(
                children: [
                  _HeroSection(progress: _floatController),
                  SizedBox(height: 28.h),
                  _PortfolioSection(),
                  SizedBox(height: 28.h),
                  _StorySection(),
                  SizedBox(height: 28.h),
                  _CeoSection(progress: _floatController),
                  SizedBox(height: 28.h),
                  _ContractSection(),
                  SizedBox(height: 28.h),
                  _ValuesSection(),
                  SizedBox(height: 28.h),
                  _WhyChooseSection(),
                  SizedBox(height: 28.h),
                  _GrowthPartnerBanner(),
                  SizedBox(height: 28.h),
                  _CeoProfileSection(),
                  SizedBox(height: 28.h),
                  _TeamSection(),
                  SizedBox(height: 28.h),
                  _CtaSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isWide = context.width >= 720;

    if (isWide) {
      return _DesktopAboutHero(progress: progress)
          .animate()
          .fadeIn(duration: Duration(milliseconds: 520))
          .slideY(
            begin: 0.08,
            duration: Duration(milliseconds: 520),
          );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1C1930),
            Color(0xFF17152A),
            Color(0xFF281354),
          ],
        ),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 34.r,
            offset: Offset(0.w, 18.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _HeroCardPainter())),
          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 22.h),
            child: Column(
              children: [
                _Badge(
                    icon: Icons.groups_rounded,
                    label: 'auto.t_629d28fb52'.tr()),
                SizedBox(height: 20.h),
                Text.rich(
                  TextSpan(
                    text: 'auto.t_872cef8970'.tr(),
                    children: [
                      TextSpan(
                        text: 'auto.t_2407ba25b1'.tr(),
                        style: TextStyle(color: colors.gold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                    height: 1.16,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'auto.t_5942a13c56'.tr(),
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colors.textMuted,
                    height: 1.75,
                  ),
                ),
                SizedBox(height: 24.h),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12.r,
                  crossAxisSpacing: 12.r,
                  childAspectRatio: 1.15,
                  children: [
                    _MobileHeroMetric(
                      icon: Icons.star_rounded,
                      value: '93%',
                      label: 'auto.t_a8500d6236'.tr(),
                    ),
                    _MobileHeroMetric(
                      icon: Icons.calendar_month_rounded,
                      value: '+12',
                      label: 'auto.t_07caf2cbc5'.tr(),
                    ),
                    _MobileHeroMetric(
                      icon: Icons.handshake_rounded,
                      value: '5,000+',
                      label: 'auto.t_6a6d13b7c7'.tr(),
                    ),
                    _MobileHeroMetric(
                      icon: Icons.work_rounded,
                      value: '400,000+',
                      label: 'auto.t_12b1d6581c'.tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: Duration(milliseconds: 520)).slideY(
          begin: 0.08,
          duration: Duration(milliseconds: 520),
        );
  }
}

class _DesktopAboutHero extends StatelessWidget {
  const _DesktopAboutHero({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28.w, 48.h, 28.w, 38.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF11101C), Color(0xFF151225), Color(0xFF0C0A14)],
        ),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.12)),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _HeroDesktopPainter())),
          Column(
            children: [
              _Badge(
                  icon: Icons.groups_rounded, label: 'auto.t_629d28fb52'.tr()),
              SizedBox(height: 20.h),
              Text.rich(
                TextSpan(
                  text: 'auto.t_dccb5014d7'.tr(),
                  children: [
                    TextSpan(
                      text: 'auto.t_2407ba25b1'.tr(),
                      style: TextStyle(color: colors.gold),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  color: colors.textMain,
                  fontWeight: FontWeight.w900,
                  height: 1.02,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'auto.t_5942a13c56'.tr(),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: colors.textMuted,
                  height: 1.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 42.h),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16.r,
                runSpacing: 16.r,
                children: [
                  _DesktopHeroMetric(
                    icon: Icons.work_rounded,
                    value: '400,000+',
                    label: 'auto.t_12b1d6581c'.tr(),
                  ),
                  _DesktopHeroMetric(
                    icon: Icons.handshake_rounded,
                    value: '5,000+',
                    label: 'auto.t_6a6d13b7c7'.tr(),
                  ),
                  _DesktopHeroMetric(
                    icon: Icons.calendar_month_rounded,
                    value: '+12',
                    label: 'auto.t_07caf2cbc5'.tr(),
                  ),
                  _DesktopHeroMetric(
                    icon: Icons.star_rounded,
                    value: '93%',
                    label: 'auto.t_a8500d6236'.tr(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesktopHeroMetric extends StatelessWidget {
  const _DesktopHeroMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: 170.w,
      height: 138.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0x40110E1B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colors.gold, size: 25.sp),
          SizedBox(height: 14.h),
          Text(
            value,
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: colors.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHeroMetric extends StatelessWidget {
  const _MobileHeroMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 10.r),
      decoration: BoxDecoration(
        color: Color(0x40110E1B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colors.gold, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return _PlainSection(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: _Badge(
              icon: Icons.business_center_rounded,
              label: 'auto.t_aafc8fcd10'.tr(),
            ),
          ),
          SizedBox(height: 18.h),
          _SectionTitle(
            title: 'auto.t_a11d973e7e'.tr(),
            highlight: 'auto.t_ee96ebdc3f'.tr(),
            centered: true,
          ),
          SizedBox(height: 14.h),
          _MutedText(
            'auto.t_a681047442'.tr(),
            centered: true,
          ),
          SizedBox(height: 24.h),
          _PortfolioShowcaseCard(),
          SizedBox(height: 18.h),
          _Checklist(items: [
            _CheckItem('auto.t_4c26d8c6bd'.tr(), Color(0xFFD4AF37)),
            _CheckItem('auto.t_8a9f9f49a0'.tr(), Color(0xFF68D391)),
            _CheckItem('auto.t_eb65c7506d'.tr(), Color(0xFF63B3ED)),
          ]),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: colors.bgCard.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: colors.gold.withValues(alpha: 0.14)),
            ),
            child: Row(
              children: [
                Expanded(
                    child: _MiniMetric(
                        value: '400K+', label: 'auto.t_12b1d6581c'.tr())),
                _VerticalDivider(),
                Expanded(
                    child: _MiniMetric(
                        value: '+12', label: 'auto.t_ddb0fad5c4'.tr())),
                _VerticalDivider(),
                Expanded(
                  child:
                      _MiniMetric(value: '49', label: 'auto.t_4f47c5d7ff'.tr()),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 90),
          duration: Duration(milliseconds: 520),
        )
        .slideY(
          begin: 0.08,
          duration: Duration(milliseconds: 520),
        );
  }
}

class _PortfolioShowcaseCard extends StatelessWidget {
  const _PortfolioShowcaseCard();

  static final Uri _previewUri = Uri.parse(
    'https://drive.google.com/file/d/1WjNShO_Fb3ZCVe5tPnvpuViNkjJ5VLCA/view?usp=drive_link',
  );
  static final Uri _downloadUri = Uri.parse(
    'https://etba3ly-dm.com/works/Portfolio_Etba3ly.pdf',
  );

  Future<void> _openPortfolio(BuildContext context) async {
    await _launchPortfolioUrl(context, _previewUri);
  }

  Future<void> _downloadPortfolio(BuildContext context) async {
    await _launchPortfolioUrl(context, _downloadUri);
  }

  Future<void> _launchPortfolioUrl(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      context.showErrorSnackBar('auto.t_994266fd86'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        color: Color(0xAA0B0914),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: colors.gold.withValues(alpha: 0.12),
            blurRadius: 34.r,
            offset: Offset(0.w, 18.h),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _openPortfolio(context),
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              height: 190.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: CustomPaint(painter: _PortfolioCoverPainter())),
                  Positioned(
                    top: 16.h,
                    right: 20.w,
                    child: Image.asset(AppAssets.logo, width: 122.w),
                  ),
                  Positioned(
                    left: 14.w,
                    top: 14.h,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2537),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.description_rounded,
                              color: colors.gold, size: 15.sp),
                          SizedBox(width: 5.w),
                          Text(
                            'auto.t_eb23bd0ff6'.tr(),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: colors.gold,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.h,
                    left: 0.w,
                    right: 0.w,
                    height: 60.h,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFC8AE87).withValues(alpha: 0.25),
                            Color(0xFFAA865A),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 22.h,
                    right: 22.w,
                    child: Text(
                      'Digital Marketing',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Color(0xFFB9915E),
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(color: Colors.white, blurRadius: 2.r),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Color(0x66110E1B),
              borderRadius: BorderRadius.circular(18.r),
              border:
                  Border.all(color: colors.borderColor.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.gold.withValues(alpha: 0.12),
                    border:
                        Border.all(color: colors.gold.withValues(alpha: 0.28)),
                  ),
                  child: Icon(Icons.shield_rounded,
                      color: colors.gold, size: 22.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auto.t_8d3c9f4792'.tr(),
                        style: context.textTheme.titleSmall?.copyWith(
                          color: colors.textMain,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'auto.t_550eb47812'.tr(),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: colors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Color(0x33FF4D4D),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Color(0x66FF4D4D)),
                  ),
                  child: Icon(Icons.picture_as_pdf_rounded,
                      color: Color(0xFFFF6B6B)),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          _PortfolioActionButton(
            filled: true,
            title: 'auto.t_f620535292'.tr(),
            subtitle: 'auto.t_1218e3b37d'.tr(),
            icon: Icons.visibility_rounded,
            onTap: () => _openPortfolio(context),
          ),
          SizedBox(height: 10.h),
          _PortfolioActionButton(
            title: 'auto.t_1ba8c2f9ba'.tr(),
            icon: Icons.download_rounded,
            onTap: () => _downloadPortfolio(context),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TinyTrust(
                  label: 'auto.t_5f5f468124'.tr(),
                  icon: Icons.flash_on_rounded),
              _TinyTrust(
                  label: 'auto.t_4ea25eef7a'.tr(), icon: Icons.lock_rounded),
              _TinyTrust(
                  label: 'auto.t_e0cc864c0f'.tr(), icon: Icons.refresh_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection();

  @override
  Widget build(BuildContext context) {
    return _PlainSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SectionTitle(
            title: 'auto.t_b445aa7f5a'.tr(),
            highlight: 'auto.t_634987483b'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          _MutedText(
            'auto.t_0952aae8e7'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          _Timeline(items: [
            _TimelineItem('2014', 'auto.t_6db098f663'.tr()),
            _TimelineItem('2017', 'auto.t_11c1be824a'.tr()),
            _TimelineItem('2020', 'auto.t_1192cf6f63'.tr()),
            _TimelineItem('auto.t_b76444a321'.tr(), 'auto.t_f3a6c65ac2'.tr()),
          ]),
          SizedBox(height: 22.h),
          _StoryMetaStats(),
          SizedBox(height: 18.h),
          _QuoteCard(),
        ],
      ),
    );
  }
}

class _ValuesSection extends StatelessWidget {
  const _ValuesSection();

  @override
  Widget build(BuildContext context) {
    return _PlainSection(
      child: Column(
        children: [
          _Badge(icon: Icons.diamond_rounded, label: 'auto.t_b562a738ca'.tr()),
          SizedBox(height: 14.h),
          _SectionTitle(
            title: 'auto.t_2854acd0e9'.tr(),
            highlight: 'auto.t_2617826e9c'.tr(),
            centered: true,
          ),
          SizedBox(height: 10.h),
          _MutedText(
            'auto.t_b031255ba6'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10.r,
            crossAxisSpacing: 10.r,
            childAspectRatio: 0.82,
            children: [
              _ValueCard(
                icon: Icons.lightbulb_rounded,
                color: Color(0xFFD4AF37),
                title: 'auto.t_d6b172e114'.tr(),
                desc: 'auto.t_935c389ce7'.tr(),
              ),
              _ValueCard(
                icon: Icons.visibility_rounded,
                color: Color(0xFF63B3ED),
                title: 'auto.t_6cdd38ff07'.tr(),
                desc: 'auto.t_f757bd831b'.tr(),
              ),
              _ValueCard(
                icon: Icons.trending_up_rounded,
                color: Color(0xFF68D391),
                title: 'auto.t_2d00bef233'.tr(),
                desc: 'auto.t_b658e0aef8'.tr(),
              ),
              _ValueCard(
                icon: Icons.handshake_rounded,
                color: Color(0xFFF6AD55),
                title: 'auto.t_2cd92ecc4c'.tr(),
                desc: 'auto.t_cc9c1b113f'.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhyChooseSection extends StatelessWidget {
  const _WhyChooseSection();

  @override
  Widget build(BuildContext context) {
    return _GlowPanel(
      child: Column(
        children: [
          _Badge(icon: Icons.star_rounded, label: 'auto.t_f4df70c059'.tr()),
          SizedBox(height: 14.h),
          _SectionTitle(
            title: 'auto.t_81d5c04f03'.tr(),
            highlight: 'auto.t_82b1b427db'.tr(),
            centered: true,
          ),
          SizedBox(height: 10.h),
          _MutedText(
            'auto.t_704292d95e'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          _WhyCard(
            icon: Icons.rocket_launch_rounded,
            color: Color(0xFFD4AF37),
            number: '+400,000',
            title: 'auto.t_12b1d6581c'.tr(),
            desc: 'auto.t_55e9d4fd28'.tr(),
            progress: 0.92,
          ),
          SizedBox(height: 12.h),
          _WhyCard(
            icon: Icons.show_chart_rounded,
            color: Color(0xFF68D391),
            number: '3.8x',
            title: 'auto.t_c25a3cf5f7'.tr(),
            desc: 'auto.t_6585f8612c'.tr(),
            progress: 0.85,
          ),
          SizedBox(height: 12.h),
          _WhyCard(
            icon: Icons.schedule_rounded,
            color: Color(0xFF63B3ED),
            number: '24h',
            title: 'auto.t_1cf34c10bd'.tr(),
            desc: 'auto.t_d0539d01f1'.tr(),
            progress: 1,
          ),
          SizedBox(height: 18.h),
          _PartnerBanner(),
        ],
      ),
    );
  }
}

class _CeoSection extends StatelessWidget {
  const _CeoSection({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return _PlainSection(
      child: Column(
        children: [
          _CeoVideoWidget(),
          SizedBox(height: 24.h),
          _RoleLabel(label: 'auto.t_99f47461d4'.tr()),
          SizedBox(height: 12.h),
          Text.rich(
            TextSpan(
              text: 'auto.t_2db47720a7'.tr(),
              children: [
                TextSpan(
                  text: 'auto.t_85830ec4f3'.tr(),
                  style: TextStyle(color: colors.gold),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          SizedBox(height: 14.h),
          _MutedText(
            'auto.t_3a1fe378de'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          _GlowPanel(
            child: _Checklist(items: [
              _CheckItem('auto.t_dbe41ec88c'.tr(), Color(0xFFD4AF37)),
              _CheckItem('auto.t_955599c7fe'.tr(), Color(0xFF68D391)),
              _CheckItem('auto.t_279d3a38ef'.tr(), Color(0xFF63B3ED)),
            ]),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: colors.bgCard.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colors.gold.withValues(alpha: 0.24)),
            ),
            child: Column(
              children: [
                Text(
                  'auto.t_1d64625ba1'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'auto.t_533951e10c'.tr(),
                  style: context.textTheme.labelMedium?.copyWith(
                    color: colors.gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamSection extends StatelessWidget {
  const _TeamSection();

  @override
  Widget build(BuildContext context) {
    return _PlainSection(
      child: Column(
        children: [
          _Badge(icon: Icons.groups_2_rounded, label: 'auto.t_3f01048980'.tr()),
          SizedBox(height: 14.h),
          _SectionTitle(
            title: 'auto.t_c6acefe39a'.tr(),
            highlight: 'auto.t_a13b57d943'.tr(),
            centered: true,
          ),
          SizedBox(height: 10.h),
          _MutedText(
            'auto.t_026f598165'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12.r,
            crossAxisSpacing: 12.r,
            childAspectRatio: 0.78,
            children: [
              _TeamCard(
                name: 'auto.t_c7eca3246d'.tr(),
                role: 'Account Manager',
                image: 'yasmine',
              ),
              _TeamCard(
                name: 'auto.t_f3b9fa8833'.tr(),
                role: 'Team Leader & Video Editor',
                image: 'mahmoud',
              ),
              _TeamCard(
                name: 'auto.t_6f5f22e2d3'.tr(),
                role: 'Operations Coordinator',
                image: 'hagar',
              ),
              _TeamCard(
                name: 'auto.t_89a5dde564'.tr(),
                role: 'Web Developer',
                image: 'ahmed',
              ),
              _TeamCard(
                name: 'auto.t_ca0fa79930'.tr(),
                role: 'Mobile Developer',
                image: 'salma',
              ),
              _TeamCard(
                name: 'auto.t_669c3a1d44'.tr(),
                role: 'Moderator',
                image: 'shahd',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContractSection extends StatelessWidget {
  const _ContractSection();

  static final Uri _contractDownloadUri = Uri.parse(
    'https://etba3ly-dm.com/Company%20Contract/Etbaly_Company_Marketing_Agreement.pdf',
  );

  Future<void> _downloadContract(BuildContext context) async {
    final ok = await launchUrl(
      _contractDownloadUri,
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      context.showErrorSnackBar('auto.t_50d30ecfb1'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return _PlainSection(
      child: Column(
        children: [
          _Badge(
              icon: Icons.file_copy_rounded, label: 'auto.t_f90a123d29'.tr()),
          SizedBox(height: 14.h),
          _SectionTitle(
            title: 'auto.t_f76c858efd'.tr(),
            highlight: 'auto.t_c1c6feb8a7'.tr(),
            centered: true,
          ),
          SizedBox(height: 10.h),
          _MutedText(
            'auto.t_873e38d33a'.tr(),
            centered: true,
          ),
          SizedBox(height: 22.h),
          _ContractDocumentPreview(),
          SizedBox(height: 22.h),
          _GlowPanel(
            child: Column(
              children: [
                _Badge(
                    icon: Icons.shield_rounded,
                    label: 'auto.t_8105b8969a'.tr()),
                SizedBox(height: 14.h),
                Text(
                  'auto.t_bd3b897a4d'.tr(),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10.h),
                _MutedText(
                  'auto.t_d7c397ce17'.tr(),
                  centered: true,
                ),
                SizedBox(height: 16.h),
                _Checklist(items: [
                  _CheckItem('auto.t_40682890ce'.tr(), Color(0xFFD4AF37)),
                  _CheckItem('auto.t_b8b9558fc1'.tr(), Color(0xFF68D391)),
                  _CheckItem('auto.t_da15c08d6b'.tr(), Color(0xFF63B3ED)),
                  _CheckItem('auto.t_dfbe69d96d'.tr(), Color(0xFFF6AD55)),
                ]),
                SizedBox(height: 14.h),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _downloadContract(context),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.all(13.r),
                      decoration: BoxDecoration(
                        color: colors.gold.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                            color: colors.gold.withValues(alpha: 0.36)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download_rounded,
                              color: colors.gold, size: 18.sp),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'auto.t_b11d86790f'.tr(),
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: colors.textMain,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'auto.t_f98b05b709'.tr(),
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: colors.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: colors.gold,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(Icons.picture_as_pdf_rounded,
                                color: Colors.black, size: 19.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractDocumentPreview extends StatefulWidget {
  const _ContractDocumentPreview();

  @override
  State<_ContractDocumentPreview> createState() =>
      _ContractDocumentPreviewState();
}

class _ContractDocumentPreviewState extends State<_ContractDocumentPreview> {
  late final PageController _pageController;
  int _pageIndex = 0;

  static const _pages = [
    AppAssets.contractPage1,
    AppAssets.contractPage2,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    final next = index.clamp(0, _pages.length - 1);
    _pageController.animateToPage(
      next,
      duration: Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() => _goTo((_pageIndex + 1) % _pages.length);

  void _previous() => _goTo((_pageIndex - 1 + _pages.length) % _pages.length);

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 360.w),
          height: 506.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 32.r,
                offset: Offset(0.w, 18.h),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _pageIndex = index),
            itemBuilder: (context, index) {
              return Image.asset(
                _pages[index],
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              );
            },
          ),
        ),
        Positioned(
          left: -18.w,
          top: 234.h,
          child: _SlideArrow(
            icon: Icons.chevron_right_rounded,
            onTap: _previous,
          ),
        ),
        Positioned(
          right: -18.w,
          top: 234.h,
          child: _SlideArrow(
            icon: Icons.chevron_left_rounded,
            onTap: _next,
          ),
        ),
        Positioned(
          top: 10.h,
          left: 10.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Color(0xFF111018),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: colors.gold.withValues(alpha: 0.45)),
            ),
            child: Text(
              '${_pageIndex + 1} / ${_pages.length}',
              style: context.textTheme.labelSmall?.copyWith(
                color: colors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideArrow extends StatelessWidget {
  const _SlideArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: CircleBorder(),
        child: Container(
          width: 42.w,
          height: 42.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF101018),
            border: Border.all(color: colors.gold.withValues(alpha: 0.48)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 12.r,
                offset: Offset(0.w, 5.h),
              ),
            ],
          ),
          child: Icon(icon, color: colors.gold, size: 24.sp),
        ),
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return _GlassSection(
      padding: EdgeInsets.all(22.r),
      child: Column(
        children: [
          _Badge(
              icon: Icons.rocket_launch_rounded,
              label: 'auto.t_629d28fb52'.tr()),
          SizedBox(height: 14.h),
          Text(
            'auto.t_51c7eea713'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10.h),
          _MutedText(
            'auto.t_c5425f0ee3'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          Material(
            color: colors.gold,
            borderRadius: BorderRadius.circular(999.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(999.r),
              onTap: () => context.go(AppRoutes.contact),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 13.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, color: Colors.black),
                    SizedBox(width: 8.w),
                    Text(
                      'auto.t_daf7ba6d71'.tr(),
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
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

class _GrowthPartnerBanner extends StatelessWidget {
  const _GrowthPartnerBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Color(0xFF221D18), Color(0xFF111018), Color(0xFF181323)],
        ),
        border: Border.all(color: colors.gold.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 28.r,
            offset: Offset(0.w, 14.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58.w,
                height: 58.h,
                decoration: BoxDecoration(
                  color: colors.gold,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.26),
                      blurRadius: 22.r,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 30.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'auto.t_9db3e3333a'.tr(),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'auto.t_3372e14588'.tr(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                  child: _MiniMetric(
                      value: '+12', label: 'auto.t_07caf2cbc5'.tr())),
              _VerticalDivider(),
              Expanded(
                  child: _MiniMetric(
                      value: '5,000+', label: 'auto.t_ad40b0e22c'.tr())),
              _VerticalDivider(),
              Expanded(
                  child: _MiniMetric(
                      value: '+15', label: 'auto.t_a1ceae33b8'.tr())),
              _VerticalDivider(),
              Expanded(
                  child:
                      _MiniMetric(value: '4', label: 'auto.t_ebccd17f9b'.tr())),
            ],
          ),
        ],
      ),
    );
  }
}

class _CeoProfileSection extends StatelessWidget {
  const _CeoProfileSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return _PlainSection(
      child: Column(
        children: [
          _RoleLabel(label: 'auto.t_aa406e4c94'.tr()),
          SizedBox(height: 14.h),
          _CeoPortraitCard(),
          SizedBox(height: 20.h),
          Text.rich(
            TextSpan(
              text: 'auto.t_b418443b8b'.tr(),
              children: [
                TextSpan(
                  text: 'auto.t_de70ae52e8'.tr(),
                  style: TextStyle(color: colors.gold),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          SizedBox(height: 14.h),
          _MutedText(
            'auto.t_51c39a8008'.tr(),
            centered: true,
          ),
          SizedBox(height: 18.h),
          _Checklist(items: [
            _CheckItem('auto.t_dbe41ec88c'.tr(), Color(0xFFD4AF37)),
            _CheckItem('auto.t_955599c7fe'.tr(), Color(0xFF68D391)),
            _CheckItem('auto.t_279d3a38ef'.tr(), Color(0xFF63B3ED)),
          ]),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: colors.bgCard.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: colors.gold.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                Expanded(
                    child: _MiniMetric(
                        value: '5K+', label: 'auto.t_317d1c1684'.tr())),
                _VerticalDivider(),
                Expanded(
                    child: _MiniMetric(
                        value: '93%', label: 'auto.t_52c33d066b'.tr())),
                _VerticalDivider(),
                Expanded(
                    child: _MiniMetric(
                        value: '4', label: 'auto.t_ebccd17f9b'.tr())),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'auto.t_32afe007d4'.tr(),
              style: context.textTheme.labelMedium?.copyWith(
                color: colors.gold.withValues(alpha: 0.8),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CeoPortraitCard extends StatelessWidget {
  const _CeoPortraitCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 260.w,
          height: 330.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: colors.gold.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: colors.gold.withValues(alpha: 0.12),
                blurRadius: 34.r,
                offset: Offset(0.w, 18.h),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            AppAssets.aboutCeo,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Positioned(
          top: 34.h,
          left: -18.w,
          child: _FloatingBadge(
              icon: Icons.work_rounded, label: 'auto.t_f85359e2a9'.tr()),
        ),
        Positioned(
          bottom: 28.h,
          right: -18.w,
          child: _FloatingBadge(
              icon: Icons.timeline_rounded, label: 'auto.t_ebf7a4b024'.tr()),
        ),
      ],
    );
  }
}

class _PortfolioActionButton extends StatelessWidget {
  const _PortfolioActionButton({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.filled = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: filled ? colors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: filled ? Colors.black : colors.gold,
                size: 18.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: filled ? Colors.black : colors.gold,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: filled
                              ? Colors.black.withValues(alpha: 0.58)
                              : colors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.black.withValues(alpha: 0.14)
                      : colors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(icon, color: filled ? Colors.white : colors.gold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyTrust extends StatelessWidget {
  const _TinyTrust({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: colors.gold.withValues(alpha: 0.72), size: 13.sp),
        SizedBox(width: 4.w),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w800,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

class _GlassSection extends StatelessWidget {
  const _GlassSection({required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colors.bgCard.withValues(alpha: 0.96),
            colors.bgSubtle.withValues(alpha: 0.82),
            colors.primaryDark.withValues(alpha: 0.22),
          ],
        ),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 32.r,
            offset: Offset(0.w, 16.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GlowPanel extends StatelessWidget {
  const _GlowPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: colors.bgCard.withValues(alpha: 0.88),
        border: Border.all(color: colors.gold.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: colors.gold.withValues(alpha: 0.08),
            blurRadius: 34.r,
            offset: Offset(0.w, 14.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PlainSection extends StatelessWidget {
  const _PlainSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: child);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: colors.gold.withValues(alpha: 0.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: colors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.highlight,
    this.centered = false,
  });

  final String title;
  final String highlight;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Text.rich(
      TextSpan(
        text: '$title ',
        children: [
          TextSpan(text: highlight, style: TextStyle(color: colors.gold)),
        ],
      ),
      textAlign: centered ? TextAlign.center : TextAlign.start,
      style: context.textTheme.titleLarge?.copyWith(
        color: colors.textMain,
        fontWeight: FontWeight.w900,
        height: 1.18,
      ),
    );
  }
}

class _MutedText extends StatelessWidget {
  const _MutedText(this.text, {this.centered = false});

  final String text;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: centered ? TextAlign.center : TextAlign.start,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.etbalyColors.textMuted,
        height: 1.68,
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xDD0B0912),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(color: Color(0x55000000), blurRadius: 18.r),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 15.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Checklist extends StatelessWidget {
  const _Checklist({required this.items});

  final List<_CheckItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withValues(alpha: 0.38),
                          blurRadius: 10.r,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      item.label,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.etbalyColors.textMuted,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CheckItem {
  _CheckItem(this.label, this.color);

  final String label;
  final Color color;
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            color: colors.gold,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 42.h,
      color: context.etbalyColors.gold.withValues(alpha: 0.18),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.items});

  final List<_TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 430.w),
        child: Stack(
          children: [
            Positioned(
              top: 7.h,
              bottom: 7.h,
              right: 7.w,
              child: Container(
                width: 2.w,
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.26),
                      blurRadius: 12.r,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  _TimelineRow(item: items[i], index: i),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem {
  _TimelineItem(this.year, this.label);

  final String year;
  final String label;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.index});

  final _TimelineItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final dotColor = switch (index) {
      1 => Color(0xFF63B3ED),
      2 => Color(0xFF68D391),
      _ => colors.gold,
    };
    final isActive = item.year == 'auto.t_b76444a321'.tr();
    final bottomPadding = index == 3 ? 0.h : 20.h;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                item.label,
                textAlign: TextAlign.right,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.textMuted,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 46.w,
            child: Text(
              item.year,
              textAlign: TextAlign.right,
              style: context.textTheme.labelLarge?.copyWith(
                color: colors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: isActive ? dotColor : Color(0xFF0B0914),
              shape: BoxShape.circle,
              border: Border.all(color: dotColor, width: 2.5.w),
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: isActive ? 0.48 : 0.18),
                  blurRadius: isActive ? 14 : 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryMetaStats extends StatelessWidget {
  const _StoryMetaStats();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 18.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.gold.withValues(alpha: 0.16)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StoryMetaItem(
              icon: Icons.calendar_month_rounded,
              label: 'auto.t_01e2eb192c'.tr(),
              value: '2014',
            ),
          ),
          Expanded(
            child: _StoryMetaItem(
              icon: Icons.location_on_rounded,
              label: 'auto.t_e149f9e84f'.tr(),
              value: 'auto.t_19c155b158'.tr(),
            ),
          ),
          Expanded(
            child: _StoryMetaItem(
              icon: Icons.groups_rounded,
              label: 'auto.t_59be02cd45'.tr(),
              value: 'auto.t_6c872d9623'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryMetaItem extends StatelessWidget {
  const _StoryMetaItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: colors.bgCard.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
          ),
          child: Icon(icon, color: colors.gold, size: 19.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 3.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: colors.textMain,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, color: colors.gold, size: 30.sp),
          SizedBox(height: 6.h),
          _MutedText(
            'auto.t_207f6b510a'.tr(),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: colors.gold.withValues(alpha: 0.28)),
                ),
                child:
                    Icon(Icons.person_rounded, color: colors.gold, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'auto.t_32afe007d4'.tr(),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: colors.textMain,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'auto.t_aa406e4c94'.tr(),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colors.gold,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.all(11.r),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.sp,
                        height: 1.12,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      desc,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                        height: 1.25,
                        fontSize: 11.6.sp,
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

class _WhyCard extends StatelessWidget {
  const _WhyCard({
    required this.icon,
    required this.color,
    required this.number,
    required this.title,
    required this.desc,
    required this.progress,
  });

  final IconData icon;
  final Color color;
  final String number;
  final String title;
  final String desc;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Color(0x66110E1B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 26.sp),
              Spacer(),
              Text(
                number,
                style: context.textTheme.titleLarge?.copyWith(
                  color: colors.textMain,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            desc,
            style: context.textTheme.bodySmall?.copyWith(
              color: colors.textMuted,
              height: 1.45,
            ),
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5.h,
              backgroundColor: colors.borderColor.withValues(alpha: 0.28),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerBanner extends StatelessWidget {
  const _PartnerBanner();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          colors: [
            colors.gold.withValues(alpha: 0.16),
            colors.primary.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: colors.gold.withValues(alpha: 0.26)),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events_rounded, color: colors.gold, size: 30.sp),
          SizedBox(height: 10.h),
          Text(
            'auto.t_9db3e3333a'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          _MutedText(
            'auto.t_f8c00fd952'.tr(),
            centered: true,
          ),
        ],
      ),
    );
  }
}

class _RoleLabel extends StatelessWidget {
  const _RoleLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: colors.gold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: colors.gold.withValues(alpha: 0.5), blurRadius: 12.r),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: colors.gold,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.name,
    required this.role,
    required this.image,
  });

  final String name;
  final String role;
  final String image;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.all(11.r),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.38)),
      ),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.gold.withValues(alpha: 0.24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              AppAssets.teamMember(image),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SizedBox(height: 9.h),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            role,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.gold,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
              height: 2,
              width: 38.w,
              color: colors.gold.withValues(alpha: 0.55)),
        ],
      ),
    );
  }
}

class _PortfolioCoverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEFE2D0), Color(0xFFF9F5ED), Color(0xFFE1C39D)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final framePaint = Paint()
      ..color = Color(0xFFB99262).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18, 20, 74, 88),
        Radius.circular(2.r),
      ),
      framePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - 92, 20, 74, 88),
        Radius.circular(2.r),
      ),
      framePaint,
    );

    final artPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFFE8D4BE), Color(0xFFB6C4C1), Color(0xFFD6B58F)],
      ).createShader(Rect.fromLTWH(22, 24, 66, 80));
    canvas.drawRect(Rect.fromLTWH(22, 24, 66, 80), artPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 88, 24, 66, 80), artPaint);

    final floorPaint = Paint()..color = Color(0xFFB08A60);
    for (double y = size.height - 56; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 5), floorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Color(0x11745CBA)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 54) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 54) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final purpleBand = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF321069).withValues(alpha: 0.08),
          Color(0xFF321069).withValues(alpha: 0.42),
          Color(0xFF271052).withValues(alpha: 0.68),
        ],
      ).createShader(Offset.zero & size);
    final band = Path()
      ..moveTo(0, size.height * 0.64)
      ..lineTo(size.width * 0.58, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(band, purpleBand);

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFFD4AF37).withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.72),
          radius: 145,
        ),
      );
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.72), 145, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroDesktopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Color(0x10745CBA)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 72) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 72) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFFD4AF37).withValues(alpha: 0.16),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.16),
          radius: 250,
        ),
      );
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.16), 250, glow);

    final linePaint = Paint()
      ..color = Color(0x557D5DFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawLine(
      Offset(size.width * 0.04, size.height * 0.1),
      Offset(size.width * 0.18, 0),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.86, 0),
      Offset(size.width, size.height * 0.15),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, size.height),
      Offset(size.width, size.height * 0.74),
      linePaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.82),
      Offset(size.width * 0.18, size.height),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── CEO Video Player ─────────────────────────────────────────────────────────

class _CeoVideoWidget extends StatefulWidget {
  const _CeoVideoWidget();

  @override
  State<_CeoVideoWidget> createState() => _CeoVideoWidgetState();
}

class _CeoVideoWidgetState extends State<_CeoVideoWidget> {
  late final VideoPlayerController _ctrl;
  bool _showOverlay = true;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.asset(AppAssets.aboutVideo)
      ..initialize().then((_) {
        if (mounted) setState(() {});
      })
      ..addListener(_handleVideoState);
  }

  @override
  void dispose() {
    _ctrl
      ..removeListener(_handleVideoState)
      ..dispose();
    super.dispose();
  }

  void _handleVideoState() {
    if (!mounted || !_ctrl.value.isInitialized) return;
    final value = _ctrl.value;
    if (value.position >= value.duration && value.duration > Duration.zero) {
      setState(() => _showOverlay = true);
    }
  }

  Future<void> _onTap() async {
    if (!_ctrl.value.isInitialized) return;

    if (_ctrl.value.isPlaying) {
      await _ctrl.pause();
      if (mounted) setState(() => _showOverlay = true);
      return;
    }

    if (_ctrl.value.position >= _ctrl.value.duration) {
      await _ctrl.seekTo(Duration.zero);
    }
    await _ctrl.play();
    if (mounted) setState(() => _showOverlay = false);
  }

  Future<void> _toggleMute() async {
    if (!_ctrl.value.isInitialized) return;
    final muted = !_isMuted;
    await _ctrl.setVolume(muted ? 0 : 1);
    if (mounted) setState(() => _isMuted = muted);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isReady = _ctrl.value.isInitialized;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
              boxShadow: [
                BoxShadow(
                  color: colors.gold.withValues(alpha: 0.08),
                  blurRadius: 28.r,
                  offset: Offset(0.w, 12.h),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 0.86,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                      child: CustomPaint(painter: _CeoVideoPainter())),
                  if (isReady)
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _ctrl.value.size.width,
                        height: _ctrl.value.size.height,
                        child: VideoPlayer(_ctrl),
                      ),
                    )
                  else
                    Image.asset(
                      AppAssets.aboutVideoPoster,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.18),
                            Colors.black.withValues(alpha: 0.56),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_showOverlay) _VideoPlayOverlay(isReady: isReady),
                  Positioned(
                    bottom: 0.h,
                    left: 0.w,
                    right: 0.w,
                    child: _VideoBar(
                      ctrl: _ctrl,
                      onPlayPause: _onTap,
                      onToggleMute: _toggleMute,
                      fmt: _fmt,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _VideoBadge(
                icon: Icons.movie_creation_rounded,
                label: 'auto.t_445ae6072e'.tr(),
              ),
              SizedBox(width: 8.w),
              _VideoBadge(
                icon: Icons.access_time_rounded,
                label: isReady ? _fmt(_ctrl.value.duration) : '1:15',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoPlayOverlay extends StatelessWidget {
  const _VideoPlayOverlay({required this.isReady});

  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Center(
      child: Transform.translate(
        offset: Offset(0.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62.w,
              height: 62.h,
              decoration: BoxDecoration(
                color: colors.gold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.gold.withValues(alpha: 0.35),
                    blurRadius: 24.r,
                  ),
                ],
              ),
              child: Icon(
                isReady ? Icons.play_arrow_rounded : Icons.hourglass_top,
                color: Colors.white,
                size: isReady ? 38 : 28,
              ),
            ),
            SizedBox(height: 36.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'auto.t_3a51a7bc4d'.tr(),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 10.r,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 9.w),
                Container(
                  width: 9.w,
                  height: 9.h,
                  decoration: BoxDecoration(
                    color: colors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoBar extends StatelessWidget {
  const _VideoBar({
    required this.ctrl,
    required this.onPlayPause,
    required this.onToggleMute,
    required this.fmt,
  });

  final VideoPlayerController ctrl;
  final VoidCallback onPlayPause;
  final VoidCallback onToggleMute;
  final String Function(Duration) fmt;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xDD000000), Colors.transparent],
        ),
      ),
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: ctrl,
        builder: (context, value, _) {
          final pos = value.position;
          final dur = value.duration;
          final frac = dur.inMilliseconds > 0
              ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
              : 0.0;

          return Row(
            children: [
              GestureDetector(
                onTap: onPlayPause,
                child: Icon(
                  value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: SliderComponentShape.noOverlay,
                    activeTrackColor: colors.gold,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: colors.gold,
                  ),
                  child: Slider(
                    value: frac,
                    onChanged: dur == Duration.zero
                        ? null
                        : (v) => ctrl.seekTo(dur * v),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '${fmt(pos)} / ${fmt(dur)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onToggleMute,
                child: Icon(
                  value.volume > 0
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VideoBadge extends StatelessWidget {
  const _VideoBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 13.sp),
          SizedBox(width: 5.w),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CeoVideoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0E0A16), Color(0xFF21123B), Color(0xFF080611)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFFD4AF37).withValues(alpha: 0.16),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.68, size.height * 0.22),
          radius: size.width * 0.72,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.68, size.height * 0.22),
      size.width * 0.72,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────

class _AboutBackgroundPainter extends CustomPainter {
  _AboutBackgroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF070511), Color(0xFF0F0E18), Color(0xFF080613)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final gridPaint = Paint()
      ..color = Color(0x12D4AF37)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 58) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    _drawOrb(
      canvas,
      center: Offset(
        size.width * 0.5 + math.sin(progress * math.pi * 2) * 18,
        80 + math.cos(progress * math.pi * 2) * 16,
      ),
      radius: 260,
      color: Color(0x20D4AF37),
    );
    _drawOrb(
      canvas,
      center: Offset(size.width + 40, size.height * 0.28),
      radius: 210,
      color: Color(0x1263B3ED),
    );
    _drawOrb(
      canvas,
      center: Offset(-20, size.height * 0.62),
      radius: 190,
      color: Color(0x1068D391),
    );
  }

  void _drawOrb(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AboutBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

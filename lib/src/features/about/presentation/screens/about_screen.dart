// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math' as math;

import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
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
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF070511),
        body: SafeArea(
          top: false,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
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
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 34),
              child: Column(
                children: [
                  _HeroSection(progress: _floatController),
                  const SizedBox(height: 28),
                  const _PortfolioSection(),
                  const SizedBox(height: 28),
                  const _StorySection(),
                  const SizedBox(height: 28),
                  _CeoSection(progress: _floatController),
                  const SizedBox(height: 28),
                  const _ContractSection(),
                  const SizedBox(height: 28),
                  const _ValuesSection(),
                  const SizedBox(height: 28),
                  const _WhyChooseSection(),
                  const SizedBox(height: 28),
                  const _GrowthPartnerBanner(),
                  const SizedBox(height: 28),
                  const _CeoProfileSection(),
                  const SizedBox(height: 28),
                  const _TeamSection(),
                  const SizedBox(height: 28),
                  const _CtaSection(),
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
          .fadeIn(duration: const Duration(milliseconds: 520))
          .slideY(
            begin: 0.08,
            duration: const Duration(milliseconds: 520),
          );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1C1930),
            Color(0xFF17152A),
            Color(0xFF281354),
          ],
        ),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.18)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 34,
            offset: Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _HeroCardPainter())),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
            child: Column(
              children: [
                _Badge(icon: Icons.groups_rounded, label: 'من نحن'),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'اطبعلي\n',
                    children: [
                      TextSpan(
                        text: 'خبرة أكثر من 12 عام',
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
                const SizedBox(height: 16),
                Text(
                  'وكالة تسويق رقمي متكاملة تؤمن بأن كل علامة تجارية تستحق حضورًا رقميًا استثنائيًا يعكس قيمتها الحقيقية',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colors.textMuted,
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: const [
                    _MobileHeroMetric(
                      icon: Icons.star_rounded,
                      value: '93%',
                      label: 'معدل رضا العملاء',
                    ),
                    _MobileHeroMetric(
                      icon: Icons.calendar_month_rounded,
                      value: '+12',
                      label: 'سنوات خبرة',
                    ),
                    _MobileHeroMetric(
                      icon: Icons.handshake_rounded,
                      value: '5,000+',
                      label: 'عميل راضي',
                    ),
                    _MobileHeroMetric(
                      icon: Icons.work_rounded,
                      value: '400,000+',
                      label: 'مشروع منجز',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 520)).slideY(
          begin: 0.08,
          duration: const Duration(milliseconds: 520),
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
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 38),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
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
              _Badge(icon: Icons.groups_rounded, label: 'من نحن'),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'في\nاطبعلي\n',
                  children: [
                    TextSpan(
                      text: 'خبرة أكثر من 12 عام',
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
              const SizedBox(height: 18),
              Text(
                'وكالة تسويق رقمي متكاملة تؤمن بأن كل علامة تجارية تستحق حضورًا رقميًا استثنائيًا يعكس قيمتها الحقيقية',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: colors.textMuted,
                  height: 1.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 42),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: const [
                  _DesktopHeroMetric(
                    icon: Icons.work_rounded,
                    value: '400,000+',
                    label: 'مشروع منجز',
                  ),
                  _DesktopHeroMetric(
                    icon: Icons.handshake_rounded,
                    value: '5,000+',
                    label: 'عميل راضي',
                  ),
                  _DesktopHeroMetric(
                    icon: Icons.calendar_month_rounded,
                    value: '+12',
                    label: 'سنوات خبرة',
                  ),
                  _DesktopHeroMetric(
                    icon: Icons.star_rounded,
                    value: '93%',
                    label: 'معدل رضا العملاء',
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
      width: 170,
      height: 138,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x40110E1B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colors.gold, size: 25),
          const SizedBox(height: 14),
          Text(
            value,
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x40110E1B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colors.gold, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
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
              label: 'بورتفوليو الأعمال',
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'أعمالنا تتحدث',
            highlight: 'عن نفسها',
            centered: true,
          ),
          const SizedBox(height: 14),
          _MutedText(
            'اكتشف مجموعة مختارة من أبرز مشاريعنا عبر مختلف القطاعات — من الهوية البصرية إلى حملات الأداء الرقمي. كل صفحة تحكي قصة نجاح حقيقية.',
            centered: true,
          ),
          const SizedBox(height: 24),
          _PortfolioShowcaseCard(),
          const SizedBox(height: 18),
          const _Checklist(items: [
            _CheckItem('تصميم هوية بصرية متكاملة', Color(0xFFD4AF37)),
            _CheckItem('حملات أداء رقمية قابلة للقياس', Color(0xFF68D391)),
            _CheckItem('إنتاج محتوى إبداعي متعدد المنصات', Color(0xFF63B3ED)),
          ]),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: colors.bgCard.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.gold.withValues(alpha: 0.14)),
            ),
            child: const Row(
              children: [
                Expanded(
                    child: _MiniMetric(value: '400K+', label: 'مشروع منجز')),
                _VerticalDivider(),
                Expanded(child: _MiniMetric(value: '+12', label: 'سنة خبرة')),
                _VerticalDivider(),
                Expanded(
                  child: _MiniMetric(value: '49', label: 'صفحة في البورتفوليو'),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 90),
          duration: const Duration(milliseconds: 520),
        )
        .slideY(
          begin: 0.08,
          duration: const Duration(milliseconds: 520),
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
      context.showErrorSnackBar('تعذر فتح الرابط');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: const Color(0xAA0B0914),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: colors.gold.withValues(alpha: 0.12),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _openPortfolio(context),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: CustomPaint(painter: _PortfolioCoverPainter())),
                  Positioned(
                    top: 16,
                    right: 20,
                    child: Image.asset(AppAssets.logo, width: 122),
                  ),
                  Positioned(
                    left: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2537),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.description_rounded,
                              color: colors.gold, size: 15),
                          const SizedBox(width: 5),
                          Text(
                            '49 صفحة',
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
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFC8AE87).withValues(alpha: 0.25),
                            const Color(0xFFAA865A),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 22,
                    right: 22,
                    child: Text(
                      'Digital Marketing',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFB9915E),
                        fontWeight: FontWeight.w800,
                        shadows: const [
                          Shadow(color: Colors.white, blurRadius: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0x66110E1B),
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: colors.borderColor.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.gold.withValues(alpha: 0.12),
                    border:
                        Border.all(color: colors.gold.withValues(alpha: 0.28)),
                  ),
                  child:
                      Icon(Icons.shield_rounded, color: colors.gold, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'بورتفوليو اطبعلي الشامل',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: colors.textMain,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '49 صفحة PDF • قابل للطباعة',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: colors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0x33FF4D4D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x66FF4D4D)),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded,
                      color: Color(0xFFFF6B6B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _PortfolioActionButton(
            filled: true,
            title: 'معاينة البورتفوليو',
            subtitle: 'معاينة عبر Google Drive',
            icon: Icons.visibility_rounded,
            onTap: () => _openPortfolio(context),
          ),
          const SizedBox(height: 10),
          _PortfolioActionButton(
            title: 'تحميل البورتفوليو PDF',
            icon: Icons.download_rounded,
            onTap: () => _downloadPortfolio(context),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TinyTrust(label: 'تحميل فوري', icon: Icons.flash_on_rounded),
              _TinyTrust(label: 'آمن 100%', icon: Icons.lock_rounded),
              _TinyTrust(label: 'محدث 2025', icon: Icons.refresh_rounded),
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
            title: 'من فكرة إلى',
            highlight: 'وكالة رائدة',
            centered: true,
          ),
          const SizedBox(height: 18),
          _MutedText(
            'بدأت اطبعلي بالتسويق التقليدي من خلال طباعة اللافتات والإعلانات في الطرق والجرائد، ثم تطورنا مع مرور الوقت لنصبح من رواد منصات التواصل الاجتماعي ونواكب كل جديد في عالم الإعلانات.\n\nرحلتنا هي انتقال من الطرق التقليدية إلى الابتكار الرقمي، حيث نجمع بين الخبرة والتطور لنقدم حلول تسويقية تواكب العصر وتحقق نتائج حقيقية.\n\nاليوم، نفخر بخدمة أكثر من 5000 عميل نشط عبر مجالات متعددة، مسلحين بفريق من أكثر من 15 متخصصًا يجمعون بين الإبداع والتحليل والتقنية. لسنا مجرد وكالة تسويق — نحن شريك نمو حقيقي يستثمر في نجاحك كما تستثمر أنت فيه.',
            centered: true,
          ),
          const SizedBox(height: 18),
          const _Timeline(items: [
            _TimelineItem('2014', 'بداية رحلتنا في التسويق التقليدي'),
            _TimelineItem('2017', 'الانتقال الكامل للتسويق الرقمي'),
            _TimelineItem('2020', 'التوسع وإطلاق خدمات الإعلانات المدفوعة'),
            _TimelineItem('اليوم', '+5000 عميل نشط وفريق من +15 متخصص'),
          ]),
          const SizedBox(height: 22),
          const _StoryMetaStats(),
          const SizedBox(height: 18),
          const _QuoteCard(),
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
          _Badge(icon: Icons.diamond_rounded, label: 'قيمنا'),
          const SizedBox(height: 14),
          _SectionTitle(
            title: 'ما الذي',
            highlight: 'يميزنا',
            centered: true,
          ),
          const SizedBox(height: 10),
          _MutedText(
            'مبادئ راسخة تقود كل قرار نتخذه وكل مشروع ننجزه',
            centered: true,
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.02,
            children: const [
              _ValueCard(
                icon: Icons.lightbulb_rounded,
                color: Color(0xFFD4AF37),
                title: 'الإبداع أولًا',
                desc:
                    'نرفض الحلول الجاهزة. كل مشروع يستحق فكرة أصلية تعكس هوية العلامة.',
              ),
              _ValueCard(
                icon: Icons.visibility_rounded,
                color: Color(0xFF63B3ED),
                title: 'الشفافية الكاملة',
                desc:
                    'لا أسرار مع عملائنا. تقارير واضحة وتواصل مفتوح في كل مرحلة.',
              ),
              _ValueCard(
                icon: Icons.trending_up_rounded,
                color: Color(0xFF68D391),
                title: 'النتائج القابلة للقياس',
                desc:
                    'نعمل بالأرقام والبيانات. لا وعود فارغة، فقط نتائج حقيقية يمكن قياسها.',
              ),
              _ValueCard(
                icon: Icons.handshake_rounded,
                color: Color(0xFFF6AD55),
                title: 'الشراكة الحقيقية',
                desc: 'نجاحك هو نجاحنا. نعاملك كشريك لا كعميل فحسب.',
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
          _Badge(icon: Icons.star_rounded, label: 'لماذا نحن'),
          const SizedBox(height: 14),
          _SectionTitle(
            title: 'ما الذي يجعل',
            highlight: 'اطبعلي مختلفة؟',
            centered: true,
          ),
          const SizedBox(height: 10),
          _MutedText(
            'نمزج بين الإبداع والبيانات والخبرة لنصنع نتائج لا تُنسى.',
            centered: true,
          ),
          const SizedBox(height: 18),
          const _WhyCard(
            icon: Icons.rocket_launch_rounded,
            color: Color(0xFFD4AF37),
            number: '+400,000',
            title: 'مشروع منجز',
            desc: 'خبرة واسعة في قطاعات مختلفة بجودة تنفيذ ثابتة.',
            progress: 0.92,
          ),
          const SizedBox(height: 12),
          const _WhyCard(
            icon: Icons.show_chart_rounded,
            color: Color(0xFF68D391),
            number: '3.8x',
            title: 'متوسط عائد الاستثمار',
            desc: 'قرارات تسويقية مبنية على أثر واضح وأرقام قابلة للمتابعة.',
            progress: 0.85,
          ),
          const SizedBox(height: 12),
          const _WhyCard(
            icon: Icons.schedule_rounded,
            color: Color(0xFF63B3ED),
            number: '24h',
            title: 'وقت الاستجابة',
            desc: 'متابعة سريعة ومنظمة حتى لا يتوقف العمل عند سؤال.',
            progress: 1,
          ),
          const SizedBox(height: 18),
          const _PartnerBanner(),
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
          const _CeoVideoWidget(),
          const SizedBox(height: 24),
          _RoleLabel(label: 'رسالة المدير التنفيذي'),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: 'نقود نمو أعمالك\n',
              children: [
                TextSpan(
                  text: 'برؤية تعتمد على الأرقام',
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
          const SizedBox(height: 14),
          _MutedText(
            'في اطبعلي، بنحوّل أفكارك لنتائج حقيقية على أرض الواقع. بنصمّم، بنسوّق، وبنصنع محتوى يخليك توصل لعملاء أكتر وتكبر بثقة.',
            centered: true,
          ),
          const SizedBox(height: 18),
          _GlowPanel(
            child: const _Checklist(items: [
              _CheckItem(
                  'رؤية إبداعية تجمع بين الفن والبيانات', Color(0xFFD4AF37)),
              _CheckItem(
                  'استراتيجيات مخصصة لكل عميل على حدة', Color(0xFF68D391)),
              _CheckItem(
                  'شفافية كاملة في التقارير والنتائج', Color(0xFF63B3ED)),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.bgCard.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.gold.withValues(alpha: 0.24)),
            ),
            child: Column(
              children: [
                Text(
                  'المهندس/ محمد المصراوي',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المدير التنفيذي',
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
          _Badge(icon: Icons.groups_2_rounded, label: 'فريقنا'),
          const SizedBox(height: 14),
          _SectionTitle(
            title: 'الفريق الذي',
            highlight: 'يصنع الفرق',
            centered: true,
          ),
          const SizedBox(height: 10),
          _MutedText(
            'متخصصون شغوفون يجمعهم هدف واحد: نجاحك الرقمي.',
            centered: true,
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
            children: const [
              _TeamCard(
                name: 'ياسمين',
                role: 'Account Manager',
                image: 'yasmine',
              ),
              _TeamCard(
                name: 'محمود السيد',
                role: 'Team Leader & Video Editor',
                image: 'mahmoud',
              ),
              _TeamCard(
                name: 'هاجر',
                role: 'Operations Coordinator',
                image: 'hagar',
              ),
              _TeamCard(
                name: 'أحمد السيد',
                role: 'Web Developer',
                image: 'ahmed',
              ),
              _TeamCard(
                name: 'سلمى صافي',
                role: 'Mobile Developer',
                image: 'salma',
              ),
              _TeamCard(
                name: 'شهد',
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
      context.showErrorSnackBar('تعذر تحميل العقد');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return _PlainSection(
      child: Column(
        children: [
          _Badge(icon: Icons.file_copy_rounded, label: 'عقد الشراكة'),
          const SizedBox(height: 14),
          _SectionTitle(
            title: 'عقد تسويق',
            highlight: 'الشركة',
            centered: true,
          ),
          const SizedBox(height: 10),
          _MutedText(
            'شراكة مبنية على الثقة والشفافية — اطّلع على تفاصيل عقدنا الاحترافي',
            centered: true,
          ),
          const SizedBox(height: 22),
          _ContractDocumentPreview(),
          const SizedBox(height: 22),
          _GlowPanel(
            child: Column(
              children: [
                _Badge(icon: Icons.shield_rounded, label: 'عقد رسمي معتمد'),
                const SizedBox(height: 14),
                Text(
                  'شفافية كاملة منذ اليوم الأول',
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                _MutedText(
                  'نؤمن أن العلاقة المهنية الناجحة تبدأ بعقد واضح يحدد الحقوق والالتزامات لكلا الطرفين. عقدنا يضمن لك الحماية الكاملة وضمان جودة الخدمة.',
                  centered: true,
                ),
                const SizedBox(height: 16),
                const _Checklist(items: [
                  _CheckItem('تحديد واضح للخدمات والمواعيد', Color(0xFFD4AF37)),
                  _CheckItem('ضمان حماية بيانات العميل', Color(0xFF68D391)),
                  _CheckItem('آلية واضحة للدفع والفواتير', Color(0xFF63B3ED)),
                  _CheckItem('حقوق الملكية الفكرية محفوظة', Color(0xFFF6AD55)),
                ]),
                const SizedBox(height: 14),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _downloadContract(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: colors.gold.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: colors.gold.withValues(alpha: 0.36)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download_rounded,
                              color: colors.gold, size: 18),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تحميل العقد',
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: colors.textMain,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'ملف PDF • يمكن الطباعة',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: colors.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colors.gold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.picture_as_pdf_rounded,
                                color: Colors.black, size: 19),
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
      duration: const Duration(milliseconds: 320),
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
          constraints: const BoxConstraints(maxWidth: 360),
          height: 506,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 32,
                offset: Offset(0, 18),
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
          left: -18,
          top: 234,
          child: _SlideArrow(
            icon: Icons.chevron_right_rounded,
            onTap: _previous,
          ),
        ),
        Positioned(
          right: -18,
          top: 234,
          child: _SlideArrow(
            icon: Icons.chevron_left_rounded,
            onTap: _next,
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF111018),
              borderRadius: BorderRadius.circular(999),
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
        customBorder: const CircleBorder(),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF101018),
            border: Border.all(color: colors.gold.withValues(alpha: 0.48)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: colors.gold, size: 24),
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
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          _Badge(icon: Icons.rocket_launch_rounded, label: 'من نحن'),
          const SizedBox(height: 14),
          Text(
            'جاهز تبني حضورك الرقمي؟',
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _MutedText(
            'فريقنا مستعد للإجابة على كل أسئلتك وتحويل أفكارك إلى واقع',
            centered: true,
          ),
          const SizedBox(height: 18),
          Material(
            color: colors.gold,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => context.go(AppRoutes.contact),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_rounded, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      'تحدث مع فريقنا',
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Color(0xFF221D18), Color(0xFF111018), Color(0xFF181323)],
        ),
        border: Border.all(color: colors.gold.withValues(alpha: 0.22)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colors.gold,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.26),
                      blurRadius: 22,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شريك نمو حقيقي، لا مجرد مزود خدمة',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'نؤمن أن نجاحك هو نجاحنا — لذا ندير حملاتك كأنها حملاتنا ونقيس كل قرار بالنتيجة.',
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
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(child: _MiniMetric(value: '+12', label: 'سنوات خبرة')),
              _VerticalDivider(),
              Expanded(child: _MiniMetric(value: '5,000+', label: 'عميل نشط')),
              _VerticalDivider(),
              Expanded(child: _MiniMetric(value: '+15', label: 'متخصص')),
              _VerticalDivider(),
              Expanded(child: _MiniMetric(value: '4', label: 'دول خليجية')),
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
          _RoleLabel(label: 'المدير التنفيذي والمؤسس'),
          const SizedBox(height: 14),
          _CeoPortraitCard(),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              text: 'مهندس/ محمد\n',
              children: [
                TextSpan(
                  text: 'المصراوي',
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
          const SizedBox(height: 14),
          _MutedText(
            'رائد أعمال ومسوق رقمي بخبرة تمتد لأكثر من 12 عامًا في تحويل الأفكار إلى علامات تجارية ناجحة. أسس اطبعلي لتكون جسر النجاح بين الشركات وعملائها، بأسلوب يجمع بين الإبداع العلمي والنتائج القابلة للقياس.',
            centered: true,
          ),
          const SizedBox(height: 18),
          const _Checklist(items: [
            _CheckItem(
                'رؤية إبداعية تجمع بين الفن والبيانات', Color(0xFFD4AF37)),
            _CheckItem('استراتيجيات مخصصة لكل عميل على حدة', Color(0xFF68D391)),
            _CheckItem('شفافية كاملة في التقارير والنتائج', Color(0xFF63B3ED)),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: colors.bgCard.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.gold.withValues(alpha: 0.18)),
            ),
            child: const Row(
              children: [
                Expanded(child: _MiniMetric(value: '5K+', label: 'عميل راضٍ')),
                _VerticalDivider(),
                Expanded(
                    child: _MiniMetric(value: '93%', label: 'رضا العملاء')),
                _VerticalDivider(),
                Expanded(child: _MiniMetric(value: '4', label: 'دول خليجية')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'مهندس/ محمد المصراوي',
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
          width: 260,
          height: 330,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.gold.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: colors.gold.withValues(alpha: 0.12),
                blurRadius: 34,
                offset: const Offset(0, 18),
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
          top: 34,
          left: -18,
          child: _FloatingBadge(icon: Icons.work_rounded, label: '400K+ مشروع'),
        ),
        Positioned(
          bottom: 28,
          right: -18,
          child: _FloatingBadge(
              icon: Icons.timeline_rounded, label: '+12 سنة خبرة'),
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: filled ? colors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: filled ? Colors.black : colors.gold,
                size: 18,
              ),
              const SizedBox(width: 10),
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
                      const SizedBox(height: 2),
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
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.black.withValues(alpha: 0.14)
                      : colors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
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
        Icon(icon, color: colors.gold.withValues(alpha: 0.72), size: 13),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w800,
            fontSize: 10,
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
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 32,
            offset: Offset(0, 16),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colors.bgCard.withValues(alpha: 0.88),
        border: Border.all(color: colors.gold.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: colors.gold.withValues(alpha: 0.08),
            blurRadius: 34,
            offset: const Offset(0, 14),
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
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: colors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.gold.withValues(alpha: 0.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 16),
          const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xDD0B0912),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
        boxShadow: const [
          BoxShadow(color: Color(0x55000000), blurRadius: 18),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 15),
          const SizedBox(width: 6),
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
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withValues(alpha: 0.38),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
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
  const _CheckItem(this.label, this.color);

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
      width: 1,
      height: 42,
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
        constraints: const BoxConstraints(maxWidth: 430),
        child: Stack(
          children: [
            Positioned(
              top: 7,
              bottom: 7,
              right: 7,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.26),
                      blurRadius: 12,
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
  const _TimelineItem(this.year, this.label);

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
      1 => const Color(0xFF63B3ED),
      2 => const Color(0xFF68D391),
      _ => colors.gold,
    };
    final isActive = item.year == 'اليوم';

    return Padding(
      padding: EdgeInsets.only(bottom: index == 3 ? 0 : 20),
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
          const SizedBox(width: 16),
          SizedBox(
            width: 46,
            child: Text(
              item.year,
              textAlign: TextAlign.right,
              style: context.textTheme.labelLarge?.copyWith(
                color: colors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isActive ? dotColor : const Color(0xFF0B0914),
              shape: BoxShape.circle,
              border: Border.all(color: dotColor, width: 2.5),
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
      padding: const EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.gold.withValues(alpha: 0.16)),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _StoryMetaItem(
              icon: Icons.calendar_month_rounded,
              label: 'تأسست',
              value: '2014',
            ),
          ),
          Expanded(
            child: _StoryMetaItem(
              icon: Icons.location_on_rounded,
              label: 'المقر الرئيسي',
              value: 'الإسكندرية، مصر',
            ),
          ),
          Expanded(
            child: _StoryMetaItem(
              icon: Icons.groups_rounded,
              label: 'حجم الفريق',
              value: '+15 متخصص',
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
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colors.bgCard.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
          ),
          child: Icon(icon, color: colors.gold, size: 19),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, color: colors.gold, size: 30),
          const SizedBox(height: 6),
          _MutedText(
            'لم نكتفِ بمواكبة التحول الرقمي — بل كنا جزءًا من صناعته. كل مشروع ننجزه هو شهادة على التزامنا بالتميز وحرصنا على أن يُترجم استثمارك التسويقي إلى نتائج يمكن قياسها والاحتفال بها.',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: colors.gold.withValues(alpha: 0.28)),
                ),
                child: Icon(Icons.person_rounded, color: colors.gold, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مهندس/ محمد المصراوي',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: colors.textMain,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'المدير التنفيذي والمؤسس',
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
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
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
                        fontSize: 14,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                        height: 1.25,
                        fontSize: 11.6,
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0x66110E1B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 26),
              const Spacer(),
              Text(
                number,
                style: context.textTheme.titleLarge?.copyWith(
                  color: colors.textMain,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: context.textTheme.bodySmall?.copyWith(
              color: colors.textMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
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
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
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
          Icon(Icons.emoji_events_rounded, color: colors.gold, size: 30),
          const SizedBox(height: 10),
          Text(
            'شريك نمو حقيقي، لا مجرد مزود خدمة',
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          _MutedText(
            'ندير حملاتك كأنها حملاتنا، ونقيس كل قرار بالنتيجة.',
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: colors.gold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: colors.gold.withValues(alpha: 0.5), blurRadius: 12),
            ],
          ),
        ),
        const SizedBox(width: 8),
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
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.38)),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
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
          const SizedBox(height: 12),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
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
          const SizedBox(height: 10),
          Container(
              height: 2, width: 38, color: colors.gold.withValues(alpha: 0.55)),
        ],
      ),
    );
  }
}

class _PortfolioCoverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEFE2D0), Color(0xFFF9F5ED), Color(0xFFE1C39D)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final framePaint = Paint()
      ..color = const Color(0xFFB99262).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18, 20, 74, 88),
        const Radius.circular(2),
      ),
      framePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - 92, 20, 74, 88),
        const Radius.circular(2),
      ),
      framePaint,
    );

    final artPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE8D4BE), Color(0xFFB6C4C1), Color(0xFFD6B58F)],
      ).createShader(Rect.fromLTWH(22, 24, 66, 80));
    canvas.drawRect(Rect.fromLTWH(22, 24, 66, 80), artPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 88, 24, 66, 80), artPaint);

    final floorPaint = Paint()..color = const Color(0xFFB08A60);
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
      ..color = const Color(0x11745CBA)
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
          const Color(0xFF321069).withValues(alpha: 0.08),
          const Color(0xFF321069).withValues(alpha: 0.42),
          const Color(0xFF271052).withValues(alpha: 0.68),
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
          const Color(0xFFD4AF37).withValues(alpha: 0.2),
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
      ..color = const Color(0x10745CBA)
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
          const Color(0xFFD4AF37).withValues(alpha: 0.16),
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
      ..color = const Color(0x557D5DFF)
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
              boxShadow: [
                BoxShadow(
                  color: colors.gold.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
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
                    bottom: 0,
                    left: 0,
                    right: 0,
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
        const SizedBox(height: 12),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _VideoBadge(
                icon: Icons.movie_creation_rounded,
                label: 'فيديو حصري',
              ),
              const SizedBox(width: 8),
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
        offset: const Offset(0, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: colors.gold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.gold.withValues(alpha: 0.35),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Icon(
                isReady ? Icons.play_arrow_rounded : Icons.hourglass_top,
                color: Colors.white,
                size: isReady ? 38 : 28,
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'مشاهدة رسالة المدير',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Container(
                  width: 9,
                  height: 9,
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
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      decoration: const BoxDecoration(
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
                  size: 28,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 5),
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
              const SizedBox(width: 8),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '${fmt(pos)} / ${fmt(dur)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onToggleMute,
                child: Icon(
                  value.volume > 0
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  color: Colors.white,
                  size: 22,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.bgCard.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 13),
          const SizedBox(width: 5),
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
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0E0A16), Color(0xFF21123B), Color(0xFF080611)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4AF37).withValues(alpha: 0.16),
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
  const _AboutBackgroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF070511), Color(0xFF0F0E18), Color(0xFF080613)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final gridPaint = Paint()
      ..color = const Color(0x12D4AF37)
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
      color: const Color(0x20D4AF37),
    );
    _drawOrb(
      canvas,
      center: Offset(size.width + 40, size.height * 0.28),
      radius: 210,
      color: const Color(0x1263B3ED),
    );
    _drawOrb(
      canvas,
      center: Offset(-20, size.height * 0.62),
      radius: 190,
      color: const Color(0x1068D391),
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

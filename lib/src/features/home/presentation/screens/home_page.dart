import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return EtbalyPage(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        const _HomeWebHero(),
        const _AirplaneBrandSection(),
        const _SuccessPartnersSection(),
        const _IdeasSuccessSection(),
        const _StatsImageStripSection(),
        const EtbalyPageSectionHeader(
          badge: 'ماذا نفعل',
          title: 'فريق واحد للرحلة الرقمية بالكامل',
          description:
              'نفس روح نسخة الويب داخل التطبيق: هوية، محتوى، إعلانات وتجارب رقمية مبنية على نتائج قابلة للقياس.',
        ),
        _HomeFeature(
          title: 'استراتيجية قبل التنفيذ',
          description:
              'خطط علامة تجارية، بناء حملات، تفكير في مسار العميل، وجداول محتوى مبنية حول أهداف العمل.',
          icon: Icons.route,
          color: colors.gold,
        ),
        _HomeFeature(
          title: 'محتوى إبداعي يبيع',
          description:
              'تصميمات، ريلز، صور منتجات، كتابة إعلانية، ومواد إطلاق بهوية بصرية احترافية.',
          icon: Icons.movie_creation,
          color: colors.primaryLight,
        ),
        _HomeFeature(
          title: 'أداء يمكن قياسه',
          description:
              'إعلانات، SEO، تقارير، وتحسين مستمر يركز على الوصول والعملاء والتحويل والاحتفاظ.',
          icon: Icons.trending_up,
          color: colors.success,
        ),
        EtbalyInfoCard(
          title: 'أعمال مختارة وباقات خدمات',
          description:
              'تصفح نماذج الأعمال، أقسام الخدمات، والباقات بصياغة مناسبة لتجربة الموبايل.',
          icon: Icons.collections,
          accent: colors.gold,
          trailing: Icon(Icons.arrow_forward_ios, color: colors.gold, size: 16),
          onTap: () => context.go(AppRoutes.portfolio),
        ),
      ],
    );
  }
}

class _HomeWebHero extends StatefulWidget {
  const _HomeWebHero();

  @override
  State<_HomeWebHero> createState() => _HomeWebHeroState();
}

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
    final heroHeight = width < 390 ? 460.0 : 480.0;
    final horizontalPadding = width < 390 ? 16.0 : 22.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: heroHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF100728),
                Color(0xFF160B2E),
                Color(0xFF0B061B),
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
                    painter: _HeroBackgroundPainter(_controller.value),
                  );
                },
              ),
              const _HeroGlow(
                alignment: Alignment.topRight,
                color: Color(0x886F3FF5),
                size: 230,
              ),
              const _HeroGlow(
                alignment: Alignment.bottomLeft,
                color: Color(0x55B85CFF),
                size: 260,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  26,
                  horizontalPadding,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: _HeroBrandBadge(),
                    )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 450))
                        .slideY(begin: -0.16),
                    SizedBox(height: width < 390 ? 30 : 38),
                    Text(
                      'نصنع لعلامتك',
                      textAlign: TextAlign.right,
                      style: _heroTitleStyle(context, width),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 80))
                        .slideY(begin: 0.18),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0xFFE2A0FF),
                          Color(0xFFC779FF),
                          Color(0xFF9D5BFF),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'حضورًا لا يُنسى',
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
                    const SizedBox(height: 20),
                    Text(
                      'وكالة تسويق وإبداع رقمي تساعدك على بناء هوية قوية وتحقيق نتائج عبر حلول تسويقية مبتكرة.',
                      textAlign: TextAlign.right,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: const Color(0xFFC4BED4),
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
                    const SizedBox(height: 28),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _HeroActionButton(
                          label: 'خدماتنا',
                          icon: Icons.arrow_forward,
                          onTap: () => context.go(AppRoutes.services),
                        ),
                        _HeroActionButton(
                          label: 'من نحن',
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
      color: Colors.white,
      fontSize: width < 360
          ? 36
          : width < 390
              ? 40
              : 48,
      fontWeight: FontWeight.w900,
      height: 1.12,
      letterSpacing: 0,
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(999);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          width: 136,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: outlined
                ? null
                : const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFB449FF),
                      Color(0xFF7C20E6),
                      Color(0xFF5B00B7),
                    ],
                  ),
            color: outlined ? const Color(0x2418102F) : null,
            border: outlined
                ? Border.all(color: const Color(0x887E5CB8), width: 1.2)
                : null,
            boxShadow: outlined
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x805B00B7),
                      blurRadius: 26,
                      offset: Offset(0, 14),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                label,
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AirplaneBrandSection extends StatefulWidget {
  const _AirplaneBrandSection();

  @override
  State<_AirplaneBrandSection> createState() => _AirplaneBrandSectionState();
}

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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          height: isNarrow ? 850 : 790,
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
                  vertical: 24,
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

class _AirplaneBadge extends StatelessWidget {
  const _AirplaneBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x226F3FF5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x665F37C7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF9B5CF6),
              boxShadow: [
                BoxShadow(color: Color(0x889B5CF6), blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'وكالة إبداعية متكاملة',
            style: context.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFC084FC),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AirplaneStatsCard extends StatelessWidget {
  const _AirplaneStatsCard({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 10 : 14,
        vertical: isNarrow ? 18 : 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xA0100B1D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x553D236C)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AirplaneStat(
              value: '+5000',
              label: 'علامة تجارية',
              isNarrow: isNarrow,
            ),
          ),
          const _AirplaneStatDivider(),
          Expanded(
            child: _AirplaneStat(
              value: '%93',
              label: 'رضا العملاء',
              isNarrow: isNarrow,
            ),
          ),
          const _AirplaneStatDivider(),
          Expanded(
            child: _AirplaneStat(
              value: '+12 سنوات',
              label: 'خبرة إبداعية',
              isNarrow: isNarrow,
            ),
          ),
        ],
      ),
    );
  }
}

class _AirplaneStat extends StatelessWidget {
  const _AirplaneStat({
    required this.value,
    required this.label,
    required this.isNarrow,
  });

  final String value;
  final String label;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFE4B7FF), Color(0xFFA855F7)],
          ).createShader(bounds),
          child: SizedBox(
            height: isNarrow ? 30 : 36,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: isNarrow ? 27 : 31,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(
            color: const Color(0xFFAAA1BC),
            fontSize: isNarrow ? 10 : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 2,
          width: isNarrow ? 58 : 74,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFFC084FC)],
            ),
          ),
        ),
      ],
    );
  }
}

class _AirplaneStatDivider extends StatelessWidget {
  const _AirplaneStatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 92,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0x553D236C),
    );
  }
}

class _AirplaneFeaturePills extends StatelessWidget {
  const _AirplaneFeaturePills();

  @override
  Widget build(BuildContext context) {
    const features = [
      ('هوية بصرية', Icons.auto_awesome),
      ('تصميم رقمي', Icons.diamond_outlined),
      ('تسويق ذكي', Icons.hexagon_outlined),
      ('استراتيجية نمو', Icons.adjust),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final feature in features)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x4A160B31),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0x663D236C)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(feature.$2, color: const Color(0xFFC084FC), size: 15),
                const SizedBox(width: 8),
                Text(
                  feature.$1,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FloatingPlane extends StatelessWidget {
  const _FloatingPlane({
    required this.animation,
    required this.top,
    required this.size,
    this.delay = 0,
    this.reverse = false,
    this.flipHorizontally = false,
  });

  final Animation<double> animation;
  final double top;
  final double size;
  final double delay;
  final bool reverse;
  final bool flipHorizontally;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final progress = (animation.value + delay) % 1;
        final screenWidth = context.width;
        final planeWidth = size * 2.35;
        final travel = screenWidth + planeWidth * 2;
        final x = reverse
            ? screenWidth + planeWidth - (progress * travel)
            : -planeWidth + (progress * travel);
        final bob = math.sin(progress * math.pi * 2) * 8;

        return Positioned(
          top: top + bob,
          left: x,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
              flipHorizontally ? -1 : 1,
              1,
              1,
            ),
            child: SizedBox(
              width: planeWidth,
              height: size,
              child: SvgPicture.asset(
                reverse ? AppAssets.airplaneLeft : AppAssets.airplaneRight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AirplaneBackgroundPainter extends CustomPainter {
  _AirplaneBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1F6F3FF5)
      ..strokeWidth = 1;
    const step = 56.0;
    final shift = progress * step * 0.45;

    for (double x = -step + shift; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = -step + shift; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final center = Offset(size.width * 0.5, size.height * 0.43);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x213D236C);
    canvas.drawCircle(center, 120, ringPaint);
    canvas.drawCircle(center, 190, ringPaint);

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x446F3FF5), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: 210));
    canvas.drawCircle(center, 210, glowPaint);

    final sparkPaint = Paint()
      ..color = const Color(0x66C084FC)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    for (var i = 0; i < 10; i++) {
      final seed = i * 0.21;
      final pulse = math.sin((progress + seed) * math.pi * 2);
      final x = size.width * ((seed * 4.7) % 1);
      final y = size.height * (0.14 + ((seed * 7.1) % 0.7));
      canvas.drawCircle(Offset(x, y), 2 + pulse.abs() * 2, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AirplaneBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _SuccessPartnersSection extends StatefulWidget {
  const _SuccessPartnersSection();

  @override
  State<_SuccessPartnersSection> createState() =>
      _SuccessPartnersSectionState();
}

class _SuccessPartnersSectionState extends State<_SuccessPartnersSection> {
  static const int _totalLogos = 51;
  static const int _logosPerGroup = 7;

  Timer? _timer;
  late final PageController _pageController;
  double _page = 0;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.48)
      ..addListener(() {
        final nextPage = _pageController.page ?? _activeIndex.toDouble();
        if ((nextPage - _page).abs() > 0.001) {
          setState(() => _page = nextPage);
        }
      });
    _timer = Timer.periodic(const Duration(milliseconds: 2600), (_) {
      if (!mounted) return;
      final nextIndex = (_activeIndex + 1) % _totalLogos;
      _animateToLogo(nextIndex);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _animateToLogo(int index) {
    if (!_pageController.hasClients) {
      setState(() => _activeIndex = index);
      return;
    }

    if (_activeIndex == _totalLogos - 1 && index == 0) {
      _pageController.jumpToPage(0);
      setState(() {
        _activeIndex = 0;
        _page = 0;
      });
      return;
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final isNarrow = width < 390;
    final activeDotGroup = _activeIndex ~/ _logosPerGroup;
    final dotCount = (_totalLogos / _logosPerGroup).ceil();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: isNarrow ? 560 : 590,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF080313), Color(0xFF05020E)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _PartnersBackgroundPainter()),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 14 : 18,
                  42,
                  isNarrow ? 14 : 18,
                  34,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _PartnersBadge()
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 450))
                        .slideY(begin: -0.14),
                    const SizedBox(height: 28),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: isNarrow ? 29 : 34,
                          fontWeight: FontWeight.w900,
                          height: 1.35,
                          letterSpacing: 0,
                        ),
                        children: const [
                          TextSpan(text: 'يثق بنا '),
                          TextSpan(
                            text: 'أكثر من 5000+ علامة',
                            style: TextStyle(color: Color(0xFFD879F9)),
                          ),
                          TextSpan(text: ' تجارية'),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 90))
                        .slideY(begin: 0.12),
                    const Spacer(),
                    SizedBox(
                      height: isNarrow ? 190 : 215,
                      child: PageView.builder(
                        controller: _pageController,
                        clipBehavior: Clip.none,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _totalLogos,
                        onPageChanged: (index) {
                          setState(() => _activeIndex = index);
                        },
                        itemBuilder: (context, index) {
                          final distance =
                              (index - _page).abs().clamp(0.0, 1.0);
                          return _PartnerLogoCard(
                            index: index,
                            distance: distance,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < dotCount; i++)
                          _PartnerDot(
                            active: i == activeDotGroup,
                            onTap: () {
                              _animateToLogo(i * _logosPerGroup);
                            },
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
    );
  }
}

class _PartnersBadge extends StatelessWidget {
  const _PartnersBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0x226F3FF5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x663D236C)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0x887C3AED), blurRadius: 12),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'شركاء النجاح',
            style: context.textTheme.labelLarge?.copyWith(
              color: const Color(0xFFA78BFA),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerLogoCard extends StatelessWidget {
  const _PartnerLogoCard({
    required this.index,
    required this.distance,
  });

  final int index;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final isNarrow = width < 390;
    final sideAmount = distance.clamp(0.0, 1.0);
    final activeWidth = isNarrow ? 140.0 : 162.0;
    final activeHeight = isNarrow ? 106.0 : 122.0;
    final sideWidth = isNarrow ? 74.0 : 90.0;
    final sideHeight = isNarrow ? 60.0 : 72.0;
    final cardWidth = activeWidth + (sideWidth - activeWidth) * sideAmount;
    final cardHeight = activeHeight + (sideHeight - activeHeight) * sideAmount;
    final opacity = 1 - (0.62 * sideAmount);
    final blur = 3.0 * sideAmount;
    final scale = 1 - (0.14 * sideAmount);

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xE08B5CF6),
                    const Color(0x887C3AED),
                    sideAmount,
                  )!,
                  width: 2 - (0.7 * sideAmount),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x668B5CF6)
                        .withValues(alpha: 0.4 * (1 - sideAmount)),
                    blurRadius: 34,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0x448B5CF6)
                        .withValues(alpha: 0.27 * (1 - sideAmount)),
                    blurRadius: 0,
                    spreadRadius: 3,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppAssets.partnerLogo(index + 1),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Partner ${index + 1}',
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF1E1732),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PartnerDot extends StatelessWidget {
  const _PartnerDot({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: active ? 30 : 9,
        height: 9,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C3AED) : const Color(0x553D236C),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _PartnersBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1A6F3FF5)
      ..strokeWidth = 1;
    const step = 72.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x335B21B6), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.44),
          radius: size.width * 0.65,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.44),
      size.width * 0.65,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IdeasSuccessSection extends StatefulWidget {
  const _IdeasSuccessSection();

  @override
  State<_IdeasSuccessSection> createState() => _IdeasSuccessSectionState();
}

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
                top: 36,
                right: 18,
                child: const _IdeasBadge()
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 420))
                    .slideX(begin: 0.18),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 18 : 22,
                  92,
                  isNarrow ? 18 : 22,
                  42,
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
                          icon: Icons.arrow_back,
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
                            bottom: isNarrow ? 40 : 46,
                            right: 0,
                            child: const _IdeasFloatingCard(
                              value: '187%+',
                              label: 'نمو الزيارات',
                              icon: Icons.bar_chart,
                            ),
                          ),
                          Positioned(
                            bottom: isNarrow ? 34 : 40,
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

class _IdeasBadge extends StatelessWidget {
  const _IdeasBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xCC241B2E),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x667B6A86)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x5520182C),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF14B867),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xAA14B867),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'وكالة تسويق رقمي احترافية',
            style: context.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFD4AF37),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdeasActionButton extends StatelessWidget {
  const _IdeasActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.filled = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          width: 150,
          height: 58,
          decoration: BoxDecoration(
            color: filled ? const Color(0xFFE5C352) : Colors.transparent,
            borderRadius: radius,
            border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
            boxShadow: filled
                ? const [
                    BoxShadow(
                      color: Color(0x55D4AF37),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: filled
                      ? const Color(0xFF1A102C)
                      : const Color(0xFFD4AF37),
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: const Color(0xFF1A102C), size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IdeasFloatingCard extends StatelessWidget {
  const _IdeasFloatingCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xD6232036),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x553D365C)),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 20),
        ],
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFF0E9FF),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFC0B5DE),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(
          begin: -3,
          end: 5,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
  }
}

class _IdeasSuccessBackgroundPainter extends CustomPainter {
  _IdeasSuccessBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1A6F3FF5)
      ..strokeWidth = 1;
    const step = 64.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final horizonY = size.height * 0.66;
    for (var i = 0; i < 22; i++) {
      final t = i / 21;
      final wavePaint = Paint()
        ..color = Color.lerp(
          const Color(0x995B21B6),
          const Color(0x887C3AED),
          t,
        )!
        ..strokeWidth = 1.1;
      final path = Path()..moveTo(-20, horizonY + (i - 11) * 6);
      for (double x = -20; x <= size.width + 20; x += 18) {
        final y = horizonY +
            (i - 11) * 6 +
            math.sin((x / 54) + progress * math.pi * 2 + i * 0.35) * 13;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, wavePaint);
    }

    final sparklePaint = Paint()
      ..color = const Color(0x88D4AF37)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    for (var i = 0; i < 18; i++) {
      final seed = i * 0.173;
      final x = size.width * ((seed * 5.7) % 1);
      final y = size.height * (0.05 + ((seed * 8.3) % 0.82));
      final pulse = 1 + math.sin((progress + seed) * math.pi * 2).abs() * 2;
      canvas.drawCircle(Offset(x, y), pulse, sparklePaint);
    }

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x336F3FF5), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.48),
          radius: size.width * 0.9,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.48),
      size.width * 0.9,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _IdeasSuccessBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _StatsImageStripSection extends StatefulWidget {
  const _StatsImageStripSection();

  @override
  State<_StatsImageStripSection> createState() =>
      _StatsImageStripSectionState();
}

class _StatsImageStripSectionState extends State<_StatsImageStripSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 85),
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
    final imageWidth = isNarrow ? 230.0 : 270.0;
    final segmentWidth = (imageWidth + 18) * 10;

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
              colors: [Color(0xFF130A2D), Color(0xFF090513)],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _StatsStripBackgroundPainter(_controller.value),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 14 : 18,
                  28,
                  isNarrow ? 14 : 18,
                  30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _StatsBand(),
                    const SizedBox(height: 58),
                    const _StripHeader(),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: isNarrow ? 260 : 300,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final offset = _controller.value * segmentWidth;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Transform.translate(
                              offset: Offset(-offset % segmentWidth, 0),
                              child: Row(
                                children: [
                                  for (var loop = 0; loop < 2; loop++)
                                    for (var i = 1; i <= 10; i++)
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                          end: 18,
                                        ),
                                        child: _StripImageCard(
                                          image: AppAssets.stripImage(i),
                                          width: imageWidth,
                                          onTap: () => _showStripLightbox(
                                            context,
                                            AppAssets.stripImage(i),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          );
                        },
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

  void _showStripLightbox(BuildContext context, String image) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      builder: (context) => _StripLightbox(image: image),
    );
  }
}

class _StatsBand extends StatelessWidget {
  const _StatsBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x55D4AF37)),
          bottom: BorderSide(color: Color(0x55D4AF37)),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _StatsBandItem(
              value: '+400,000',
              label: 'مشروع منجز',
              icon: Icons.rocket_launch,
            ),
          ),
          _StatsBandDivider(),
          Expanded(
            child: _StatsBandItem(
              value: '+5,000',
              label: 'عميل راضي',
              icon: Icons.sentiment_satisfied_alt,
            ),
          ),
          _StatsBandDivider(),
          Expanded(
            child: _StatsBandItem(
              value: '+12',
              label: 'سنوات خبرة',
              icon: Icons.star,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBandItem extends StatelessWidget {
  const _StatsBandItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isTight = context.width < 390;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: isTight ? 44 : 52,
          height: isTight ? 44 : 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0x33251D33),
            border: Border.all(color: const Color(0x77D4AF37)),
          ),
          child: Icon(icon, color: const Color(0xFFD4AF37), size: 23),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  maxLines: 1,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFD4AF37),
                    fontSize: isTight ? 24 : 30,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFFC7B6FF),
                  fontSize: isTight ? 11 : 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsBandDivider extends StatelessWidget {
  const _StatsBandDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: const Color(0x335F4B7F),
    );
  }
}

class _StripHeader extends StatelessWidget {
  const _StripHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0x55D4AF37))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'نبذة عنّا',
            style: context.textTheme.labelLarge?.copyWith(
              color: const Color(0xFFD4AF37),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0x55D4AF37))),
      ],
    );
  }
}

class _StripImageCard extends StatelessWidget {
  const _StripImageCard({
    required this.image,
    required this.width,
    required this.onTap,
  });

  final String image;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: width * 0.92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x553D365C)),
          boxShadow: const [
            BoxShadow(color: Color(0x55000000), blurRadius: 16),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _StripLightbox extends StatelessWidget {
  const _StripLightbox({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x778B5CF6),
                  blurRadius: 32,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 3,
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
          PositionedDirectional(
            top: -14,
            end: -10,
            child: Material(
              color: const Color(0xFF1B102B),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Color(0xFFD4AF37)),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 220)).scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
  }
}

class _StatsStripBackgroundPainter extends CustomPainter {
  _StatsStripBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x176F3FF5)
      ..strokeWidth = 1;
    const step = 64.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final beamPaint = Paint()
      ..color = const Color(0x887D5DFF)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.02, size.height * 0.34),
      beamPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.38, 0),
      Offset(size.width * 0.14, size.height * 0.55),
      beamPaint,
    );

    final glowLeft = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x665B21B6), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(0, size.height * 0.1),
          radius: size.width * 0.65,
        ),
      );
    canvas.drawCircle(
        Offset(0, size.height * 0.1), size.width * 0.65, glowLeft);

    final sparkPaint = Paint()
      ..color = const Color(0x77D4AF37)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    for (var i = 0; i < 12; i++) {
      final seed = i * 0.211;
      final x = size.width * ((seed * 4.9) % 1);
      final y = size.height * (0.02 + ((seed * 7.1) % 0.55));
      final radius =
          1.4 + math.sin((progress + seed) * math.pi * 2).abs() * 2.2;
      canvas.drawCircle(Offset(x, y), radius, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StatsStripBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _HeroBrandBadge extends StatelessWidget {
  const _HeroBrandBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: [Color(0xFF8D63FF), Color(0xFF5B27D9), Color(0xFF1A123D)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x776F3FF5),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEAF8),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اطبعلي',
              style: context.textTheme.titleSmall?.copyWith(
                color: const Color(0xFF19102F),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 52,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.2),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppAssets.logo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Digital\nMarketing',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF7B5B12),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      height: 0.95,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow({
    required this.alignment,
    required this.color,
    required this.size,
  });

  final Alignment alignment;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _HeroBackgroundPainter extends CustomPainter {
  _HeroBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size);
    _paintBeams(canvas, size);
    _paintParticles(canvas, size);
    _paintComets(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x246F3FF5)
      ..strokeWidth = 1;
    const step = 48.0;
    final shift = progress * step;

    for (double x = -step + shift; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = -step + shift; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintBeams(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Color(0x88B9A3FF), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.4;

    final t = math.sin(progress * math.pi * 2);
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.98),
      Offset(size.width * (0.34 + t * 0.03), size.height * 0.02),
      beamPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.0, size.height * 0.44),
      Offset(size.width * (0.25 + t * 0.02), size.height * 0.36),
      beamPaint,
    );
  }

  void _paintParticles(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xAFC084FC)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (var i = 0; i < 18; i++) {
      final seed = i * 0.137;
      final y = (size.height * (0.18 + (seed * 5.3) % 0.72) -
              progress * size.height * (0.22 + (i % 4) * 0.035)) %
          size.height;
      final x = size.width * ((seed * 7.7) % 1);
      final pulse = 1 + math.sin((progress + seed) * math.pi * 2) * 0.45;
      canvas.drawCircle(Offset(x, y), 1.3 * pulse, paint);
    }
  }

  void _paintComets(Canvas canvas, Size size) {
    for (var i = 0; i < 3; i++) {
      final local = (progress + i * 0.33) % 1;
      final startX = -size.width * 0.35;
      final x = startX + local * size.width * 1.55;
      final y = size.height * (0.12 + i * 0.23);
      final path = Path()
        ..moveTo(x, y)
        ..lineTo(x + 120, y - 38);
      final paint = Paint()
        ..shader = const LinearGradient(
          colors: [Colors.transparent, Color(0xAAC084FC), Color(0x006F3FF5)],
        ).createShader(Rect.fromLTWH(x, y - 42, 130, 42))
        ..strokeWidth = i == 0 ? 2.2 : 1.4
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeroBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _HomeFeature extends StatelessWidget {
  const _HomeFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return EtbalyInfoCard(
      title: title,
      description: description,
      icon: icon,
      accent: color,
    );
  }
}

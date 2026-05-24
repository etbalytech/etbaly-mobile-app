import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class EtbalyServicesShowcaseSection extends StatefulWidget {
  const EtbalyServicesShowcaseSection({super.key});

  static const _services = [
    _ServiceCardData(
      slug: 'design',
      number: '01',
      title: 'تصميمات احترافية',
      description:
          'نبني هويتك البصرية الكاملة من شعار، موشن جرافيك، بوستات، وكل ما يعكس روح علامتك التجارية باحترافية.',
      icon: Icons.brush,
      imageAsset: 'assets/images/services/design.webp',
    ),
    _ServiceCardData(
      slug: 'social',
      number: '02',
      title: 'إدارة السوشيال ميديا',
      description:
          'محتوى إبداعي يومي، إدارة احترافية لحساباتك على جميع المنصات، وتفاعل حقيقي مع جمهورك.',
      icon: Icons.share,
      imageAsset: 'assets/images/services/social.webp',
    ),
    _ServiceCardData(
      slug: 'ads',
      number: '03',
      title: 'الإعلانات الممولة',
      description:
          'حملات ذكية على المنصات المناسبة لجمهورك، بمتابعة مستمرة وتحسين للنتائج.',
      icon: Icons.campaign,
      imageAsset: 'assets/images/services/ads.webp',
    ),
    _ServiceCardData(
      slug: 'web',
      number: '04',
      title: 'تصميم وتطوير المواقع',
      description:
          'مواقع ويب سريعة، متجاوبة، ومحسنة لمحركات البحث تحول الزوار إلى عملاء.',
      icon: Icons.code,
      imageAsset: 'assets/images/services/web.webp',
    ),
    _ServiceCardData(
      slug: 'mobile-app',
      number: '05',
      title: 'تصميم وتطوير تطبيقات موبايل',
      description:
          'نقوم بتصميم وتطوير تطبيقات موبايل احترافية لأندرويد وiOS لزيادة تفاعل عملائك وتوسيع نطاق علامتك التجارية.',
      icon: Icons.phone_iphone,
      imageAsset: 'assets/images/services/mobile.webp',
    ),
    _ServiceCardData(
      slug: 'boost',
      number: '06',
      title: 'تزويد منصات السوشيال ميديا',
      description:
          'خدمات نمو مدروسة تساعد حضورك الرقمي يوصل بشكل أقوى وأسرع للجمهور المناسب.',
      icon: Icons.photo_camera,
      imageAsset: 'assets/images/services/boost.webp',
    ),
    _ServiceCardData(
      slug: 'video',
      number: '07',
      title: 'إنشاء وتعديل الفيديوهات',
      description:
          'فيديوهات قصيرة ورييلز ومونتاج إعلاني يعرض رسالتك بشكل جذاب ومناسب للمنصات.',
      icon: Icons.videocam,
      imageAsset: 'assets/images/services/video.webp',
    ),
    _ServiceCardData(
      slug: 'seo',
      number: '08',
      title: 'تحسين محركات البحث',
      description:
          'نحسن ظهورك في نتائج البحث ببنية تقنية ومحتوى واضح وخطة كلمات مفتاحية فعالة.',
      icon: Icons.manage_search,
      imageAsset: 'assets/images/services/seo.webp',
    ),
    _ServiceCardData(
      slug: 'moderator',
      number: '09',
      title: 'إدارة التعليقات والرسائل',
      description:
          'فريق متابعة يرد وينظم المحادثات ويحافظ على سرعة التواصل مع جمهورك.',
      icon: Icons.support_agent,
      imageAsset: 'assets/images/services/moderator.webp',
    ),
    _ServiceCardData(
      slug: 'brand-plan',
      number: '10',
      title: 'خطة البراند المتكاملة',
      description:
          'خطة استراتيجية تحدد تموضع العلامة ورسائلها وخطوات نموها التسويقية.',
      icon: Icons.diamond,
      imageAsset: 'assets/images/services/brand-plan.webp',
    ),
  ];

  @override
  State<EtbalyServicesShowcaseSection> createState() =>
      _EtbalyServicesShowcaseSectionState();
}

class _EtbalyServicesShowcaseSectionState
    extends State<EtbalyServicesShowcaseSection> {
  bool _didPrecacheImages = false;
  final List<(ImageStream, ImageStreamListener)> _pinnedImageStreams = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheImages) return;
    _didPrecacheImages = true;

    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.maximumSize =
        imageCache.maximumSize < 300 ? 300 : imageCache.maximumSize;
    imageCache.maximumSizeBytes = imageCache.maximumSizeBytes < 250 << 20
        ? 250 << 20
        : imageCache.maximumSizeBytes;

    for (final service in EtbalyServicesShowcaseSection._services) {
      final provider = _serviceImageProvider(service.imageAsset);
      precacheImage(provider, context);

      final stream = provider.resolve(createLocalImageConfiguration(context));
      final listener = ImageStreamListener((_, __) {});
      stream.addListener(listener);
      _pinnedImageStreams.add((stream, listener));
    }
  }

  @override
  void dispose() {
    for (final (stream, listener) in _pinnedImageStreams) {
      stream.removeListener(listener);
    }
    _pinnedImageStreams.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: EtbalyWebSectionShell(
        backgroundPainter: const _ServicesPainter(),
        child: Column(
          children: [
            const EtbalyWebBadge(label: 'ما نقدمه'),
            const SizedBox(height: 18),
            Text(
              'كل ما تحتاجه لنجاحك الرقمي',
              textAlign: TextAlign.center,
              style: context.textTheme.displaySmall?.copyWith(
                color: EtbalyWebColors.heading,
                fontSize: context.width < 390 ? 36 : 46,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                'حلول تسويقية متكاملة ومتطورة تضع علامتك التجارية في المكان الذي تستحقه',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: EtbalyWebColors.heading.withValues(alpha: 0.9),
                  fontSize: context.width < 390 ? 14 : 16,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 34),
            EtbalyWebResponsiveGrid(
              children: [
                for (final service in EtbalyServicesShowcaseSection._services)
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
    final borderRadius = BorderRadius.circular(16);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/services/${service.slug}'),
        borderRadius: borderRadius,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: const Color(0xFF0F0D1D),
            borderRadius: borderRadius,
            border: Border.all(color: EtbalyWebColors.border),
            boxShadow: const [
              BoxShadow(
                color: EtbalyWebColors.shadow,
                blurRadius: 20,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -48,
                left: -48,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        EtbalyWebColors.gold.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        RepaintBoundary(
                          child: _ServiceAssetImage(service: service),
                        ),
                        const Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0x77070511),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 17),
                    decoration: const BoxDecoration(
                      color: Color(0xFF11101F),
                      border: Border(
                        top: BorderSide(color: Color(0x22D4AF37)),
                      ),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض التفاصيل',
                          textAlign: TextAlign.right,
                          style: context.textTheme.labelLarge?.copyWith(
                            color: EtbalyWebColors.gold,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Icon(
                          Icons.arrow_forward,
                          color: EtbalyWebColors.gold,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        EtbalyWebColors.gold,
                        Colors.transparent,
                      ],
                    ),
                  ),
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

ImageProvider _serviceImageProvider(String asset) {
  return ResizeImage(
    AssetImage(asset),
    width: 900,
  );
}

class _ServiceAssetImage extends StatelessWidget {
  const _ServiceAssetImage({required this.service});

  final _ServiceCardData service;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFF11101F)),
      child: Image(
        image: _serviceImageProvider(service.imageAsset),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        filterQuality: FilterQuality.low,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return const SizedBox.expand();
        },
        errorBuilder: (context, error, stackTrace) =>
            _ServiceImageFallback(service: service),
      ),
    );
  }
}

class _ServiceCardData {
  const _ServiceCardData({
    required this.slug,
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.imageAsset,
  });

  final String slug;
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final String imageAsset;
}

class _ServiceImageFallback extends StatelessWidget {
  const _ServiceImageFallback({
    required this.service,
  });

  final _ServiceCardData service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF171326),
            Color(0xFF0F0D1D),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Text(
              service.number,
              style: context.textTheme.headlineMedium?.copyWith(
                color: EtbalyWebColors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  service.icon,
                  color: EtbalyWebColors.gold,
                  size: 48,
                ),
                const SizedBox(height: 14),
                Text(
                  service.title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: EtbalyWebColors.body,
                    height: 1.5,
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

class _ServicesPainter extends CustomPainter {
  const _ServicesPainter();

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

    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x553B1F75), Colors.transparent],
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
      ..color = EtbalyWebColors.purpleLine
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
  bool shouldRepaint(covariant _ServicesPainter oldDelegate) => false;
}

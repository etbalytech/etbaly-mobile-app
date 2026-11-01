import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../data/portfolio_data.dart';
import '../../data/portfolio_repository.dart';
import '../expertise_cards.dart';
import '../expertise_icons.dart';
import '../widgets/expertise_artwork_tile.dart';
import '../widgets/expertise_sample_kit.dart';
import '../widgets/google_reviews_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension _PortfolioIndustryLocale on PortfolioIndustry {
  String localizedName(BuildContext context) =>
      context.locale.languageCode == 'en' ? nameEn : nameAr;
}

extension _PortfolioSpecialtyLocale on PortfolioSpecialty {
  String localizedName(BuildContext context) =>
      context.locale.languageCode == 'en' ? nameEn : nameAr;
}

extension _PortfolioMediaLocale on PortfolioMedia {
  String localizedTag(BuildContext context) =>
      context.locale.languageCode == 'en' ? tagEn : tagAr;
}

/// Which samples an expertise gallery shows (the website's `sampleKind`).
enum ExpertiseGalleryKind { photos, reels }

/// "مجالات خبرتنا". Without a [kind] this is the expertise hub (hero, company
/// portfolio, platform cards, reviews); with one it is the design or video
/// gallery: industries → specialties → samples of that kind only.
class ExpertisesScreen extends StatefulWidget {
  const ExpertisesScreen({super.key, this.kind});

  final ExpertiseGalleryKind? kind;

  @override
  State<ExpertisesScreen> createState() => _ExpertisesScreenState();
}

class _ExpertisesScreenState extends State<ExpertisesScreen>
    with SingleTickerProviderStateMixin {
  static const _classPreviews = {
    'classA':
        'https://drive.google.com/file/d/1BoFiWtw01CJ_U6zGpxmhHhCDWmHCf79V/view?usp=drive_link',
    'classB':
        'https://drive.google.com/file/d/1OMlt-uM8cu2LuuDmE-E5_kxv1H4Bsr7q/view?usp=drive_link',
  };

  static const _assetBase = 'https://etba3ly-dm.com/';
  static const _reviewKey = 'portfolio_review_last_submit';
  static const _reviewCooldown = Duration(minutes: 5);

  late final AnimationController _bgController;
  final _scrollController = ScrollController();

  /// Marks where a gallery's industries / specialties / samples start.
  final _galleryContentKey = GlobalKey();
  final _commentController = TextEditingController();
  final _customIndustryController = TextEditingController();
  final _customPhoneController = TextEditingController();
  final _dio = Dio();

  double _mainScrollOffset = 0;
  double _specialtyScrollOffset = 0;

  // API data
  List<PortfolioIndustry> _industries = [];
  bool _industriesLoading = true;
  String _industriesError = '';

  PortfolioIndustry? _industry;
  PortfolioSpecialty? _specialty;
  int _photosVisible = 6;
  int _reelsVisible = 6;
  int _rating = 0;
  bool _reviewSubmitting = false;
  bool _reviewSubmitted = false;
  bool _reviewError = false;
  bool _customIndustrySubmitting = false;
  bool _customIndustrySubmitted = false;
  String _customIndustryError = '';

  /// Bumped by pull-to-refresh on the hub to reload the Google reviews.
  int _reviewsGeneration = 0;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    if (_isGallery) {
      _loadIndustries();
    } else {
      _loadReviewCooldown();
    }
  }

  Future<void> _loadIndustries({bool forceRefresh = false}) async {
    if (forceRefresh) PortfolioRepository.clearCache();
    if (!mounted) return;
    setState(() {
      _industriesLoading = true;
      _industriesError = '';
    });
    try {
      final industries = await PortfolioRepository.getIndustries();
      if (!mounted) return;
      setState(() {
        _industries = industries;
        _industriesLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _industriesError = e.toString();
        _industriesLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    _customIndustryController.dispose();
    _customPhoneController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  bool get _isDirectMode => _industry != null && _industry!.specialties.isEmpty;

  bool get _isGallery => widget.kind != null;

  bool get _isReels => widget.kind == ExpertiseGalleryKind.reels;

  bool _hasKind(List<PortfolioMedia> photos, List<PortfolioMedia> reels) =>
      (_isReels ? reels : photos).isNotEmpty;

  /// Industries with at least one sample of this gallery's kind.
  List<PortfolioIndustry> get _sampleIndustries => [
        for (final industry in _industries)
          if (_hasKind(industry.photos, industry.reels) ||
              industry.specialties.any(
                (specialty) => _hasKind(specialty.photos, specialty.reels),
              ))
            industry,
      ];

  List<PortfolioSpecialty> get _sampleSpecialties => [
        for (final specialty
            in _industry?.specialties ?? const <PortfolioSpecialty>[])
          if (_hasKind(specialty.photos, specialty.reels)) specialty,
      ];

  List<PortfolioMedia> get _photos {
    if (_specialty != null) return _specialty!.photos;
    if (_isDirectMode) return _industry!.photos;
    return [];
  }

  List<PortfolioMedia> get _reels {
    if (_specialty != null) return _specialty!.reels;
    if (_isDirectMode) return _industry!.reels;
    return [];
  }

  String _url(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Uri.encodeFull(path);
    }
    return Uri.encodeFull('$_assetBase$path');
  }

  Color _color(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  void _selectIndustry(PortfolioIndustry industry) {
    _mainScrollOffset =
        _scrollController.hasClients ? _scrollController.offset : 0;
    setState(() {
      _industry = industry;
      _specialty = null;
      _photosVisible = 6;
      _reelsVisible = 6;
    });
    _scrollToGalleryContent();
  }

  void _selectSpecialty(PortfolioSpecialty specialty) {
    _specialtyScrollOffset =
        _scrollController.hasClients ? _scrollController.offset : 0;
    setState(() {
      _specialty = specialty;
      _photosVisible = 6;
      _reelsVisible = 6;
    });
    _scrollToGalleryContent();
  }

  /// Like the website, bring the chosen industry / specialty into view just
  /// below the gallery header.
  void _scrollToGalleryContent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _galleryContentKey.currentContext;
      if (target == null || !target.mounted) return;
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _back() {
    final goingToMain = _specialty == null;
    setState(() {
      if (_specialty != null) {
        _specialty = null;
      } else {
        _industry = null;
      }
      _photosVisible = 6;
      _reelsVisible = 6;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = goingToMain ? _mainScrollOffset : _specialtyScrollOffset;
      _scrollController.jumpTo(
        target.clamp(0, _scrollController.position.maxScrollExtent),
      );
    });
  }

  /// Like the website, the preview opens the portfolio on Google Drive.
  Future<void> _viewClassPdf(BuildContext context, String key) =>
      openExpertiseLink(context, _classPreviews[key]!);

  /// Saves the bundled portfolio PDF (Downloads on Android, the app's
  /// documents on iOS) and offers to open it.
  Future<void> _downloadClassPdf(BuildContext context, String file) async {
    final messenger = ScaffoldMessenger.of(context);
    final openLabel = context.locale.languageCode == 'ar' ? 'فتح' : 'Open';
    try {
      final bytes = await rootBundle.load('assets/files/portfolio/$file');
      final dir = Platform.isAndroid
          ? await getDownloadsDirectory() ??
              await getApplicationDocumentsDirectory()
          : await getApplicationDocumentsDirectory();
      final outFile = File('${dir.path}/$file');
      await outFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      messenger.showSnackBar(
        SnackBar(
          content: Text('expertises.pdf_saved'.tr(args: [outFile.path])),
          action: SnackBarAction(
            label: openLabel,
            onPressed: () =>
                OpenFilex.open(outFile.path, type: 'application/pdf'),
          ),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text('expertises.pdf_failed'.tr())),
      );
    }
  }

  Future<void> _loadReviewCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt(_reviewKey);
    if (last == null) return;
    final elapsed = DateTime.now().millisecondsSinceEpoch - last;
    if (elapsed < _reviewCooldown.inMilliseconds && mounted) {
      setState(() => _reviewSubmitted = true);
    }
  }

  Future<void> _submitReview() async {
    if (_rating == 0 || _reviewSubmitting || _reviewSubmitted) return;

    setState(() {
      _reviewSubmitting = true;
      _reviewError = false;
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'https://api.web3forms.com/submit',
        data: {
          'access_key': 'ebfc072d-a69e-4ff5-bd13-03418fda2c53',
          'name': 'Portfolio Review',
          'email': 'review@portfolio',
          'service': 'Portfolio Rating',
          'message':
              'Rating: $_rating/5\n\n${_commentController.text.trim().isEmpty ? 'No comment provided.' : _commentController.text.trim()}',
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );
      if (response.statusCode == null || response.statusCode! >= 400) {
        throw Exception('Review API failed');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_reviewKey, DateTime.now().millisecondsSinceEpoch);
      if (!mounted) return;
      setState(() {
        _reviewSubmitted = true;
        _reviewSubmitting = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _reviewError = true;
        _reviewSubmitting = false;
      });
    }
  }

  Future<void> _submitCustomIndustry() async {
    final industry = _customIndustryController.text.trim();
    final phone = _customPhoneController.text.trim();

    if (industry.isEmpty || phone.isEmpty) {
      setState(
        () => _customIndustryError = 'auto.t_1d4e9c9bd6'.tr(),
      );
      return;
    }
    if (_customIndustrySubmitting || _customIndustrySubmitted) return;

    setState(() {
      _customIndustrySubmitting = true;
      _customIndustryError = '';
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'https://api.web3forms.com/submit',
        data: {
          'access_key': 'eef10318-b29e-4033-b122-535fe44348f1',
          'name': 'Custom Industry Request',
          'message': 'Business: $industry\nPhone: $phone',
          'service': 'Custom Industry',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == null || response.statusCode! >= 400) {
        throw Exception('Custom industry API failed');
      }

      if (!mounted) return;
      setState(() {
        _customIndustrySubmitted = true;
        _customIndustrySubmitting = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _customIndustrySubmitting = false;
        _customIndustryError = 'auto.t_ecb1301c7e'.tr();
      });
    }
  }

  void _openReel(PortfolioMedia media) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ReelDialog(
        url: _url(media.videoUrl),
        title: context.locale.languageCode == 'ar' ? media.titleAr : media.titleEn,
      ),
    );
  }

  void _openImage(PortfolioMedia media) {
    final images = media.galleryImages.isEmpty
        ? <String>[media.thumbnail]
        : media.galleryImages;
    final title =
        context.locale.languageCode == 'ar' ? media.titleAr : media.titleEn;
    showEtbalyImageViewer(
      context,
      images: [
        for (final image in images)
          EtbalyViewerImage(
            provider: CachedNetworkImageProvider(_url(image)),
            title: title,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    final children =
        kind == null ? _hubChildren(context) : _galleryChildren(context, kind);
    return PopScope(
      // In a gallery, back leaves the specialty / industry first.
      canPop: _industry == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _industry != null) _back();
      },
      child: Scaffold(
        backgroundColor: context.etbalyColors.bgMain,
        body: SafeArea(
          top: false,
          child: AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return CustomPaint(
                painter: _ExpertiseBackgroundPainter(
                  _bgController.value,
                  bgTop: context.etbalyColors.bgMain,
                  bgMid: context.etbalyColors.bgSecondary,
                ),
                child: child,
              );
            },
            child: RefreshIndicator(
              onRefresh: kind == null
                  ? () async => setState(() => _reviewsGeneration++)
                  : () => _loadIndustries(forceRefresh: true),
              color: context.etbalyColors.primary,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 34.h),
                    // Keep the gallery anchor mounted when an industry changes
                    // while the header is off screen. The hub remains lazy.
                    sliver: kind == null
                        ? SliverList(
                            delegate: SliverChildListDelegate(children),
                          )
                        : SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: children,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _hubChildren(BuildContext context) {
    return [
      const _ExpertiseHero(),
      SizedBox(height: 34.h),
      _ClassPdfSection(
        onPreview: (key) => _viewClassPdf(context, key),
        onDownload: (file) => _downloadClassPdf(context, file),
      ),
      SizedBox(height: 40.h),
      const _PlatformsHeading(),
      SizedBox(height: 24.h),
      for (var i = 0; i < expertiseCards.length; i++) ...[
        if (i > 0) SizedBox(height: 18.h),
        _PlatformCard(card: expertiseCards[i], index: i),
      ],
      SizedBox(height: 40.h),
      _ReviewSection(
        rating: _rating,
        controller: _commentController,
        submitting: _reviewSubmitting,
        submitted: _reviewSubmitted,
        error: _reviewError,
        onRating: (value) => setState(() => _rating = value),
        onSubmit: _submitReview,
      ),
      SizedBox(height: 16.h),
      GoogleReviewsSection(key: ValueKey(_reviewsGeneration)),
      SizedBox(height: 16.h),
      const _ExpertiseCtaSection(),
    ];
  }

  List<Widget> _galleryChildren(
    BuildContext context,
    ExpertiseGalleryKind kind,
  ) {
    final reels = kind == ExpertiseGalleryKind.reels;
    final industry = _industry;
    return [
      _GalleryHeader(isReels: reels),
      SizedBox(height: 18.h),
      _KindNav(isReels: reels),
      SizedBox(key: _galleryContentKey, height: 24.h),
      if (industry == null) ...[
        if (_industriesLoading)
          const _IndustriesLoadingShimmer()
        else if (_industriesError.isNotEmpty)
          _IndustriesErrorState(onRetry: () => _loadIndustries())
        else
          _IndustriesSection(
            industries: _sampleIndustries,
            imageIndexOf: _industries.indexOf,
            description: (reels
                    ? 'expertises.video_industries_desc'
                    : 'expertises.design_industries_desc')
                .tr(),
            onSelect: _selectIndustry,
            colorOf: _color,
          ),
        SizedBox(height: 26.h),
        _CustomIndustrySection(
          industryController: _customIndustryController,
          phoneController: _customPhoneController,
          submitting: _customIndustrySubmitting,
          submitted: _customIndustrySubmitted,
          error: _customIndustryError,
          onChanged: () {
            if (_customIndustryError.isNotEmpty) {
              setState(() => _customIndustryError = '');
            }
          },
          onSubmit: _submitCustomIndustry,
        ),
      ] else if (!_isDirectMode && _specialty == null) ...[
        _Breadcrumb(
          title: industry.localizedName(context),
          subtitle: (reels
                  ? 'expertises.video_specialty_desc'
                  : 'expertises.design_specialty_desc')
              .tr(),
          onBack: _back,
        ),
        SizedBox(height: 18.h),
        _SpecialtiesSection(
          industry: industry,
          specialties: _sampleSpecialties,
          isReels: reels,
          onSelect: _selectSpecialty,
          colorOf: _color,
        ),
      ] else ...[
        _Breadcrumb(
          title: _specialty?.localizedName(context) ??
              industry.localizedName(context),
          subtitle: industry.localizedName(context),
          onBack: _back,
        ),
        SizedBox(height: 18.h),
        _MediaSection(
          isReels: reels,
          items: reels ? _reels : _photos,
          visible: reels ? _reelsVisible : _photosVisible,
          categoryNameAr: _specialty?.nameAr ?? industry.nameAr,
          categoryNameEn: _specialty?.nameEn ?? industry.nameEn,
          onMore: () => setState(() {
            if (reels) {
              _reelsVisible = math.min(_reelsVisible + 6, _reels.length);
            } else {
              _photosVisible = math.min(_photosVisible + 6, _photos.length);
            }
          }),
          onLess: () => setState(() {
            _photosVisible = 6;
            _reelsVisible = 6;
          }),
          onImage: _openImage,
          onReel: _openReel,
          colorOf: _color,
          assetOf: _url,
        ),
      ],
      SizedBox(height: 26.h),
      const _ExpertiseCtaSection(),
    ];
  }
}

// ─── Expertise hub ───────────────────────────────────────────────────────────

/// Badge, two-line title, intro and the four statistic artworks.
class _ExpertiseHero extends StatelessWidget {
  const _ExpertiseHero();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final titleStyle = context.textTheme.headlineMedium?.copyWith(
      color: colors.textMain,
      fontWeight: FontWeight.w900,
      height: 1.45,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -140.h,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: Container(
                width: 460.r,
                height: 460.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.gold.withValues(alpha: 0.12),
                      colors.gold.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: 10.h),
            _SectionBadge(
              icon: FontAwesomeIcons.images,
              label: 'expertises.hero_badge'.tr(),
            ),
            SizedBox(height: 18.h),
            Text(
              'expertises.hero_title'.tr(),
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.goldLight, colors.gold, colors.goldDark],
              ).createShader(bounds),
              child: Text(
                'expertises.hero_title_highlight'.tr(),
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'expertises.hero_desc'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: colors.textMuted,
                height: 2,
              ),
            ),
            SizedBox(height: 28.h),
            Semantics(
              container: true,
              label: 'expertises.stats_label'.tr(),
              child: Column(
                children: [
                  for (var row = 0; row < 2; row++) ...[
                    if (row > 0) SizedBox(height: 12.r),
                    Row(
                      children: [
                        for (var col = 0; col < 2; col++) ...[
                          if (col > 0) SizedBox(width: 12.r),
                          Expanded(
                            child: _StatTile(
                              stat: expertiseStats[row * 2 + col],
                              index: row * 2 + col,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .slideY(begin: 0.06);
  }
}

/// One hero number. The value and its label are drawn into the artwork.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat, required this.index});

  final ExpertiseStat stat;
  final int index;

  @override
  Widget build(BuildContext context) {
    final arabic = context.locale.languageCode == 'ar';
    final width = (MediaQuery.sizeOf(context).width - 36.w - 12.r) / 2;
    final pixels = width * MediaQuery.devicePixelRatioOf(context);
    return ExpertiseArtworkTile(
      imageUrl: stat.artworkUrl(
        arabic: arabic,
        dark: context.isDarkMode,
        pixelWidth: pixels,
      ),
      decodeWidth: pixels.round(),
      aspectRatio: 1,
      radius: 18.r,
      accent: const Color(0xFFEDCB78),
      secondary: const Color(0xFFB79AEA),
      motion: ExpertiseTileMotion.stat,
      phase: index * 0.23,
      semanticLabel: '${stat.value} ${arabic ? stat.labelAr : stat.labelEn}',
    );
  }
}

/// "كل منصة ليها طريقتها. وإحنا فاهمينها."
class _PlatformsHeading extends StatelessWidget {
  const _PlatformsHeading();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionBadge(
          icon: FontAwesomeIcons.shapes,
          label: 'expertises.platforms_badge'.tr(),
        ),
        SizedBox(height: 12.h),
        Text(
          'expertises.platforms_title'.tr(),
          style: context.textTheme.headlineSmall?.copyWith(
            color: colors.textMain,
            fontWeight: FontWeight.w900,
            height: 1.6,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'expertises.platforms_desc'.tr(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.textMuted,
            height: 2,
          ),
        ),
      ],
    );
  }
}

/// A platform artwork card; cards with samples open their samples page.
class _PlatformCard extends StatelessWidget {
  const _PlatformCard({required this.card, required this.index});

  final ExpertiseCard card;
  final int index;

  @override
  Widget build(BuildContext context) {
    final arabic = context.locale.languageCode == 'ar';
    final width = MediaQuery.sizeOf(context).width - 36.w;
    final pixels = width * MediaQuery.devicePixelRatioOf(context);
    final route = card.route;
    final title = arabic ? card.titleAr : card.titleEn;
    final description = arabic ? card.descriptionAr : card.descriptionEn;
    return ExpertiseArtworkTile(
      imageUrl: card.artworkUrl(
        arabic: arabic,
        dark: context.isDarkMode,
        pixelWidth: pixels,
      ),
      decodeWidth: pixels.round(),
      aspectRatio: 3 / 2,
      radius: 21.r,
      padding: 2,
      borderOpacity: 0.78,
      accent: card.accent,
      secondary: card.secondary,
      motion: ExpertiseTileMotion.card,
      phase: (index * 0.137) % 1,
      semanticLabel: route == null
          ? '$title\n$description'
          : '${'expertises.open_samples'.tr()}: $title\n$description',
      onTap: route == null ? null : () => context.go(route),
    );
  }
}

// ─── Design / video galleries ────────────────────────────────────────────────

/// Back link, gallery title and what the gallery contains.
class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader({required this.isReels});

  final bool isReels;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Column(
      children: [
        const ExpertiseBackLink(),
        SizedBox(height: 22.h),
        Text(
          (isReels ? 'expertises.video_samples' : 'expertises.design_samples')
              .tr(),
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall?.copyWith(
            color: colors.textMain,
            fontWeight: FontWeight.w900,
            height: 1.4,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          (isReels
                  ? 'expertises.video_industries_desc'
                  : 'expertises.design_industries_desc')
              .tr(),
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.textMuted,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

/// Switch between the design and the video gallery.
class _KindNav extends StatelessWidget {
  const _KindNav({required this.isReels});

  final bool isReels;

  @override
  Widget build(BuildContext context) {
    final gold = context.etbalyColors.gold;
    return Semantics(
      container: true,
      label: 'expertises.samples_label'.tr(),
      child: Row(
        children: [
          Expanded(
            child: ExpertiseChoiceButton(
              label: 'expertises.design_samples'.tr(),
              icon: FontAwesomeIcons.penNib,
              active: !isReels,
              fill: true,
              maxLines: 2,
              accent: gold,
              onTap: () {
                if (isReels) context.go(AppRoutes.expertiseDesigns);
              },
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: ExpertiseChoiceButton(
              label: 'expertises.video_samples'.tr(),
              icon: FontAwesomeIcons.clapperboard,
              active: isReels,
              fill: true,
              maxLines: 2,
              accent: gold,
              onTap: () {
                if (!isReels) context.go(AppRoutes.expertiseReels);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassPdfSection extends StatelessWidget {
  const _ClassPdfSection({
    required this.onPreview,
    required this.onDownload,
  });

  final Future<void> Function(String key) onPreview;
  final Future<void> Function(String file) onDownload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: 'expertises.company_portfolio'.tr(),
          desc: 'expertises.design_collections_desc'.tr(),
        ),
        SizedBox(height: 18.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final cardWidth =
                wide ? (constraints.maxWidth - 22) / 2 : constraints.maxWidth;
            return Wrap(
              spacing: 22.r,
              runSpacing: 16.r,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _ClassCard(
                    title: 'Class A',
                    desc: 'expertises.design_collection_desc'.tr(),
                    icon: FontAwesomeIcons.crown,
                    color: const Color(0xFFD4AF37),
                    pillColor: const Color(0xFFFF3D3D),
                    isBlue: false,
                    onTap: () => onPreview('classA'),
                    onDownload: () => onDownload('Class_A.pdf'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _ClassCard(
                    title: 'Class B',
                    desc: 'expertises.design_collection_desc'.tr(),
                    icon: FontAwesomeIcons.gem,
                    color: const Color(0xFF63B3ED),
                    pillColor: const Color(0xFF3D70FF),
                    isBlue: true,
                    onTap: () => onPreview('classB'),
                    onDownload: () => onDownload('Class_B.pdf'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.pillColor,
    required this.isBlue,
    required this.onTap,
    required this.onDownload,
  });

  final String title;
  final String desc;
  final FaIconData icon;
  final Color color;
  final Color pillColor;
  final bool isBlue;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: color.withValues(alpha: 0.36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 26.r,
            offset: Offset(0.w, 14.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _AnimatedPdfPreview(
                color: color,
                isBlue: isBlue,
                pillColor: pillColor,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 18.h),
            decoration: BoxDecoration(
              color: colors.bgSubtle,
              border: Border(
                top: BorderSide(
                  color: colors.primaryLight.withValues(alpha: 0.16),
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withValues(alpha: 0.38)),
                  ),
                  child: Center(
                    child: FaIcon(icon, color: color, size: 18.sp),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.textMuted,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(color: colors.primaryLight.withValues(alpha: 0.16)),
                SizedBox(height: 8.h),
                _TextLinkButton(
                  label: 'expertises.preview_pdf'.tr(),
                  icon: Icons.visibility_rounded,
                  color: color,
                  onTap: onTap,
                ),
                SizedBox(height: 14.h),
                _ActionButton(
                  label: 'expertises.download_pdf'.tr(),
                  icon: Icons.download_rounded,
                  color: color,
                  onTap: onDownload,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading shimmer while API fetches ────────────────────────────────────────

class _IndustriesLoadingShimmer extends StatelessWidget {
  const _IndustriesLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 140.w,
          height: 18.h,
          margin: EdgeInsets.only(bottom: 14.h),
          decoration: BoxDecoration(
            color: c.bgSubtle,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: List.generate(8, (i) {
            return Container(
              width: (context.width - 36.w - 12.w) / 2,
              height: 80.h,
              decoration: BoxDecoration(
                color: c.bgSubtle,
                borderRadius: BorderRadius.circular(16.r),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─── Error state with retry ───────────────────────────────────────────────────

class _IndustriesErrorState extends StatelessWidget {
  const _IndustriesErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.r),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: c.borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, color: c.textMuted, size: 42.sp),
          SizedBox(height: 12.h),
          Text(
            isAr
                ? 'تعذّر تحميل النماذج'
                : 'Could not load the samples',
            style: TextStyle(
              color: c.textMain,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            isAr
                ? 'تحقق من الإنترنت وحاول مجدداً'
                : 'Check your connection and try again',
            style: TextStyle(color: c.textMuted, fontSize: 13.sp),
          ),
          SizedBox(height: 18.h),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh_rounded, size: 18.sp),
            label: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
            style: OutlinedButton.styleFrom(
              foregroundColor: c.primary,
              side: BorderSide(color: c.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Industries grid ──────────────────────────────────────────────────────────

class _IndustriesSection extends StatelessWidget {
  const _IndustriesSection({
    required this.industries,
    required this.imageIndexOf,
    required this.description,
    required this.onSelect,
    required this.colorOf,
  });

  final List<PortfolioIndustry> industries;

  /// Position in the full industry list, which numbers the industry images.
  final int Function(PortfolioIndustry industry) imageIndexOf;
  final String description;
  final ValueChanged<PortfolioIndustry> onSelect;
  final Color Function(String hex) colorOf;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          _SectionHeader(
            eyebrow: 'expertises.choose_industry'.tr(),
            title: 'expertises.industries_title'.tr(),
            desc: description,
            icon: Icons.grid_view_rounded,
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: industries.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.r,
              crossAxisSpacing: 10.r,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final industry = industries[index];
              return _IndustryCard(
                industry: industry,
                index: imageIndexOf(industry),
                color: colorOf(industry.accentColor),
                onTap: () => onSelect(industry),
              )
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: index * 24))
                  .slideY(begin: 0.08);
            },
          ),
        ],
      ),
    );
  }
}

class _SpecialtiesSection extends StatelessWidget {
  const _SpecialtiesSection({
    required this.industry,
    required this.specialties,
    required this.isReels,
    required this.onSelect,
    required this.colorOf,
  });

  final PortfolioIndustry industry;
  final List<PortfolioSpecialty> specialties;
  final bool isReels;
  final ValueChanged<PortfolioSpecialty> onSelect;
  final Color Function(String hex) colorOf;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          _SectionHeader(
            eyebrow: industry.localizedName(context),
            title: 'expertises.choose_specialty'.tr(),
            desc: (isReels
                    ? 'expertises.video_specialty_desc'
                    : 'expertises.design_specialty_desc')
                .tr(),
            icon: expertiseIcon(industry.icon),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specialties.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.r,
              crossAxisSpacing: 10.r,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final specialty = specialties[index];
              return _SpecialtyCard(
                specialty: specialty,
                isReels: isReels,
                color: colorOf(specialty.accentColor),
                onTap: () => onSelect(specialty),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CustomIndustrySection extends StatelessWidget {
  const _CustomIndustrySection({
    required this.industryController,
    required this.phoneController,
    required this.submitting,
    required this.submitted,
    required this.error,
    required this.onChanged,
    required this.onSubmit,
  });

  final TextEditingController industryController;
  final TextEditingController phoneController;
  final bool submitting;
  final bool submitted;
  final String error;
  final VoidCallback onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: submitted
              ? const Color(0xFF25D366).withValues(alpha: 0.42)
              : colors.primaryLight.withValues(alpha: 0.24),
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 24.r,
            offset: Offset(0.w, 12.h),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: submitted
            ? const _CustomIndustrySent()
            : Column(
                key: const ValueKey('custom-form'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 34.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: colors.primaryLight.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.primaryLight.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Icon(
                          Icons.help_rounded,
                          color: colors.primaryLight,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'auto.t_7e933237c8'.tr(),
                              textAlign: TextAlign.right,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: colors.textMain,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'auto.t_40c8381378'.tr(),
                              textAlign: TextAlign.right,
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
                  SizedBox(height: 16.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 620;
                      final fields = [
                        _CustomIndustryInput(
                          controller: industryController,
                          hint: 'auto.t_6930dd2f9f'.tr(),
                          icon: Icons.work_rounded,
                          iconColor: colors.textMuted,
                          submitting: submitting,
                          hasError: error.isNotEmpty &&
                              industryController.text.trim().isEmpty,
                          onChanged: onChanged,
                          onSubmit: onSubmit,
                        ),
                        _CustomIndustryInput(
                          controller: phoneController,
                          hint: 'auto.t_1b5839271a'.tr(),
                          icon: FontAwesomeIcons.whatsapp,
                          iconColor: const Color(0xFF25D366),
                          submitting: submitting,
                          hasError: error.isNotEmpty &&
                              phoneController.text.trim().isEmpty,
                          keyboardType: TextInputType.phone,
                          onChanged: onChanged,
                          onSubmit: onSubmit,
                        ),
                      ];

                      if (!wide) {
                        return Column(
                          children: [
                            fields[0],
                            SizedBox(height: 10.h),
                            fields[1],
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: fields[0]),
                          SizedBox(width: 12.w),
                          Expanded(child: fields[1]),
                        ],
                      );
                    },
                  ),
                  if (error.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(
                          Icons.error_rounded,
                          color: const Color(0xFFFF6B6B),
                          size: 16.sp,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            error,
                            textAlign: TextAlign.right,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: const Color(0xFFFF6B6B),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 14.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: _CustomSubmitButton(
                      submitting: submitting,
                      onTap: onSubmit,
                    ),
                  ),
                ],
              ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 450)).slideY(
          begin: 0.05,
        );
  }
}

class _CustomIndustryInput extends StatelessWidget {
  const _CustomIndustryInput({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.submitting,
    required this.hasError,
    required this.onChanged,
    required this.onSubmit,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final Object icon;
  final Color iconColor;
  final bool submitting;
  final bool hasError;
  final TextInputType? keyboardType;
  final VoidCallback onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: hasError
              ? const Color(0xFFFF6B6B)
              : colors.primaryLight.withValues(alpha: 0.32),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: controller,
          enabled: !submitting,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          onChanged: (_) => onChanged(),
          textAlign: TextAlign.right,
          style: TextStyle(
            color: colors.textMain,
            fontWeight: FontWeight.w800,
            fontSize: 13.sp,
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: colors.textMuted.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
            // FaIcon does not center itself; the prefix slot is a 48px minimum
            // box, so without Center the glyph sits in its top corner.
            prefixIcon: icon is FaIconData
                ? Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: FaIcon(icon as FaIconData, color: iconColor, size: 18.sp),
                  )
                : Icon(icon as IconData, color: iconColor, size: 18.sp),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomSubmitButton extends StatelessWidget {
  const _CustomSubmitButton({
    required this.submitting,
    required this.onTap,
  });

  final bool submitting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The shadow lives on a DecoratedBox outside the Material: `Ink` paints
    // inside the Material's bounds and would clip it into a rectangle.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x448B3DFF),
            blurRadius: 22.r,
            offset: Offset(0.w, 10.h),
          ),
        ],
      ),
      child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: submitting ? null : onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          width: 276.w,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            gradient: const LinearGradient(
              colors: [Color(0xFFC9A227), Color(0xFF8B3DFF)],
            ),
          ),
          child: Center(
            child: submitting
                ? SizedBox(
                    width: 18.w,
                    height: 18.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.r,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'auto.t_5ee2a083df'.tr(),
                        style: context.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      ),
    );
  }
}

class _CustomIndustrySent extends StatelessWidget {
  const _CustomIndustrySent();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Column(
      key: const ValueKey('custom-sent'),
      children: [
        Container(
          width: 46.w,
          height: 46.h,
          decoration: BoxDecoration(
            color: const Color(0xFF25D366).withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.rocket_launch_rounded,
            color: Color(0xFF25D366),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'auto.t_f8e81a2053'.tr(),
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.textMain,
            height: 1.7,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({
    required this.isReels,
    required this.items,
    required this.visible,
    required this.categoryNameAr,
    required this.categoryNameEn,
    required this.onMore,
    required this.onLess,
    required this.onImage,
    required this.onReel,
    required this.colorOf,
    required this.assetOf,
  });

  final bool isReels;
  final List<PortfolioMedia> items;
  final int visible;
  final String categoryNameAr;
  final String categoryNameEn;
  final VoidCallback onMore;
  final VoidCallback onLess;
  final ValueChanged<PortfolioMedia> onImage;
  final ValueChanged<PortfolioMedia> onReel;
  final Color Function(String hex) colorOf;
  final String Function(String path) assetOf;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final shown = items.take(visible).toList();

    return _Panel(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  (isReels
                          ? 'expertises.video_samples'
                          : 'expertises.design_samples')
                      .tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: colors.borderColor),
                ),
                child: Text(
                  '${items.length}',
                  style: TextStyle(color: colors.textMuted, fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (items.isEmpty)
            _EmptyState(isReels: isReels)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shown.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.r,
                crossAxisSpacing: 10.r,
                childAspectRatio: 0.74,
              ),
              itemBuilder: (context, index) {
                final item = shown[index];
                return _MediaCard(
                  media: item,
                  index: index,
                  isReel: isReels,
                  color: colorOf(item.accentColor),
                  imagePath: assetOf(item.thumbnail),
                  categoryNameAr: categoryNameAr,
                  categoryNameEn: categoryNameEn,
                  onTap: () => isReels ? onReel(item) : onImage(item),
                );
              },
            ),
          if (visible < items.length || visible > 6) ...[
            SizedBox(height: 16.h),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                if (visible < items.length)
                  _ActionButton(
                    label: 'expertises.show_more'.tr(),
                    icon: Icons.add_circle_outline_rounded,
                    color: colors.gold,
                    onTap: onMore,
                  ),
                if (visible > 6)
                  _ActionButton(
                    label: 'expertises.show_less'.tr(),
                    icon: Icons.remove_circle_outline_rounded,
                    color: colors.textMuted,
                    onTap: onLess,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.rating,
    required this.controller,
    required this.submitting,
    required this.submitted,
    required this.error,
    required this.onRating,
    required this.onSubmit,
  });

  final int rating;
  final TextEditingController controller;
  final bool submitting;
  final bool submitted;
  final bool error;
  final ValueChanged<int> onRating;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return _Panel(
      child: Column(
        children: [
          _SectionHeader(
            eyebrow: 'auto.t_db138f8cff'.tr(),
            title: 'auto.t_c426dbb874'.tr(),
            desc: 'auto.t_5e7705fe07'.tr(),
            icon: Icons.star_rounded,
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final value = index + 1;
              return IconButton(
                onPressed: submitted ? null : () => onRating(value),
                icon: Icon(
                  value <= rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: colors.gold,
                  size: 32.sp,
                ),
              );
            }),
          ),
          SizedBox(height: 10.h),
          Text(
            'auto.t_1949f29a1f'.tr(),
            style: context.textTheme.labelMedium?.copyWith(
              color: colors.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (rating > 0 && !submitted) ...[
            SizedBox(height: 14.h),
            TextField(
              controller: controller,
              minLines: 3,
              maxLines: 4,
              style: TextStyle(color: colors.textMain),
              decoration: InputDecoration(
                hintText: 'auto.t_bf35722b2f'.tr(),
                hintStyle: TextStyle(color: colors.textMuted),
                filled: true,
                fillColor: colors.bgSubtle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
              ),
            ),
          ],
          SizedBox(height: 14.h),
          if (submitted)
            _StatusBox(
              text: 'auto.t_bc222f68bb'.tr(),
              color: const Color(0xFF68D391),
            )
          else if (rating > 0) ...[
            _ActionButton(
              label: submitting
                  ? 'auto.t_b303cc20c1'.tr()
                  : 'auto.t_4e932bac85'.tr(),
              icon: Icons.send_rounded,
              color: colors.gold,
              onTap: submitting ? () {} : onSubmit,
            ),
            if (error) ...[
              SizedBox(height: 10.h),
              _StatusBox(
                text: 'auto.t_e2879ed925'.tr(),
                color: const Color(0xFFFF6B6B),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _ExpertiseCtaSection extends StatelessWidget {
  const _ExpertiseCtaSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 42.h),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 30.r,
            offset: Offset(0.w, 16.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _SectionBadge(
            icon: Icons.rocket_launch_rounded,
            label: 'expertises.hero_badge'.tr(),
          ),
          SizedBox(height: 18.h),
          Text(
            'auto.t_845a30e13d'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'auto.t_9cda1ed5f2'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.55,
            ),
          ),
          SizedBox(height: 26.h),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999.r),
              boxShadow: [
                BoxShadow(
                  color: colors.gold.withValues(alpha: 0.26),
                  blurRadius: 24.r,
                  offset: Offset(0.w, 10.h),
                ),
              ],
            ),
            child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go(AppRoutes.contact),
              borderRadius: BorderRadius.circular(999.r),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: colors.gold,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      'auto.t_e822237be7'.tr(),
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideY(
          begin: 0.05,
        );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.etbalyColors.bgCard,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: context.etbalyColors.primaryLight.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(color: context.etbalyColors.cardShadow, blurRadius: 28.r),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.desc,
    this.eyebrow,
    this.icon,
  });

  final String? eyebrow;
  final String title;
  final String desc;
  final Object? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Column(
      children: [
        if (eyebrow != null && icon != null) ...[
          _SectionBadge(icon: icon!, label: eyebrow!),
          SizedBox(height: 12.h),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.titleLarge?.copyWith(
            color: colors.textMain,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: colors.textMuted,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _SectionBadge extends StatelessWidget {
  const _SectionBadge({required this.icon, required this.label});

  final Object icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final FaIconData faIcon)
            FaIcon(faIcon, color: colors.gold, size: 15.sp)
          else
            Icon(icon as IconData, color: colors.gold, size: 15.sp),
          SizedBox(width: 7.w),
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

class _IndustryCard extends StatelessWidget {
  const _IndustryCard({
    required this.industry,
    required this.index,
    required this.color,
    required this.onTap,
  });

  final PortfolioIndustry industry;
  final int index;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _IndustryImageButton(
      onTap: onTap,
      color: color,
      imagePath: 'assets/images/portfolio/industries/${index + 1}.webp',
      title: industry.localizedName(context),
    );
  }
}

class _IndustryImageButton extends StatelessWidget {
  const _IndustryImageButton({
    required this.onTap,
    required this.color,
    required this.imagePath,
    required this.title,
  });

  final VoidCallback onTap;
  final Color color;
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: context.etbalyColors.bgCard,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: color.withValues(alpha: 0.32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 24.r,
                offset: Offset(0.w, 12.h),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 20.r,
                    offset: Offset(4.w, 8.h),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _IndustryImageFallback(
                        color: color,
                        title: title,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(-1.2, -0.8),
                              end: const Alignment(1, 0.8),
                              colors: [
                                Colors.white.withValues(alpha: 0.18),
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.08),
                              ],
                              stops: const [0.0, 0.42, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndustryImageFallback extends StatelessWidget {
  const _IndustryImageFallback({
    required this.color,
    required this.title,
  });

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Container(
      color: color.withValues(alpha: 0.12),
      alignment: Alignment.center,
      padding: EdgeInsets.all(12.r),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleSmall?.copyWith(
          color: colors.textMain,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  const _SpecialtyCard({
    required this.specialty,
    required this.isReels,
    required this.color,
    required this.onTap,
  });

  final PortfolioSpecialty specialty;
  final bool isReels;
  final Color color;
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
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withValues(alpha: 0.24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon box
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11.r),
                  border: Border.all(color: color.withValues(alpha: 0.28)),
                ),
                child: Center(
                  child: FaIcon(expertiseIcon(specialty.icon),
                      color: color, size: 19.sp),
                ),
              ),
              const Spacer(),
              // Name
              Text(
                specialty.localizedName(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelLarge?.copyWith(
                  color: colors.textMain,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 6.h),
              // Badges row
              _SpecBadge(
                icon: isReels ? Icons.movie_rounded : Icons.image_rounded,
                label: (isReels
                        ? 'expertises.reels_count'
                        : 'expertises.photos_count')
                    .tr(
                  args: [
                    (isReels ? specialty.reels : specialty.photos)
                        .length
                        .toString(),
                  ],
                ),
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecBadge extends StatelessWidget {
  const _SpecBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: color),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({
    required this.media,
    required this.index,
    required this.isReel,
    required this.color,
    required this.imagePath,
    required this.categoryNameAr,
    required this.categoryNameEn,
    required this.onTap,
  });

  final PortfolioMedia media;
  final int index;
  final bool isReel;
  final Color color;
  final String imagePath;
  final String categoryNameAr;
  final String categoryNameEn;
  final VoidCallback onTap;

  static const _descsAr = [
    'تصميم احترافي في المجال',
    'إدارة محتوى مميز للعلامة',
    'حملة تسويقية قوية لزيادة التفاعل',
    'تصميم إبداعي يعكس هوية العلامة',
    'تطوير محتوى بصري احترافي',
    'استراتيجية سوشيال ميديا فعالة',
    'تصميم يعزز حضور العلامة التجارية',
    'حملة إعلانية موجهة للجمهور',
    'محتوى مبتكر يبرز قوة المجال',
    'تصميم جذاب يرفع معدل التفاعل',
  ];

  static const _descsEn = [
    'Professional design in the field',
    'Creative content strategy for the brand',
    'High-performing campaign for the field',
    'Brand-focused design for the audience',
    'Visual content development',
    'Effective social media strategy',
    'Engaging design for the audience',
    'Targeted campaign for the field',
    'Creative visuals for the field',
    'High engagement design',
  ];

  String _title(BuildContext context) {
    final num = index + 1;
    return context.locale.languageCode == 'ar'
        ? 'تصميم مميز $num'
        : 'Design Preview $num';
  }

  String _desc(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final name = isAr ? categoryNameAr : categoryNameEn;
    final list = isAr ? _descsAr : _descsEn;
    return '${list[index % list.length]} - $name';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withValues(alpha: 0.24)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imagePath,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => ColoredBox(
                        color: color.withValues(alpha: 0.12),
                        child: Icon(
                          isReel ? Icons.movie_rounded : Icons.image_rounded,
                          color: color,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.68),
                          ],
                        ),
                      ),
                    ),
                    if (isReel)
                      Center(
                        child: Container(
                          width: 48.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    Positioned(
                      right: 10.w,
                      bottom: 10.h,
                      child: _SmallPill(
                        icon:
                            isReel ? Icons.movie_rounded : Icons.image_rounded,
                        label: media.localizedTag(context),
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _desc(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: colors.textMuted,
                        height: 1.25,
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

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';
    return _Panel(
      child: Row(
        children: [
          _IconAction(
            icon: isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            color: colors.gold,
            onTap: onBack,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.textMuted,
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: color.withValues(alpha: 0.42)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextLinkButton extends StatelessWidget {
  const _TextLinkButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 7.w),
              Icon(icon, color: color, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.36)),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: context.etbalyColors.bgSubtle,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 5.w),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.etbalyColors.textMain,
              fontWeight: FontWeight.w900,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  const _StatusBox({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isReels});

  final bool isReels;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            isReels ? Icons.movie_rounded : Icons.photo_library_rounded,
            color: colors.gold,
            size: 30.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            (isReels ? 'expertises.no_reels_title' : 'expertises.no_photos_title')
                .tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            (isReels ? 'expertises.no_reels_desc' : 'expertises.no_photos_desc')
                .tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.62),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

// ── Star & Particle data ─────────────────────────────────────────
class _StarDot {
  _StarDot({
    required this.x,
    required this.y,
    required this.size,
    required this.delay,
  });
  final double x;
  final double y;
  final double size;
  final double delay;
}

class _ParticleDot {
  _ParticleDot({
    required this.x,
    required this.size,
    required this.delay,
  });
  final double x;
  final double size;
  final double delay;
}

// ── Stars painter ─────────────────────────────────────────────────
class _StarsPainter extends CustomPainter {
  _StarsPainter({
    required this.stars,
    required this.t,
    required this.color,
  });
  final List<_StarDot> stars;
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final phase = (t + s.delay) % 1.0;
      final alpha = (0.25 + 0.75 * math.sin(phase * math.pi)).clamp(0.0, 1.0);
      final sc = (0.8 + 0.45 * math.sin(phase * math.pi)).clamp(0.5, 1.5);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.size * sc * 0.5,
        Paint()..color = color.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter o) => o.t != t;
}

// ── Particles painter ─────────────────────────────────────────────
class _ParticlesPainter extends CustomPainter {
  _ParticlesPainter({
    required this.particles,
    required this.t,
    required this.color,
  });
  final List<_ParticleDot> particles;
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final eff = (t + p.delay) % 1.0;
      final double alpha;
      if (eff < 0.20) {
        alpha = eff / 0.20 * 0.7;
      } else if (eff < 0.80) {
        alpha = 0.7 - (eff - 0.20) / 0.60 * 0.3;
      } else {
        alpha = 0.4 * (1 - (eff - 0.80) / 0.20);
      }
      if (alpha < 0.01) continue;
      final sc = 0.5 + eff * 0.6;
      canvas.drawCircle(
        Offset(p.x * size.width, size.height - eff * size.height * 1.1),
        p.size * sc * 0.5,
        Paint()..color = color.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter o) => o.t != t;
}

// ── Animated PDF preview (logo floating, stars, orb, particles, shimmer) ──
class _AnimatedPdfPreview extends StatefulWidget {
  const _AnimatedPdfPreview({
    required this.color,
    required this.isBlue,
    required this.pillColor,
  });
  final Color color;
  final bool isBlue;
  final Color pillColor;

  @override
  State<_AnimatedPdfPreview> createState() => _AnimatedPdfPreviewState();
}

class _AnimatedPdfPreviewState extends State<_AnimatedPdfPreview>
    with TickerProviderStateMixin {
  static final _rng = math.Random(42);

  late final AnimationController _logoCtrl;
  late final AnimationController _orbCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _starCtrl;

  late final List<_StarDot> _stars;
  late final List<_ParticleDot> _particles;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    )..repeat(reverse: true);
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _stars = List.generate(
      14,
      (_) => _StarDot(
        x: _rng.nextDouble(),
        y: _rng.nextDouble() * 0.75,
        size: _rng.nextDouble() * 2.5 + 1.0,
        delay: _rng.nextDouble(),
      ),
    );
    _particles = List.generate(
      8,
      (_) => _ParticleDot(
        x: _rng.nextDouble(),
        size: _rng.nextDouble() * 4 + 2,
        delay: _rng.nextDouble(),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _orbCtrl.dispose();
    _shimmerCtrl.dispose();
    _particleCtrl.dispose();
    _starCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBlue = widget.isBlue;
    final accent = widget.color;
    final orbColor = isBlue ? const Color(0xFF90CDF4) : const Color(0xFFE8E0C8);
    final starColor = isBlue ? const Color(0xFFB4DCFF) : Colors.white;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Sky gradient ──────────────────────────────────────────
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isBlue
                  ? [
                      const Color(0xFF071A3E),
                      const Color(0xFF0B2A5A),
                      const Color(0xFF0D1B4A),
                    ]
                  : [
                      const Color(0xFF0A0E2A),
                      const Color(0xFF0D1540),
                      const Color(0xFF1A1040),
                    ],
              stops: const [0, 0.55, 1],
            ),
          ),
        ),

        // ── Ambient mid glow ──────────────────────────────────────
        Positioned(
          left: -30.w,
          bottom: -20.h,
          child: Container(
            width: 180.w,
            height: 110.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90.r),
              gradient: RadialGradient(
                colors: [accent.withValues(alpha: 0.09), Colors.transparent],
              ),
            ),
          ),
        ),

        // ── Stars ─────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _starCtrl,
          builder: (_, __) => CustomPaint(
            painter: _StarsPainter(
              stars: _stars,
              t: _starCtrl.value,
              color: starColor,
            ),
          ),
        ),

        // ── Orb (moon / blue gem) ─────────────────────────────────
        Positioned(
          top: 18.h,
          right: 18.w,
          child: AnimatedBuilder(
            animation: _orbCtrl,
            builder: (_, child) => Transform.translate(
              offset: Offset(
                0,
                Curves.easeInOut.transform(_orbCtrl.value) * -7,
              ),
              child: child,
            ),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: orbColor,
                boxShadow: [
                  BoxShadow(
                    color: orbColor.withValues(alpha: 0.22),
                    blurRadius: 36.r,
                    spreadRadius: 7.r,
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Rising particles ──────────────────────────────────────
        AnimatedBuilder(
          animation: _particleCtrl,
          builder: (_, __) => CustomPaint(
            painter: _ParticlesPainter(
              particles: _particles,
              t: _particleCtrl.value,
              color: accent,
            ),
          ),
        ),

        // ── Ground glow ───────────────────────────────────────────
        Positioned(
          bottom: 0.h,
          left: 0.w,
          right: 0.w,
          height: 55.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  accent.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // ── Floating logo ─────────────────────────────────────────
        Positioned.fill(
          child: Center(
            child: AnimatedBuilder(
              animation: _logoCtrl,
              builder: (_, child) {
                final eased = Curves.easeInOut.transform(_logoCtrl.value);
                return Transform(
                  transform: Matrix4.identity()
                    ..translateByDouble(0, eased * -8.0, 0, 1)
                    ..rotateZ((-0.5 + eased) * math.pi / 180),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: Container(
                width: 96.w,
                height: 96.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.55),
                      blurRadius: 24.r,
                      offset: Offset(0.w, 8.h),
                    ),
                    BoxShadow(
                      color: accent.withValues(alpha: 0.30),
                      blurRadius: 40.r,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10.r),
                child: Image.asset(AppAssets.logo),
              ),
            ),
          ),
        ),

        // ── Shimmer sweep on logo ─────────────────────────────────
        Positioned.fill(
          child: Center(
            child: SizedBox(
              width: 96.w,
              height: 96.h,
              child: AnimatedBuilder(
                animation: _shimmerCtrl,
                builder: (_, __) {
                  final t = _shimmerCtrl.value;
                  double opacity;
                  double dx;
                  if (t < 0.6) {
                    final n = t / 0.6;
                    dx = -60 + n * 120;
                    opacity = n < 0.3 ? n / 0.3 : 1 - (n - 0.3) / 0.3;
                  } else {
                    dx = 60;
                    opacity = 0;
                  }
                  return ClipOval(
                    child: Transform.translate(
                      offset: Offset(dx, 0),
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Color(0x2EFFFFFF),
                                Colors.transparent,
                              ],
                              stops: [0.3, 0.5, 0.7],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // ── PDF badge ─────────────────────────────────────────────
        PositionedDirectional(
          top: 12.h,
          end: 12,
          child: _SmallPill(
            icon: Icons.picture_as_pdf_rounded,
            label: 'PDF',
            color: widget.pillColor,
          ),
        ),
      ],
    );
  }
}

class _ExpertiseBackgroundPainter extends CustomPainter {
  _ExpertiseBackgroundPainter(this.progress, {required this.bgTop, required this.bgMid});

  final double progress;
  final Color bgTop;
  final Color bgMid;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [bgTop, bgMid, bgTop],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final grid = Paint()
      ..color = const Color(0x12D4AF37)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 58) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final line = Paint()
      ..color = const Color(0x44745CBA)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    final shift = math.sin(progress * math.pi * 2) * 22;
    canvas.drawLine(
      Offset(size.width * 0.08, 96 + shift),
      Offset(size.width * 0.72, 0),
      line,
    );
    canvas.drawLine(
      Offset(size.width, size.height * 0.36 + shift),
      Offset(size.width * 0.28, size.height * 0.62),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant _ExpertiseBackgroundPainter old) =>
      old.progress != progress || old.bgTop != bgTop;
}

// ── Reel Dialog ────────────────────────────────────────────────────────────
class _ReelDialog extends StatefulWidget {
  const _ReelDialog({required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<_ReelDialog> createState() => _ReelDialogState();
}

class _ReelDialogState extends State<_ReelDialog> {
  late VideoPlayerController _ctrl;
  bool _initialized = false;
  bool _hasError = false;
  String _errorMsg = '';
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _ctrl = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      httpHeaders: const {'Accept': '*/*'},
    );
    _ctrl.addListener(_onCtrlUpdate);
    _ctrl.initialize().then((_) {
      if (!mounted) return;
      if (_ctrl.value.hasError) {
        setState(() {
          _hasError = true;
          _errorMsg = _ctrl.value.errorDescription ?? 'تعذّر تشغيل الفيديو';
        });
        return;
      }
      setState(() => _initialized = true);
      _ctrl.play();
      _ctrl.setLooping(true);
    }).catchError((e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMsg = e.toString();
      });
    });
  }

  void _onCtrlUpdate() {
    if (_ctrl.value.hasError && !_hasError && mounted) {
      setState(() {
        _hasError = true;
        _errorMsg = _ctrl.value.errorDescription ?? 'تعذّر تشغيل الفيديو';
      });
    }
  }

  void _retry() {
    _ctrl.removeListener(_onCtrlUpdate);
    _ctrl.dispose();
    setState(() {
      _initialized = false;
      _hasError = false;
      _errorMsg = '';
      _dragValue = null;
    });
    _initController();
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onCtrlUpdate);
    _ctrl.dispose();
    super.dispose();
  }

  void _togglePlay() {
    _ctrl.value.isPlaying ? _ctrl.pause() : _ctrl.play();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0D0B18),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 16.w, 10.h),
            child: Row(
              children: [
                _CircleButton(
                  icon: Icons.close_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Video area
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(18.r)),
            child: _hasError
                ? AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: Colors.red.shade300, size: 40.sp),
                        SizedBox(height: 12.h),
                        Text(
                          _errorMsg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12.sp),
                        ),
                        SizedBox(height: 16.h),
                        TextButton.icon(
                          onPressed: _retry,
                          icon: const Icon(Icons.refresh_rounded,
                              color: Color(0xFFD4AF37)),
                          label: Text('إعادة المحاولة',
                              style: TextStyle(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 13.sp)),
                        ),
                      ],
                    ),
                  )
                : _initialized
                    ? AnimatedBuilder(
                        animation: _ctrl,
                        builder: (_, __) {
                          final total = _ctrl.value.duration;
                          final pos = _ctrl.value.position;
                          final sliderVal = _dragValue ??
                              (total.inMilliseconds > 0
                                  ? pos.inMilliseconds /
                                      total.inMilliseconds
                                  : 0.0);
                          final displayPos = _dragValue != null &&
                                  total.inMilliseconds > 0
                              ? Duration(
                                  milliseconds: (_dragValue! *
                                          total.inMilliseconds)
                                      .round())
                              : pos;

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: _togglePlay,
                                child: AspectRatio(
                                  aspectRatio: _ctrl.value.aspectRatio,
                                  child: VideoPlayer(_ctrl),
                                ),
                              ),
                              // Play/pause overlay
                              if (!_ctrl.value.isPlaying)
                                IgnorePointer(
                                  child: Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black
                                          .withValues(alpha: 0.55),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 36.sp,
                                    ),
                                  ),
                                ),
                              // Seek controls bar
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      12.w, 0, 12.w, 8.h),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black
                                            .withValues(alpha: 0.88),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 3.r,
                                          thumbShape:
                                              RoundSliderThumbShape(
                                                  enabledThumbRadius:
                                                      7.r),
                                          overlayShape:
                                              RoundSliderOverlayShape(
                                                  overlayRadius: 16.r),
                                          activeTrackColor:
                                              const Color(0xFFD4AF37),
                                          inactiveTrackColor: Colors.white
                                              .withValues(alpha: 0.3),
                                          thumbColor:
                                              const Color(0xFFD4AF37),
                                          overlayColor:
                                              const Color(0x33D4AF37),
                                        ),
                                        child: Slider(
                                          value:
                                              sliderVal.clamp(0.0, 1.0),
                                          onChangeStart: (v) => setState(
                                              () => _dragValue = v),
                                          onChanged: (v) => setState(
                                              () => _dragValue = v),
                                          onChangeEnd: (v) {
                                            _ctrl.seekTo(Duration(
                                              milliseconds: (v *
                                                      total
                                                          .inMilliseconds)
                                                  .round(),
                                            ));
                                            setState(
                                                () => _dragValue = null);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            Text(
                                              _fmt(displayPos),
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              _fmt(total),
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : const AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

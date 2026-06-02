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
  String localizedTitle(BuildContext context) =>
      context.locale.languageCode == 'en' ? titleEn : titleAr;

  String localizedDesc(BuildContext context) =>
      context.locale.languageCode == 'en' ? descEn : descAr;

  String localizedTag(BuildContext context) =>
      context.locale.languageCode == 'en' ? tagEn : tagAr;
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  static const _assetBase = 'https://etba3ly-dm.com/';
  static const _reviewKey = 'portfolio_review_last_submit';
  static const _reviewCooldown = Duration(minutes: 5);

  late final AnimationController _bgController;
  final _scrollController = ScrollController();
  final _commentController = TextEditingController();
  final _customIndustryController = TextEditingController();
  final _customPhoneController = TextEditingController();
  final _dio = Dio();

  double _mainScrollOffset = 0;
  double _specialtyScrollOffset = 0;

  PortfolioIndustry? _industry;
  PortfolioSpecialty? _specialty;
  String _tab = 'photos';
  int _photosVisible = 6;
  int _reelsVisible = 6;
  int _rating = 0;
  bool _reviewSubmitting = false;
  bool _reviewSubmitted = false;
  bool _reviewError = false;
  bool _customIndustrySubmitting = false;
  bool _customIndustrySubmitted = false;
  String _customIndustryError = '';

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _loadReviewCooldown();
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

  String _url(String path) => Uri.encodeFull('$_assetBase$path');

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
      _tab = 'photos';
      _photosVisible = 6;
      _reelsVisible = 6;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    });
  }

  void _selectSpecialty(PortfolioSpecialty specialty) {
    _specialtyScrollOffset =
        _scrollController.hasClients ? _scrollController.offset : 0;
    setState(() {
      _specialty = specialty;
      _tab = 'photos';
      _photosVisible = 6;
      _reelsVisible = 6;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
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
      _tab = 'photos';
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

  Future<void> _viewClassPdf(BuildContext context, String key) async {
    final fileNames = {
      'classA': 'Class_A.pdf',
      'classB': 'Class_B.pdf',
    };
    final fileName = fileNames[key]!;
    final bytes = await rootBundle.load('assets/files/portfolio/$fileName');
    final dir = await getTemporaryDirectory();
    final outFile = File('${dir.path}/$fileName');
    await outFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    await OpenFilex.open(outFile.path, type: 'application/pdf');
  }

  Future<void> _downloadClassPdf(BuildContext context, String file) async {
    final bytes = await rootBundle.load('assets/files/portfolio/$file');
    final downloadsDir = await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    final outFile = File('${downloadsDir.path}/$file');
    await outFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('auto.t_b6fed30510'.tr(args: [outFile.path]))),
    );
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
        title: media.localizedTitle(context),
      ),
    );
  }

  void _openImage(PortfolioMedia media) {
    final images = media.galleryImages.isEmpty
        ? <String>[media.thumbnail]
        : media.galleryImages;
    showDialog<void>(
      context: context,
      builder: (context) {
        var index = 0;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void next() =>
                setDialogState(() => index = (index + 1) % images.length);
            void prev() => setDialogState(
                  () => index = (index - 1 + images.length) % images.length,
                );

            return Dialog(
              insetPadding: EdgeInsets.all(14.r),
              backgroundColor: const Color(0xFF05040B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.78,
                      child: CachedNetworkImage(
                        imageUrl: _url(images[index]),
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image_rounded),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: _CircleButton(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    if (images.length > 1) ...[
                      Positioned(
                        top: 0.h,
                        bottom: 0.h,
                        left: 8.w,
                        child: Center(
                          child: _CircleButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: prev,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0.h,
                        bottom: 0.h,
                        right: 8.w,
                        child: Center(
                          child: _CircleButton(
                            icon: Icons.chevron_right_rounded,
                            onTap: next,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
            animation: _bgController,
            builder: (context, child) {
              return CustomPaint(
                painter: _PortfolioBackgroundPainter(_bgController.value),
                child: child,
              );
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 34.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (_industry == null) ...[
                        const _HeroSection(),
                        SizedBox(height: 26.h),
                        _ClassPdfSection(
                          onPreview: (key) => _viewClassPdf(context, key),
                          onDownload: (file) => _downloadClassPdf(
                            context,
                            file,
                          ),
                        ),
                        SizedBox(height: 26.h),
                        _IndustriesSection(
                          industries: portfolioIndustries,
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
                        SizedBox(height: 26.h),
                        _ReviewSection(
                          rating: _rating,
                          controller: _commentController,
                          submitting: _reviewSubmitting,
                          submitted: _reviewSubmitted,
                          error: _reviewError,
                          onRating: (value) => setState(() => _rating = value),
                          onSubmit: _submitReview,
                        ),
                        SizedBox(height: 26.h),
                        const _PortfolioCtaSection(),
                      ] else if (!_isDirectMode && _specialty == null) ...[
                        _Breadcrumb(
                          title: _industry!.localizedName(context),
                          subtitle: 'auto.t_0bcee321a1'.tr(),
                          onBack: _back,
                        ),
                        SizedBox(height: 18.h),
                        _SpecialtiesSection(
                          industry: _industry!,
                          onSelect: _selectSpecialty,
                          colorOf: _color,
                        ),
                      ] else ...[
                        _Breadcrumb(
                          title: _specialty?.localizedName(context) ??
                              _industry!.localizedName(context),
                          subtitle: _industry!.localizedName(context),
                          onBack: _back,
                        ),
                        SizedBox(height: 18.h),
                        _MediaSection(
                          tab: _tab,
                          photos: _photos,
                          reels: _reels,
                          photosVisible: _photosVisible,
                          reelsVisible: _reelsVisible,
                          onTab: (tab) => setState(() => _tab = tab),
                          onMorePhotos: () => setState(
                            () => _photosVisible =
                                math.min(_photosVisible + 6, _photos.length),
                          ),
                          onMoreReels: () => setState(
                            () => _reelsVisible =
                                math.min(_reelsVisible + 6, _reels.length),
                          ),
                          onImage: _openImage,
                          onReel: _openReel,
                          colorOf: _color,
                          assetOf: _url,
                        ),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 34.h, 14.w, 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF161024), Color(0xFF0B0814)],
        ),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: [
          _SectionBadge(
            icon: Icons.photo_library_rounded,
            label: 'auto.t_103315edfb'.tr(),
          ),
          SizedBox(height: 18.h),
          Text.rich(
            TextSpan(
              text: 'auto.t_e3b7664e6e'.tr(),
              children: [
                TextSpan(
                  text: 'auto.t_e97958863f'.tr(),
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
          SizedBox(height: 12.h),
          Text(
            'auto.t_5d859f21d3'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.6,
            ),
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  icon: Icons.work_rounded,
                  value: '+400K',
                  label: 'auto.t_707c299a84'.tr(),
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.favorite_rounded,
                  value: '5000+',
                  label: 'auto.t_8898da70bb'.tr(),
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.calendar_month_rounded,
                  value: '+12',
                  label: 'auto.t_f91a7c9817'.tr(),
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.star_rounded,
                  value: '93%',
                  label: 'auto.t_e111542812'.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .slideY(begin: 0.06);
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
          eyebrow: 'auto.t_5e2ed1586d'.tr(),
          title: 'auto.t_a2187d02b6'.tr(),
          desc: 'auto.t_e4c7e33092'.tr(),
          icon: Icons.picture_as_pdf_rounded,
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
                    title: 'auto.t_9b3c3218ef'.tr(),
                    desc: 'auto.t_e03a824ef7'.tr(),
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
                    title: 'auto.t_7c0d3dfc88'.tr(),
                    desc: 'auto.t_44df6a0bc7'.tr(),
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
  final IconData icon;
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
        color: const Color(0xF20B0914),
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
              color: const Color(0xFF0D0A18),
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
                  child: Icon(icon, color: color, size: 18.sp),
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
                  label: 'auto.t_fd3141c19a'.tr(),
                  icon: Icons.visibility_rounded,
                  color: color,
                  onTap: onTap,
                ),
                SizedBox(height: 14.h),
                _ActionButton(
                  label: 'auto.t_0d8c9f7308'.tr(),
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

class _IndustriesSection extends StatelessWidget {
  const _IndustriesSection({
    required this.industries,
    required this.onSelect,
    required this.colorOf,
  });

  final List<PortfolioIndustry> industries;
  final ValueChanged<PortfolioIndustry> onSelect;
  final Color Function(String hex) colorOf;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          _SectionHeader(
            eyebrow: 'auto.t_f6736b6f48'.tr(),
            title: 'auto.t_be72c00083'.tr(),
            desc: 'auto.t_1e75bd77db'.tr(),
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
                index: index,
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
    required this.onSelect,
    required this.colorOf,
  });

  final PortfolioIndustry industry;
  final ValueChanged<PortfolioSpecialty> onSelect;
  final Color Function(String hex) colorOf;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          _SectionHeader(
            eyebrow: industry.localizedName(context),
            title: 'auto.t_94f68e30c1'.tr(),
            desc: 'auto.t_9932767326'.tr(),
            icon: _iconFor(industry.icon),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: industry.specialties.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.r,
              crossAxisSpacing: 10.r,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final specialty = industry.specialties[index];
              return _SpecialtyCard(
                specialty: specialty,
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
        color: const Color(0xC90B0914),
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
  final IconData icon;
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
        color: const Color(0xAA151024),
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
            prefixIcon: Icon(icon, color: iconColor, size: 18.sp),
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
    return Material(
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
            boxShadow: [
              BoxShadow(
                color: const Color(0x448B3DFF),
                blurRadius: 22.r,
                offset: Offset(0.w, 10.h),
              ),
            ],
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
    required this.tab,
    required this.photos,
    required this.reels,
    required this.photosVisible,
    required this.reelsVisible,
    required this.onTab,
    required this.onMorePhotos,
    required this.onMoreReels,
    required this.onImage,
    required this.onReel,
    required this.colorOf,
    required this.assetOf,
  });

  final String tab;
  final List<PortfolioMedia> photos;
  final List<PortfolioMedia> reels;
  final int photosVisible;
  final int reelsVisible;
  final ValueChanged<String> onTab;
  final VoidCallback onMorePhotos;
  final VoidCallback onMoreReels;
  final ValueChanged<PortfolioMedia> onImage;
  final ValueChanged<PortfolioMedia> onReel;
  final Color Function(String hex) colorOf;
  final String Function(String path) assetOf;

  @override
  Widget build(BuildContext context) {
    final items = tab == 'photos'
        ? photos.take(photosVisible).toList()
        : reels.take(reelsVisible).toList();
    final hasMore = tab == 'photos'
        ? photosVisible < photos.length
        : reelsVisible < reels.length;

    return _Panel(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TabButton(
                  active: tab == 'photos',
                  icon: Icons.image_rounded,
                  label:
                      'auto.t_bc7a21d8bb'.tr(args: [photos.length.toString()]),
                  onTap: () => onTab('photos'),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _TabButton(
                  active: tab == 'reels',
                  icon: Icons.movie_rounded,
                  label:
                      'auto.t_d1c0e0b7e7'.tr(args: [reels.length.toString()]),
                  onTap: () => onTab('reels'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (items.isEmpty)
            const _EmptyState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.r,
                crossAxisSpacing: 10.r,
                childAspectRatio: 0.74,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _MediaCard(
                  media: item,
                  index: index,
                  isReel: tab == 'reels',
                  color: colorOf(item.accentColor),
                  imagePath: assetOf(item.thumbnail),
                  onTap: () => tab == 'reels' ? onReel(item) : onImage(item),
                );
              },
            ),
          if (hasMore) ...[
            SizedBox(height: 16.h),
            _ActionButton(
              label: tab == 'photos'
                  ? 'auto.t_09a1c4795b'.tr()
                  : 'auto.t_466674eace'.tr(),
              icon: Icons.add_rounded,
              color: context.etbalyColors.gold,
              onTap: tab == 'photos' ? onMorePhotos : onMoreReels,
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
                fillColor: const Color(0x990B0914),
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

class _PortfolioCtaSection extends StatelessWidget {
  const _PortfolioCtaSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 42.h),
      decoration: BoxDecoration(
        color: const Color(0xEE1A1628),
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
            label: 'auto.t_103315edfb'.tr(),
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go(AppRoutes.startNow),
              borderRadius: BorderRadius.circular(999.r),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: colors.gold,
                  borderRadius: BorderRadius.circular(999.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.26),
                      blurRadius: 24.r,
                      offset: Offset(0.w, 10.h),
                    ),
                  ],
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
        color: const Color(0xDD141020),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: context.etbalyColors.primaryLight.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(color: const Color(0x66000000), blurRadius: 28.r),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.desc,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String desc;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Column(
      children: [
        _SectionBadge(icon: icon, label: eyebrow),
        SizedBox(height: 12.h),
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
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 15.sp),
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
            color: const Color(0xAA0B0914),
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
    required this.color,
    required this.onTap,
  });

  final PortfolioSpecialty specialty;
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
            color: const Color(0xAA0B0914),
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
                child:
                    Icon(_iconFor(specialty.icon), color: color, size: 19.sp),
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
              Wrap(
                spacing: 5.r,
                runSpacing: 4.r,
                children: [
                  _SpecBadge(
                    icon: Icons.image_rounded,
                    label: 'auto.t_0051eae24b'
                        .tr(args: [specialty.photos.length.toString()]),
                    color: color,
                  ),
                  _SpecBadge(
                    icon: Icons.movie_rounded,
                    label: 'auto.t_c95473ea98'
                        .tr(args: [specialty.reels.length.toString()]),
                    color: colors.textMuted,
                  ),
                ],
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
    required this.onTap,
  });

  final PortfolioMedia media;
  final int index;
  final bool isReel;
  final Color color;
  final String imagePath;
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
          decoration: BoxDecoration(
            color: const Color(0xCC0B0914),
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
                      media.localizedTitle(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      media.localizedDesc(context),
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
    return _Panel(
      child: Row(
        children: [
          _IconAction(
            icon: Icons.arrow_back_rounded,
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

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.active,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: active ? colors.gold : const Color(0xAA0B0914),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: active ? Colors.black : colors.gold, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: active ? Colors.black : colors.textMain,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
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

class _HeroStat extends StatelessWidget {
  const _HeroStat({
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
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0x990B0914),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.gold, size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
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
        color: const Color(0xDD0B0914),
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
              color: Colors.white,
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
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: const Color(0xAA0B0914),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        'auto.t_f1f374ed5d'.tr(),
        textAlign: TextAlign.center,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.etbalyColors.textMuted,
        ),
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

class _PortfolioBackgroundPainter extends CustomPainter {
  _PortfolioBackgroundPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF070511), Color(0xFF100D1C), Color(0xFF070511)],
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
  bool shouldRepaint(covariant _PortfolioBackgroundPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

IconData _iconFor(String icon) {
  return switch (icon) {
    // Industries
    'fa-balance-scale' => FontAwesomeIcons.scaleBalanced,
    'fa-heartbeat' => FontAwesomeIcons.heartPulse,
    'fa-couch' => FontAwesomeIcons.couch,
    'fa-shopping-bag' => FontAwesomeIcons.bagShopping,
    'fa-graduation-cap' => FontAwesomeIcons.graduationCap,
    'fa-swimming-pool' => FontAwesomeIcons.personSwimming,
    'fa-building' => FontAwesomeIcons.building,
    'fa-dumbbell' => FontAwesomeIcons.dumbbell,
    'fa-utensils' => FontAwesomeIcons.utensils,
    'fa-truck' => FontAwesomeIcons.truck,
    'fa-car' || 'fa-car-alt' => FontAwesomeIcons.car,
    'fa-magic' => FontAwesomeIcons.wandMagicSparkles,
    'fa-plane' => FontAwesomeIcons.plane,
    'fa-video' => FontAwesomeIcons.video,
    'fa-code' => FontAwesomeIcons.code,
    'fa-paint-brush' => FontAwesomeIcons.paintbrush,
    'fa-paint-roller' => FontAwesomeIcons.paintRoller,
    'fa-bullhorn' => FontAwesomeIcons.bullhorn,
    'fa-industry' => FontAwesomeIcons.industry,
    'fa-hotel' => FontAwesomeIcons.hotel,
    'fa-hammer' => FontAwesomeIcons.hammer,
    'fa-shield-alt' => FontAwesomeIcons.shieldHalved,
    'fa-home' || 'fa-house-user' => FontAwesomeIcons.house,
    'fa-calendar-alt' => FontAwesomeIcons.calendarDays,
    'fa-shopping-cart' => FontAwesomeIcons.cartShopping,
    'fa-hard-hat' => FontAwesomeIcons.helmetSafety,
    // Medical specialties
    'fa-tooth' => FontAwesomeIcons.tooth,
    'fa-spa' => FontAwesomeIcons.spa,
    'fa-eye' => FontAwesomeIcons.eye,
    'fa-brain' => FontAwesomeIcons.brain,
    'fa-bone' => FontAwesomeIcons.bone,
    'fa-baby' => FontAwesomeIcons.baby,
    'fa-heart' => FontAwesomeIcons.heart,
    'fa-hands' => FontAwesomeIcons.hands,
    'fa-user-md' => FontAwesomeIcons.userDoctor,
    'fa-child' => FontAwesomeIcons.child,
    'fa-apple-alt' => FontAwesomeIcons.appleWhole,
    'fa-paw' => FontAwesomeIcons.paw,
    'fa-pills' => FontAwesomeIcons.pills,
    'fa-tint' => FontAwesomeIcons.droplet,
    // Fitness & Sports
    'fa-trophy' => FontAwesomeIcons.trophy,
    'fa-star' => FontAwesomeIcons.star,
    // Commercial & Services
    'fa-box' => FontAwesomeIcons.box,
    'fa-gift' => FontAwesomeIcons.gift,
    'fa-tshirt' => FontAwesomeIcons.shirt,
    'fa-seedling' => FontAwesomeIcons.seedling,
    'fa-flask' => FontAwesomeIcons.flask,
    'fa-cut' => FontAwesomeIcons.scissors,
    // Food & Hospitality
    'fa-hamburger' => FontAwesomeIcons.burger,
    'fa-coffee' => FontAwesomeIcons.mugHot,
    'fa-birthday-cake' => FontAwesomeIcons.cakeCandles,
    'fa-concierge-bell' => FontAwesomeIcons.bellConcierge,
    // Engineering & Design
    'fa-drafting-compass' => FontAwesomeIcons.compassDrafting,
    'fa-city' => FontAwesomeIcons.city,
    'fa-bolt' => FontAwesomeIcons.bolt,
    'fa-wrench' => FontAwesomeIcons.wrench,
    'fa-broom' => FontAwesomeIcons.broom,
    // Technology
    'fa-laptop' => FontAwesomeIcons.laptop,
    'fa-laptop-code' => FontAwesomeIcons.laptopCode,
    'fa-mobile-alt' => FontAwesomeIcons.mobileScreenButton,
    'fa-user-shield' => FontAwesomeIcons.userShield,
    'fa-layer-group' => FontAwesomeIcons.layerGroup,
    'fa-bezier-curve' => FontAwesomeIcons.bezierCurve,
    // Marketing & Media
    'fa-chart-line' => FontAwesomeIcons.chartLine,
    'fa-pencil-alt' => FontAwesomeIcons.penToSquare,
    'fa-microphone' => FontAwesomeIcons.microphone,
    'fa-share-alt' => FontAwesomeIcons.shareNodes,
    'fa-user-tie' => FontAwesomeIcons.userTie,
    // Logistics & Travel
    'fa-truck-loading' => FontAwesomeIcons.truckRampBox,
    'fa-shipping-fast' => FontAwesomeIcons.truckFast,
    'fa-route' => FontAwesomeIcons.route,
    'fa-suitcase' => FontAwesomeIcons.suitcase,
    'fa-map-marked-alt' => FontAwesomeIcons.mapLocationDot,
    'fa-globe' => FontAwesomeIcons.globe,
    'fa-kaaba' => FontAwesomeIcons.kaaba,
    // Education
    'fa-chalkboard-teacher' => FontAwesomeIcons.chalkboardUser,
    _ => Icons.category_rounded,
  };
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
  late final VideoPlayerController _ctrl;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
        _ctrl.play();
        _ctrl.setLooping(true);
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _ctrl.value.isPlaying ? _ctrl.pause() : _ctrl.play();
    });
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
            child: _initialized
                ? GestureDetector(
                    onTap: _togglePlay,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _ctrl.value.aspectRatio,
                          child: VideoPlayer(_ctrl),
                        ),
                        // Play/pause overlay
                        AnimatedBuilder(
                          animation: _ctrl,
                          builder: (_, __) => _ctrl.value.isPlaying
                              ? const SizedBox.shrink()
                              : Container(
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.55),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 36.sp,
                                  ),
                                ),
                        ),
                        // Progress bar
                        Positioned(
                          bottom: 0.h,
                          left: 0.w,
                          right: 0.w,
                          child: VideoProgressIndicator(
                            _ctrl,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: const Color(0xFFD4AF37),
                              bufferedColor:
                                  Colors.white.withValues(alpha: 0.25),
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                      ],
                    ),
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

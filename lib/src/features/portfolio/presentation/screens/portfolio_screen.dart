import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/portfolio_data.dart';

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
  final _commentController = TextEditingController();
  final _customIndustryController = TextEditingController();
  final _customPhoneController = TextEditingController();
  final _dio = Dio();

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
    return const [];
  }

  List<PortfolioMedia> get _reels {
    if (_specialty != null) return _specialty!.reels;
    if (_isDirectMode) return _industry!.reels;
    return const [];
  }

  String _url(String path) => Uri.encodeFull('$_assetBase$path');
  String _mediaAsset(String path) => 'assets/images/portfolio/media/$path';

  Color _color(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  void _selectIndustry(PortfolioIndustry industry) {
    setState(() {
      _industry = industry;
      _specialty = null;
      _tab = 'photos';
      _photosVisible = 6;
      _reelsVisible = 6;
    });
  }

  void _selectSpecialty(PortfolioSpecialty specialty) {
    setState(() {
      _specialty = specialty;
      _tab = 'photos';
      _photosVisible = 6;
      _reelsVisible = 6;
    });
  }

  void _back() {
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
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _openClassPdf(String key) async {
    const ids = {
      'classA': '1xX3oVh8X4gXhm4EHGobkgymPm_cvYBak',
      'classB': '1OMlt-uM8cu2LuuDmE-E5_kxv1H4Bsr7q',
    };
    await _openUrl(
      'https://drive.google.com/file/d/${ids[key]}/view?usp=drive_link',
    );
  }

  Future<void> _downloadClassPdf(BuildContext context, String file) async {
    final bytes = await rootBundle.load('assets/files/portfolio/$file');
    final dir = await getApplicationDocumentsDirectory();
    final portfolioDir = Directory('${dir.path}/portfolio');
    if (!await portfolioDir.exists()) {
      await portfolioDir.create(recursive: true);
    }
    final outFile = File('${portfolioDir.path}/$file');
    await outFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    if (!context.mounted) return;
    final result = await OpenFilex.open(
      outFile.path,
      type: 'application/pdf',
    );
    if (result.type != ResultType.done && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ الملف: ${outFile.path}')),
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
        () => _customIndustryError = 'برجاء إدخال نوع نشاطك ورقم التليفون',
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
        _customIndustryError = 'تأكد من الاتصال بالإنترنت وحاول مجدداً';
      });
    }
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
              insetPadding: const EdgeInsets.all(14),
              backgroundColor: const Color(0xFF05040B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.78,
                      child: Image(
                        image: AssetImage(_mediaAsset(images[index])),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.broken_image_rounded),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _CircleButton(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    if (images.length > 1) ...[
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 8,
                        child: Center(
                          child: _CircleButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: prev,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 8,
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
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 34),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const _HeroSection(),
                      const SizedBox(height: 26),
                      if (_industry == null) ...[
                        _ClassPdfSection(
                          onPreview: _openClassPdf,
                          onDownload: (file) => _downloadClassPdf(
                            context,
                            file,
                          ),
                        ),
                        const SizedBox(height: 26),
                        _IndustriesSection(
                          industries: portfolioIndustries,
                          onSelect: _selectIndustry,
                          colorOf: _color,
                        ),
                        const SizedBox(height: 26),
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
                        const SizedBox(height: 26),
                        _ReviewSection(
                          rating: _rating,
                          controller: _commentController,
                          submitting: _reviewSubmitting,
                          submitted: _reviewSubmitted,
                          error: _reviewError,
                          onRating: (value) => setState(() => _rating = value),
                          onSubmit: _submitReview,
                        ),
                        const SizedBox(height: 26),
                        const _PortfolioCtaSection(),
                      ] else if (!_isDirectMode && _specialty == null) ...[
                        _Breadcrumb(
                          title: _industry!.nameAr,
                          subtitle: 'اختر التخصص لاستعراض الصور والريلز',
                          onBack: _back,
                        ),
                        const SizedBox(height: 18),
                        _SpecialtiesSection(
                          industry: _industry!,
                          onSelect: _selectSpecialty,
                          colorOf: _color,
                        ),
                      ] else ...[
                        _Breadcrumb(
                          title: _specialty?.nameAr ?? _industry!.nameAr,
                          subtitle: _industry!.nameAr,
                          onBack: _back,
                        ),
                        const SizedBox(height: 18),
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
                          onReel: (media) => _openUrl(_url(media.videoUrl)),
                          colorOf: _color,
                          assetOf: _mediaAsset,
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
      padding: const EdgeInsets.fromLTRB(18, 34, 18, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF161024), Color(0xFF0B0814)],
        ),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: [
          const _SectionBadge(
            icon: Icons.photo_library_rounded,
            label: 'معرض الأعمال',
          ),
          const SizedBox(height: 18),
          Text.rich(
            TextSpan(
              text: 'بعض أعمالنا ',
              children: [
                TextSpan(
                  text: 'المميزة',
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
          const SizedBox(height: 12),
          Text(
            'كل مشروع يحكى قصة نجاح – تصفح أعمالنا واكتشف كيف نحوّل الأفكار إلى واقع رقمي مؤثر',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          const Row(
            children: [
              Expanded(
                child: _HeroStat(
                  icon: Icons.work_rounded,
                  value: '+400K',
                  label: 'مشروع',
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.favorite_rounded,
                  value: '5000+',
                  label: 'عميل',
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.calendar_month_rounded,
                  value: '+12',
                  label: 'سنة',
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.star_rounded,
                  value: '93%',
                  label: 'رضا',
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
        const _SectionHeader(
          eyebrow: 'أعمالنا',
          title: 'نماذج من أعمالنا',
          desc: 'اضغط على الصورة لفتح المعاينة على Google Drive',
          icon: Icons.picture_as_pdf_rounded,
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final cardWidth =
                wide ? (constraints.maxWidth - 22) / 2 : constraints.maxWidth;
            return Wrap(
              spacing: 22,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _ClassCard(
                    title: 'الفئة الأولى',
                    desc:
                        'نماذج متميزة من أعمالنا الاحترافية في مختلف المجالات',
                    icon: FontAwesomeIcons.crown,
                    color: const Color(0xFFD4AF37),
                    pillColor: const Color(0xFFFF3D3D),
                    onTap: () => onPreview('classA'),
                    onDownload: () => onDownload('Class_A.pdf'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _ClassCard(
                    title: 'الفئة الثانية',
                    desc:
                        'مجموعة إضافية من أعمالنا الإبداعية والتسويقية المتنوعة',
                    icon: FontAwesomeIcons.gem,
                    color: const Color(0xFF63B3ED),
                    pillColor: const Color(0xFF3D70FF),
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
    required this.onTap,
    required this.onDownload,
  });

  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final Color pillColor;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xF20B0914),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.36)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Positioned.fill(child: _PdfAnimatedBackdrop(color: color)),
                    PositionedDirectional(
                      top: 12,
                      end: 12,
                      child: _SmallPill(
                        icon: Icons.picture_as_pdf_rounded,
                        label: 'PDF',
                        color: pillColor,
                      ),
                    ),
                    PositionedDirectional(
                      top: 20,
                      start: 26,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.48),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.withValues(alpha: 0.25),
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.42),
                              blurRadius: 42,
                            ),
                          ],
                        ),
                        child: Image.asset(AppAssets.logo, width: 78),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: color.withValues(alpha: 0.38)),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: colors.primaryLight.withValues(alpha: 0.16)),
                    const SizedBox(height: 8),
                    _TextLinkButton(
                      label: 'معاينة على Google Drive',
                      icon: Icons.visibility_rounded,
                      color: color,
                      onTap: onTap,
                    ),
                    const SizedBox(height: 14),
                    _ActionButton(
                      label: 'تحميل الملف',
                      icon: Icons.download_rounded,
                      color: color,
                      onTap: onDownload,
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
          const _SectionHeader(
            eyebrow: 'اختر مجالك',
            title: 'بعض المجالات التي نخدمها',
            desc: 'اضغط على مجال لاستعراض أعمالنا فيه',
            icon: Icons.grid_view_rounded,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: industries.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
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
            eyebrow: industry.nameAr,
            title: 'اختر التخصص',
            desc: 'اضغط على التخصص لاستعراض الصور والريلز',
            icon: _iconFor(industry.icon),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: industry.specialties.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.02,
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
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xC90B0914),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: submitted
              ? const Color(0xFF25D366).withValues(alpha: 0.42)
              : colors.primaryLight.withValues(alpha: 0.24),
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
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
                        width: 34,
                        height: 34,
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
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'مجالك مش موجود؟',
                              textAlign: TextAlign.right,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: colors.textMain,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'اكتب شغلك وهيتواصل معك متخصص من فريقنا فوراً',
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
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 620;
                      final fields = [
                        _CustomIndustryInput(
                          controller: industryController,
                          hint: 'مثلاً: مطعم، عيادة، محل ملابس...',
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
                          hint: 'رقم تليفونك أو واتساب',
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
                            const SizedBox(height: 10),
                            fields[1],
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: fields[0]),
                          const SizedBox(width: 12),
                          Expanded(child: fields[1]),
                        ],
                      );
                    },
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Icon(
                          Icons.error_rounded,
                          color: Color(0xFFFF6B6B),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
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
                  const SizedBox(height: 14),
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
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xAA151024),
        borderRadius: BorderRadius.circular(999),
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
            fontSize: 13,
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: colors.textMuted.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            prefixIcon: Icon(icon, color: iconColor, size: 18),
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
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 276,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xFFC9A227), Color(0xFF8B3DFF)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x448B3DFF),
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'أرسل وهيتواصل معك فريقنا',
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
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF25D366).withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.rocket_launch_rounded,
            color: Color(0xFF25D366),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'سيتواصل معك أحد أعضاء فريقنا المتخصص في التسويق عبر الهاتف أو واتساب للاهتمام بكل التفاصيل ومساعدتك في تحقيق أفضل النتائج.',
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
                  label: 'الصور (${photos.length})',
                  onTap: () => onTab('photos'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TabButton(
                  active: tab == 'reels',
                  icon: Icons.movie_rounded,
                  label: 'الريلز (${reels.length})',
                  onTap: () => onTab('reels'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const _EmptyState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.74,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _MediaCard(
                  media: item,
                  isReel: tab == 'reels',
                  color: colorOf(item.accentColor),
                  imagePath: assetOf(item.thumbnail),
                  onTap: () => tab == 'reels' ? onReel(item) : onImage(item),
                );
              },
            ),
          if (hasMore) ...[
            const SizedBox(height: 16),
            _ActionButton(
              label: tab == 'photos' ? 'عرض صور أكثر' : 'عرض ريلز أكثر',
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
          const _SectionHeader(
            eyebrow: 'آراؤكم تهمنا',
            title: 'هل أعجبك ما رأيت؟',
            desc: 'شاركنا رأيك – كل تقييم يساعدنا على التطور',
            icon: Icons.star_rounded,
          ),
          const SizedBox(height: 14),
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
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            'انقر على النجوم لتقييمنا',
            style: context.textTheme.labelMedium?.copyWith(
              color: colors.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (rating > 0 && !submitted) ...[
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              minLines: 3,
              maxLines: 4,
              style: TextStyle(color: colors.textMain),
              decoration: InputDecoration(
                hintText: 'اكتب تعليقك اختياريًا',
                hintStyle: TextStyle(color: colors.textMuted),
                filled: true,
                fillColor: const Color(0x990B0914),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          if (submitted)
            const _StatusBox(
              text: 'تم إرسال تقييمك. شكراً لوقتك',
              color: Color(0xFF68D391),
            )
          else if (rating > 0) ...[
            _ActionButton(
              label: submitting ? 'جاري الإرسال...' : 'إرسال التقييم',
              icon: Icons.send_rounded,
              color: colors.gold,
              onTap: submitting ? () {} : onSubmit,
            ),
            if (error) ...[
              const SizedBox(height: 10),
              const _StatusBox(
                text: 'تعذر إرسال التقييم الآن. حاول مرة أخرى.',
                color: Color(0xFFFF6B6B),
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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 42),
      decoration: BoxDecoration(
        color: const Color(0xEE1A1628),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          const _SectionBadge(
            icon: Icons.rocket_launch_rounded,
            label: 'معرض الأعمال',
          ),
          const SizedBox(height: 18),
          Text(
            'جاهز تبدأ رحلتك معانا؟',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'تواصل معنا الآن وابدأ طريقك نحو النجاح',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 26),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go(AppRoutes.contact),
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: colors.gold,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.26),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      'ابدأ الآن',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                      size: 20,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xDD141020),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.etbalyColors.primaryLight.withValues(alpha: 0.18),
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 28),
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
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.titleLarge?.copyWith(
            color: colors.textMain,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: colors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.gold, size: 15),
          const SizedBox(width: 7),
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
      title: industry.nameAr,
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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xAA0B0914),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 20,
                    offset: const Offset(4, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
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
      padding: const EdgeInsets.all(12),
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
    return _TileButton(
      onTap: onTap,
      color: color,
      icon: _iconFor(specialty.icon),
      title: specialty.nameAr,
      subtitle:
          '${specialty.photos.length} صورة | ${specialty.reels.length} ريلز',
    );
  }
}

class _TileButton extends StatelessWidget {
  const _TileButton({
    required this.onTap,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xAA0B0914),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.24)),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  color: colors.textMain,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: colors.textMuted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({
    required this.media,
    required this.isReel,
    required this.color,
    required this.imagePath,
    required this.onTap,
  });

  final PortfolioMedia media;
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xCC0B0914),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.24)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => ColoredBox(
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
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: _SmallPill(
                        icon:
                            isReel ? Icons.movie_rounded : Icons.image_rounded,
                        label: media.tagAr,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.titleAr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      media.descAr,
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
            icon: Icons.arrow_forward_rounded,
            color: colors.gold,
            onTap: onBack,
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? colors.gold : const Color(0xAA0B0914),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.gold.withValues(alpha: 0.28)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? Colors.black : colors.gold, size: 18),
              const SizedBox(width: 8),
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
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.42)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
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
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
              const SizedBox(width: 7),
              Icon(icon, color: color, size: 16),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.36)),
          ),
          child: Icon(icon, color: color, size: 20),
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
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0x990B0914),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primaryLight.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.gold, size: 20),
          const SizedBox(height: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xDD0B0914),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 10,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xAA0B0914),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'لا توجد عناصر في هذا التبويب حالياً',
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
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _PdfAnimatedBackdrop extends StatelessWidget {
  const _PdfAnimatedBackdrop({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PdfBackdropPainter(color));
  }
}

class _PdfBackdropPainter extends CustomPainter {
  const _PdfBackdropPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF110C1B),
          color.withValues(alpha: 0.35),
          const Color(0xFF080611),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x + 60, size.height), grid);
    }
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: 0.28), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.52),
          radius: 120,
        ),
      );
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.52), 120, glow);
  }

  @override
  bool shouldRepaint(covariant _PdfBackdropPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _PortfolioBackgroundPainter extends CustomPainter {
  const _PortfolioBackgroundPainter(this.progress);

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
    'fa-car' => FontAwesomeIcons.car,
    'fa-magic' => FontAwesomeIcons.wandMagicSparkles,
    'fa-plane' => FontAwesomeIcons.plane,
    'fa-video' => FontAwesomeIcons.video,
    'fa-code' => FontAwesomeIcons.code,
    'fa-paint-brush' => FontAwesomeIcons.paintbrush,
    'fa-bullhorn' => FontAwesomeIcons.bullhorn,
    'fa-industry' => FontAwesomeIcons.industry,
    'fa-hotel' => FontAwesomeIcons.hotel,
    'fa-hammer' => FontAwesomeIcons.hammer,
    'fa-shield-alt' => FontAwesomeIcons.shieldHalved,
    'fa-home' => FontAwesomeIcons.house,
    'fa-calendar-alt' => FontAwesomeIcons.calendarDays,
    'fa-shopping-cart' => FontAwesomeIcons.cartShopping,
    'fa-hard-hat' => FontAwesomeIcons.helmetSafety,
    'fa-tooth' => FontAwesomeIcons.tooth,
    'fa-spa' => FontAwesomeIcons.spa,
    'fa-eye' => FontAwesomeIcons.eye,
    _ => Icons.category_rounded,
  };
}

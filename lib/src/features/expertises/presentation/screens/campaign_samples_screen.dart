import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/expertise_catalogue.dart';
import '../../data/expertises_repository.dart';
import '../expertise_icons.dart';
import '../widgets/expertise_sample_kit.dart';

/// "نماذج حملات إعلانية. كل مجال ليه حكاية." — pick an industry, then browse
/// its campaign images and open any of them full screen.
class CampaignSamplesScreen extends StatefulWidget {
  const CampaignSamplesScreen({super.key});

  @override
  State<CampaignSamplesScreen> createState() => _CampaignSamplesScreenState();
}

class _CampaignSamplesScreenState extends State<CampaignSamplesScreen> {
  static const _step = 12;

  final _search = TextEditingController();
  final _scroll = ScrollController();
  CampaignCatalogue? _catalogue;
  bool _loading = true;
  String _query = '';
  CampaignCategory? _selected;
  int _visible = _step;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load({bool refresh = false}) async {
    if (!_loading && _catalogue == null) setState(() => _loading = true);
    try {
      final catalogue = await ExpertisesRepository.campaigns(refresh: refresh);
      if (!mounted) return;
      setState(() {
        _catalogue = catalogue;
        final selected = _selected;
        if (selected != null) {
          _selected = catalogue.categories
              .where((item) => item.category.id == selected.category.id)
              .firstOrNull;
        }
      });
    } catch (_) {
      // Keep what is on screen; with nothing loaded the error panel shows.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _open(CampaignCategory? category) {
    setState(() {
      _selected = category;
      _visible = _step;
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _openViewer(CampaignCategory category, int index) {
    final name = category.category.name.of(expertiseArabic(context));
    showEtbalyImageViewer(
      context,
      initialIndex: index,
      images: [
        for (final photo in category.photos)
          EtbalyViewerImage(
            provider: CachedNetworkImageProvider(photo.imageUrl),
            title: name,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final arabic = expertiseArabic(context);
    final accent = ExpertiseAccents.campaigns.of(context);
    final catalogue = _catalogue;
    final selected = _selected;
    final slivers = <Widget>[];

    if (catalogue == null) {
      slivers.add(
        SliverToBoxAdapter(
          child: _loading
              ? ExpertiseMessage(
                  accent: accent,
                  loading: true,
                  text: arabic
                      ? 'بنجهّز نماذج الحملات…'
                      : 'Loading campaign samples…',
                )
              : ExpertiseMessage(
                  accent: accent,
                  text: arabic
                      ? 'تعذّر تحميل النماذج. جرّب مرة تانية.'
                      : 'Could not load the samples. Please try again.',
                  actionLabel: arabic ? 'إعادة المحاولة' : 'Try again',
                  onAction: _load,
                ),
        ),
      );
    } else if (selected != null) {
      slivers.addAll(_gallery(selected, accent, arabic));
    } else {
      slivers.addAll(_categories(catalogue, accent, arabic));
    }

    return PopScope(
      // Back from an industry returns to the industry list first.
      canPop: selected == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selected != null) _open(null);
      },
      child: ExpertiseSamplePage(
        accent: accent,
        controller: _scroll,
        onRefresh: () => _load(refresh: true),
        header: ExpertiseSampleHeader(
          accent: accent,
          eyebrow: ExpertiseEyebrow(
            icon: FontAwesomeIcons.bullhorn,
            label: 'Paid Campaigns',
            color: accent,
          ),
          title: arabic
              ? 'نماذج حملات إعلانية.'
              : 'Advertising campaign samples.',
          highlight:
              arabic ? 'كل مجال ليه حكاية.' : 'Every industry has a story.',
          description: arabic
              ? 'اختار مجالك، واتفرّج على صور الحملات. افتح أي صورة للتكبير والتنقّل بين النماذج.'
              : 'Choose an industry and explore campaign images. Open any image to zoom in and browse the collection.',
        ),
        slivers: slivers,
      ),
    );
  }

  List<Widget> _categories(
    CampaignCatalogue catalogue,
    Color accent,
    bool arabic,
  ) {
    final query = normalizeExpertiseSearch(_query);
    final categories = [
      for (final item in catalogue.categories)
        if (query.isEmpty ||
            normalizeExpertiseSearch(
              [
                item.category.name.ar,
                item.category.name.en,
                ...item.category.tagsAr,
                ...item.category.tagsEn,
              ].join(' '),
            ).contains(query))
          item,
    ];
    void clear() {
      _search.clear();
      setState(() => _query = '');
    }

    return [
      SliverToBoxAdapter(
        child: ExpertiseFilterPanel(
          children: [
            ExpertiseSearchField(
              label: arabic ? 'اختار المجال المناسب لشغلك' : 'Find your industry',
              hint: arabic
                  ? 'ملابس، مطاعم، عقارات، أو مجال تاني…'
                  : 'Fashion, restaurants, real estate, or another industry…',
              controller: _search,
              accent: accent,
              onChanged: (value) => setState(() => _query = value),
            ),
            ExpertiseResultsBar(
              text: '${categories.length} ${arabic ? 'مجال' : 'industries'}',
              accent: accent,
              onReset: _query.isNotEmpty ? clear : null,
            ),
          ],
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 30.h)),
      if (categories.isEmpty)
        SliverToBoxAdapter(
          child: ExpertiseMessage(
            accent: accent,
            title: arabic ? 'مفيش مجال بالبحث ده' : 'No matching industry',
            actionLabel: arabic ? 'عرض كل المجالات' : 'Show all industries',
            onAction: clear,
          ),
        )
      else
        SliverList.separated(
          itemCount: categories.length,
          separatorBuilder: (context, index) => SizedBox(height: 18.h),
          itemBuilder: (context, index) => _CategoryCard(
            category: categories[index],
            accent: accent,
            onTap: () => _open(categories[index]),
          ),
        ),
    ];
  }

  List<Widget> _gallery(CampaignCategory category, Color accent, bool arabic) {
    final colors = context.etbalyColors;
    final photos = category.photos;
    final visible = math.min(_visible, photos.length);
    final tags = arabic ? category.category.tagsAr : category.category.tagsEn;
    return [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${photos.length} ${arabic ? 'صورة حملة' : 'campaign images'}',
              style: TextStyle(color: accent, fontSize: 12.sp),
            ),
            SizedBox(height: 5.h),
            Text(
              category.category.name.of(arabic),
              style: TextStyle(
                color: colors.textMain,
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                height: 1.6,
              ),
            ),
            SizedBox(height: 15.h),
            ExpertiseOutlineButton(
              icon: FontAwesomeIcons.tableCellsLarge,
              label: arabic ? 'كل المجالات' : 'All industries',
              onTap: () => _open(null),
            ),
            if (tags.isNotEmpty) ...[
              SizedBox(height: 22.h),
              Wrap(
                spacing: 9.w,
                runSpacing: 9.h,
                children: [
                  for (final tag in tags)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: colors.borderColor),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            SizedBox(height: 26.h),
          ],
        ),
      ),
      SliverList.separated(
        itemCount: visible,
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
        itemBuilder: (context, index) => _PhotoTile(
          photo: photos[index],
          number: index + 1,
          accent: accent,
          label: '${category.category.name.of(arabic)} · '
              '${arabic ? 'نموذج حملة' : 'Campaign sample'} ${index + 1}',
          onTap: () => _openViewer(category, index),
        ),
      ),
      if (visible < photos.length)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExpertiseOutlineButton(
                  icon: FontAwesomeIcons.plus,
                  iconAfter: true,
                  label: arabic ? 'عرض صور أكتر' : 'Show more images',
                  onTap: () => setState(
                    () => _visible = math.min(_visible + _step, photos.length),
                  ),
                ),
                SizedBox(width: 20.w),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    '$visible / ${photos.length}',
                    style: TextStyle(color: colors.textMuted, fontSize: 13.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
    ];
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.accent,
    required this.onTap,
  });

  final CampaignCategory category;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final arabic = expertiseArabic(context);
    final cover = category.photos.firstOrNull;
    final pixels = MediaQuery.sizeOf(context).width *
        MediaQuery.devicePixelRatioOf(context);
    final name = category.category.name.of(arabic);
    final radius = BorderRadius.circular(23.r);

    return Semantics(
      button: true,
      label: name,
      excludeSemantics: true,
      child: Material(
        color: colors.bgCard,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: accent.withValues(alpha: 0.3)),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: Color.alphaBlend(
                        accent.withValues(alpha: 0.08),
                        colors.bgCard,
                      ),
                    ),
                    if (cover != null)
                      CachedNetworkImage(
                        imageUrl: cover.thumbnailUrl,
                        fit: BoxFit.contain,
                        memCacheWidth: math.min(pixels, 960).round(),
                      ),
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00100C20), Color(0xD9100C20)],
                            stops: [0.45, 1],
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      start: 16.w,
                      bottom: 16.h,
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          color: const Color(0xE6161223),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0x66E8C76B)),
                        ),
                        child: Center(
                          child: FaIcon(
                            expertiseIcon(category.category.icon),
                            size: 16.sp,
                            color: const Color(0xFFE8C76B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: colors.textMain,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            arabic
                                ? 'شوف نماذج الحملات'
                                : 'Explore campaign samples',
                            style: TextStyle(
                              color: accent,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.arrowUpRightFromSquare,
                          size: 11.sp,
                          color: accent,
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

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.photo,
    required this.number,
    required this.accent,
    required this.label,
    required this.onTap,
  });

  final CampaignPhoto photo;
  final int number;
  final Color accent;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final arabic = expertiseArabic(context);
    final pixels = MediaQuery.sizeOf(context).width *
        MediaQuery.devicePixelRatioOf(context);
    Widget badge(Widget child) => Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: const Color(0xDF161223),
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(color: const Color(0x4DFFFFFF)),
          ),
          child: Center(child: child),
        );

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: const Color(0xFF17131F),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23.r),
          side: BorderSide(color: accent.withValues(alpha: 0.3)),
        ),
        child: InkWell(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: photo.thumbnailUrl,
                  fit: BoxFit.contain,
                  memCacheWidth: math.min(pixels, 960).round(),
                  errorWidget: (context, url, error) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.image,
                          size: 30.sp,
                          color: const Color(0xFFE8C76B),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          arabic
                              ? 'افتح الصورة بالحجم الكامل'
                              : 'Open full-size image',
                          style: TextStyle(
                            color: const Color(0xFFE8C76B),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 12.w,
                  top: 12.h,
                  child: badge(
                    Text(
                      '$number',
                      style: TextStyle(color: Colors.white, fontSize: 11.sp),
                    ),
                  ),
                ),
                PositionedDirectional(
                  end: 12.w,
                  top: 12.h,
                  child: badge(
                    FaIcon(
                      FontAwesomeIcons.expand,
                      size: 11.sp,
                      color: Colors.white,
                    ),
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

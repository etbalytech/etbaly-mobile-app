import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/expertise_catalogue.dart';
import '../../data/expertises_repository.dart';
import '../expertise_icons.dart';
import '../widgets/expertise_sample_kit.dart';

/// "مواقع ويب لكل مجال." — website samples grouped by industry, with search
/// and an industry filter. Each card opens the live website.
class WebSamplesScreen extends StatefulWidget {
  const WebSamplesScreen({super.key});

  @override
  State<WebSamplesScreen> createState() => _WebSamplesScreenState();
}

class _WebSamplesScreenState extends State<WebSamplesScreen> {
  final _search = TextEditingController();
  WebCatalogue? _catalogue;
  bool _loading = true;
  String _query = '';
  String _category = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({bool refresh = false}) async {
    if (!_loading && _catalogue == null) setState(() => _loading = true);
    try {
      final catalogue = await ExpertisesRepository.web(refresh: refresh);
      if (!mounted) return;
      setState(() => _catalogue = catalogue);
    } catch (_) {
      // Keep what is on screen; with nothing loaded the error panel shows.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _reset() {
    _search.clear();
    setState(() {
      _query = '';
      _category = 'all';
    });
  }

  List<(ExpertiseCategory, List<WebSample>)> _groups(WebCatalogue catalogue) {
    final query = normalizeExpertiseSearch(_query);
    return [
      for (final category in catalogue.categories)
        if (_category == 'all' || category.id == _category)
          (
            category,
            [
              for (final site in catalogue.sites)
                if (site.categoryId == category.id &&
                    site.listed &&
                    (query.isEmpty ||
                        normalizeExpertiseSearch(
                          '${site.name} ${site.domain} '
                          '${category.name.ar} ${category.name.en}',
                        ).contains(query)))
                  site,
            ],
          ),
    ].where((group) => group.$2.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final arabic = expertiseArabic(context);
    final accent = ExpertiseAccents.web.of(context);
    final catalogue = _catalogue;
    final slivers = <Widget>[];

    if (catalogue == null) {
      slivers.add(
        SliverToBoxAdapter(
          child: _loading
              ? ExpertiseMessage(
                  accent: accent,
                  loading: true,
                  text: arabic
                      ? 'بنجهّز نماذج المواقع…'
                      : 'Loading website samples…',
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
    } else {
      final groups = _groups(catalogue);
      final count = groups.fold<int>(0, (sum, group) => sum + group.$2.length);
      slivers.add(
        SliverToBoxAdapter(
          child: ExpertiseFilterPanel(
            children: [
              ExpertiseSearchField(
                label: arabic ? 'بتدوّر على إيه؟' : 'What are you looking for?',
                hint: arabic
                    ? 'اسم الموقع، المجال، أو رابط الموقع…'
                    : 'Website name, industry, or domain…',
                controller: _search,
                accent: accent,
                onChanged: (value) => setState(() => _query = value),
              ),
              ExpertiseSelectField(
                label: arabic ? 'المجال' : 'Industry',
                value: _category,
                accent: accent,
                options: [
                  ('all', arabic ? 'كل المجالات' : 'All industries'),
                  for (final category in catalogue.categories)
                    (category.id, category.name.of(arabic)),
                ],
                onChanged: (value) => setState(() => _category = value),
              ),
              ExpertiseResultsBar(
                text: '$count ${arabic ? 'موقع' : 'websites'}',
                accent: accent,
                onReset:
                    _query.isNotEmpty || _category != 'all' ? _reset : null,
              ),
            ],
          ),
        ),
      );
      if (groups.isEmpty) {
        slivers.add(
          SliverPadding(
            padding: EdgeInsets.only(top: 34.h),
            sliver: SliverToBoxAdapter(
              child: ExpertiseMessage(
                accent: accent,
                icon: FontAwesomeIcons.magnifyingGlass,
                title: arabic ? 'مفيش مواقع بالبحث ده' : 'No websites found',
                text: arabic
                    ? 'جرّب اسم تاني أو اختار مجال مختلف.'
                    : 'Try another name or industry.',
                actionLabel: arabic ? 'عرض الكل' : 'Show all',
                onAction: _reset,
              ),
            ),
          ),
        );
      }
      for (final (category, sites) in groups) {
        final name = category.name.of(arabic);
        slivers
          ..add(
            SliverToBoxAdapter(
              child: ExpertiseGroupHeading(
                icon: expertiseIcon(category.icon),
                title: name,
                count: sites.length,
                accent: accent,
              ),
            ),
          )
          ..add(
            SliverList.separated(
              itemCount: sites.length,
              separatorBuilder: (context, index) => SizedBox(height: 18.h),
              itemBuilder: (context, index) => _WebCard(
                site: sites[index],
                category: name,
                accent: accent,
              ),
            ),
          );
      }
    }

    return ExpertiseSamplePage(
      accent: accent,
      onRefresh: () => _load(refresh: true),
      header: ExpertiseSampleHeader(
        accent: accent,
        eyebrow: ExpertiseEyebrow(
          icon: FontAwesomeIcons.laptopCode,
          label: 'Websites',
          color: accent,
        ),
        title: arabic ? 'مواقع ويب' : 'Websites',
        highlight: arabic ? 'لكل مجال.' : 'for every industry.',
        description: arabic
            ? 'من المتاجر للعيادات والشركات، اتفرّج على نماذج المواقع حسب نشاطك. اختار أي معاينة وافتح الموقع بنفسك.'
            : 'Explore website samples for stores, clinics, and businesses by industry. Choose a preview to visit the website.',
      ),
      slivers: slivers,
    );
  }
}

class _WebCard extends StatelessWidget {
  const _WebCard({
    required this.site,
    required this.category,
    required this.accent,
  });

  final WebSample site;
  final String category;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final arabic = expertiseArabic(context);
    final pixels = MediaQuery.sizeOf(context).width *
        MediaQuery.devicePixelRatioOf(context);
    final fallback = ColoredBox(
      color: Color.alphaBlend(accent.withValues(alpha: 0.08), colors.bgCard),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.globe, size: 32.sp, color: accent),
              SizedBox(height: 14.h),
              Text(
                site.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: accent, fontSize: 13.sp),
              ),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      link: true,
      label: '${site.name} · ${arabic ? 'افتح الموقع' : 'Visit website'}',
      excludeSemantics: true,
      child: Material(
        color: colors.bgCard,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: colors.borderColor),
        ),
        child: InkWell(
          onTap: () => openExpertiseLink(context, site.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BrowserBar(domain: site.domain, accent: accent),
              AspectRatio(
                aspectRatio: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: site.previewFor(pixels),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      memCacheWidth: pixels.round(),
                      placeholder: (context, url) => ColoredBox(
                        color: Color.alphaBlend(
                          accent.withValues(alpha: 0.08),
                          colors.bgCard,
                        ),
                      ),
                      errorWidget: (context, url, error) => fallback,
                    ),
                    Positioned(
                      right: 14.w,
                      bottom: 12.h,
                      child: _OpenChip(
                        label: arabic ? 'افتح الموقع' : 'Visit website',
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 96.h),
                child: Padding(
                  padding: EdgeInsets.all(18.r),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              site.name,
                              textDirection: expertiseTextDirection(site.name),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: colors.textMain,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              category,
                              style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 11.5.sp,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      FaIcon(
                        FontAwesomeIcons.arrowUpRightFromSquare,
                        size: 13.sp,
                        color: accent,
                      ),
                    ],
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

/// The fake browser address bar on top of a website preview.
class _BrowserBar extends StatelessWidget {
  const _BrowserBar({required this.domain, required this.accent});

  final String domain;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 38.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.borderColor)),
        ),
        child: Row(
          children: [
            for (var dot = 0; dot < 3; dot++)
              Container(
                width: 5.r,
                height: 5.r,
                margin: EdgeInsets.only(right: 4.w),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                domain,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textMuted, fontSize: 10.5.sp),
              ),
            ),
            SizedBox(width: 12.w),
            FaIcon(
              FontAwesomeIcons.arrowUpRightFromSquare,
              size: 9.sp,
              color: colors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenChip extends StatelessWidget {
  const _OpenChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xE8151329),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.arrowUpRightFromSquare,
              size: 10.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }
}

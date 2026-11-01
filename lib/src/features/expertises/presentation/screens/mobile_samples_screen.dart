import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/expertise_catalogue.dart';
import '../../data/expertises_repository.dart';
import '../expertise_icons.dart';
import '../widgets/expertise_sample_kit.dart';

/// "تطبيقات موبايل. أفكار بتتحرّك معاك." — published apps grouped by
/// industry, with search, an industry filter and an Android / iPhone switch.
class MobileSamplesScreen extends StatefulWidget {
  const MobileSamplesScreen({super.key});

  @override
  State<MobileSamplesScreen> createState() => _MobileSamplesScreenState();
}

class _MobileSamplesScreenState extends State<MobileSamplesScreen> {
  final _search = TextEditingController();
  MobileCatalogue? _catalogue;
  bool _loading = true;
  String _query = '';
  String _category = 'all';

  /// `all`, `google-play` or `app-store`.
  String _store = 'all';

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
      final catalogue = await ExpertisesRepository.mobile(refresh: refresh);
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
      _store = 'all';
    });
  }

  List<(ExpertiseCategory, List<MobileSample>)> _groups(
    MobileCatalogue catalogue,
  ) {
    final query = normalizeExpertiseSearch(_query);
    return [
      for (final category in catalogue.categories)
        if (_category == 'all' || category.id == _category)
          (
            category,
            [
              for (final app in catalogue.apps)
                if (app.categoryId == category.id &&
                    app.published &&
                    (_store == 'all' || app.store == _store) &&
                    (query.isEmpty ||
                        normalizeExpertiseSearch(
                          '${app.name} ${app.storeName} ${app.developer} '
                          '${app.storeId} ${category.name.ar} ${category.name.en}',
                        ).contains(query)))
                  app,
            ],
          ),
    ].where((group) => group.$2.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final arabic = expertiseArabic(context);
    final accent = ExpertiseAccents.mobile.of(context);
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
                      ? 'بنجهّز نماذج التطبيقات…'
                      : 'Loading app samples…',
                )
              : ExpertiseMessage(
                  accent: accent,
                  text: arabic
                      ? 'تعذّر تحميل التطبيقات. جرّب مرة تانية.'
                      : 'Could not load the apps. Please try again.',
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
                    ? 'اسم التطبيق، المجال، أو المطوّر…'
                    : 'App name, industry, or developer…',
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
              Semantics(
                container: true,
                label: arabic ? 'نظام التشغيل' : 'Operating system',
                child: Row(
                  children: [
                    for (final (store, label, icon) in [
                      ('all', arabic ? 'الكل' : 'All apps', null),
                      ('google-play', 'Android', FontAwesomeIcons.android),
                      ('app-store', 'iPhone', FontAwesomeIcons.apple),
                    ]) ...[
                      if (store != 'all') SizedBox(width: 7.w),
                      Expanded(
                        child: ExpertiseChoiceButton(
                          label: label,
                          icon: icon,
                          active: _store == store,
                          accent: accent,
                          onTap: () => setState(() => _store = store),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ExpertiseResultsBar(
                text: '$count ${arabic ? 'تطبيق' : 'apps'}',
                accent: accent,
                onReset: _query.isNotEmpty ||
                        _category != 'all' ||
                        _store != 'all'
                    ? _reset
                    : null,
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
                title: arabic ? 'مفيش تطبيقات بالبحث ده' : 'No apps found',
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
      for (final (category, apps) in groups) {
        final name = category.name.of(arabic);
        slivers
          ..add(
            SliverToBoxAdapter(
              child: ExpertiseGroupHeading(
                icon: expertiseIcon(category.icon),
                title: name,
                count: apps.length,
                accent: accent,
              ),
            ),
          )
          ..add(
            SliverList.separated(
              itemCount: apps.length,
              separatorBuilder: (context, index) => SizedBox(height: 18.h),
              itemBuilder: (context, index) =>
                  _AppCard(app: apps[index], category: name),
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
          icon: FontAwesomeIcons.mobileScreenButton,
          label: 'Mobile Apps',
          color: accent,
        ),
        title: arabic ? 'تطبيقات موبايل.' : 'Mobile apps.',
        highlight: arabic ? 'أفكار بتتحرّك معاك.' : 'Ideas on the move.',
        description: arabic
            ? 'من العقارات والتعليم للخدمات اليومية، اتفرّج على نماذج التطبيقات حسب المجال وافتح صفحة التطبيق على المتجر.'
            : 'From real estate and education to everyday services, explore app samples by industry and visit their store pages.',
      ),
      slivers: slivers,
    );
  }
}

class _AppCard extends StatelessWidget {
  const _AppCard({required this.app, required this.category});

  final MobileSample app;
  final String category;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final arabic = expertiseArabic(context);
    final accent = (app.isIos ? ExpertiseAccents.mobileIos : ExpertiseAccents.mobile)
        .of(context);
    final radius = BorderRadius.circular(24.r);

    return Semantics(
      link: true,
      label: '${app.name} · ${arabic ? 'شوف التطبيق' : 'Explore the app'}',
      excludeSemantics: true,
      child: Material(
        color: colors.bgCard,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: colors.borderColor),
        ),
        child: InkWell(
          onTap: () => openExpertiseLink(context, app.url),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: accent.withValues(alpha: 0.15)),
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 0.9,
                colors: [
                  accent.withValues(alpha: 0.07),
                  accent.withValues(alpha: 0),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _StoreBadge(app: app, accent: accent),
                      const Spacer(),
                      SizedBox(
                        width: 30.r,
                        height: 30.r,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.arrowUpRightFromSquare,
                            size: 11.sp,
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  _AppIcon(url: app.iconUrl, accent: accent),
                  SizedBox(height: 20.h),
                  Text(
                    app.name,
                    textAlign: TextAlign.center,
                    textDirection: expertiseTextDirection(app.name),
                    style: TextStyle(
                      color: colors.textMain,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    app.developer,
                    textAlign: TextAlign.center,
                    textDirection: expertiseTextDirection(app.developer),
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 11.5.sp,
                      height: 1.8,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.w,
                        vertical: 6.h,
                      ),
                      child: Text(
                        category,
                        style: TextStyle(color: accent, fontSize: 10.5.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    constraints: BoxConstraints(minHeight: 56.h),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.borderColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            arabic ? 'شوف التطبيق' : 'Explore the app',
                            style: TextStyle(
                              color: accent,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                app.isIos ? 'iOS' : 'Android',
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 10.5.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              FaIcon(
                                FontAwesomeIcons.arrowUpRightFromSquare,
                                size: 10.sp,
                                color: accent,
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
        ),
      ),
    );
  }
}

class _StoreBadge extends StatelessWidget {
  const _StoreBadge({required this.app, required this.accent});

  final MobileSample app;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: context.etbalyColors.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              app.isIos ? FontAwesomeIcons.apple : FontAwesomeIcons.googlePlay,
              size: 11.sp,
              color: accent,
            ),
            SizedBox(width: 8.w),
            Text(
              app.isIos ? 'App Store' : 'Google Play',
              style: TextStyle(color: accent, fontSize: 10.5.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.url, required this.accent});

  final String url;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final fallback = ColoredBox(
      color: Color.alphaBlend(accent.withValues(alpha: 0.1), colors.bgCard),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.mobileScreenButton,
          size: 34.sp,
          color: accent,
        ),
      ),
    );
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29.r),
        border: Border.all(color: accent.withValues(alpha: 0.38)),
      ),
      child: Container(
        width: 90.r,
        height: 90.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x26090512),
              blurRadius: 24.r,
              offset: Offset(0, 12.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: url.isEmpty
              ? fallback
              : ColoredBox(
                  color: Colors.white,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => fallback,
                    errorWidget: (context, url, error) => fallback,
                  ),
                ),
        ),
      ),
    );
  }
}

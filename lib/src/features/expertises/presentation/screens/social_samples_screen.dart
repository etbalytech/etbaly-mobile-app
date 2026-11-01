import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../data/expertise_catalogue.dart';
import '../../data/expertises_repository.dart';
import '../expertise_icons.dart';
import '../widgets/expertise_sample_kit.dart';

const _verifiedBadge = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
<path fill="#1689EA" d="m12 0 3.1 2 3.7.4 1.8 3.2 3 2.2-.7 3.6.7 3.6-3 2.2-1.8 3.2-3.7.4L12 24l-3.1-2-3.7-.4-1.8-3.2-3-2.2.7-3.6-.7-3.6 3-2.2 1.8-3.2L8.9 2Z"/>
<path d="m7 12 3 3 7-7" fill="none" stroke="#FFFFFF" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

/// "قصص نجاحنا مع عملائنا" — Facebook pages or Instagram accounts we manage,
/// grouped by industry. Each card opens the profile.
class SocialSamplesScreen extends StatefulWidget {
  const SocialSamplesScreen({super.key, required this.platform});

  final SocialPlatform platform;

  @override
  State<SocialSamplesScreen> createState() => _SocialSamplesScreenState();
}

class _SocialSamplesScreenState extends State<SocialSamplesScreen> {
  final _search = TextEditingController();
  SocialCatalogue? _catalogue;
  bool _loading = true;
  String _query = '';
  String _category = 'all';
  String _specialty = 'all';

  bool get _instagram => widget.platform == SocialPlatform.instagram;

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
      final catalogue = await ExpertisesRepository.social(
        widget.platform,
        refresh: refresh,
      );
      if (!mounted) return;
      setState(() => _catalogue = catalogue);
    } catch (_) {
      // Keep what is on screen; with nothing loaded the error panel shows.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _selectCategory(String value) => setState(() {
        _category = value;
        _specialty = 'all';
      });

  void _reset() {
    _search.clear();
    setState(() => _query = '');
    _selectCategory('all');
  }

  List<(ExpertiseCategory, List<SocialAccount>)> _groups(
    SocialCatalogue catalogue,
  ) {
    final query = normalizeExpertiseSearch(_query);
    bool matches(SocialAccount account, ExpertiseCategory category) {
      if (query.isEmpty) return true;
      ExpertiseSubcategory? subcategory;
      for (final item in category.subcategories) {
        if (item.id == account.subcategoryId) subcategory = item;
      }
      return normalizeExpertiseSearch(
        [
          account.name,
          account.displayName.ar,
          account.displayName.en,
          account.username,
          account.profileUrl,
          category.name.ar,
          category.name.en,
          subcategory?.name.ar ?? '',
          subcategory?.name.en ?? '',
        ].join(' '),
      ).contains(query);
    }

    return [
      for (final category in catalogue.categories)
        if (_category == 'all' || category.id == _category)
          (
            category,
            [
              for (final account in catalogue.accounts)
                if (account.platform == widget.platform.name &&
                    account.categoryId == category.id &&
                    (_specialty == 'all' ||
                        account.subcategoryId == _specialty) &&
                    matches(account, category))
                  account,
            ],
          ),
    ].where((group) => group.$2.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final arabic = expertiseArabic(context);
    final accent = (_instagram
            ? ExpertiseAccents.instagram
            : ExpertiseAccents.facebook)
        .of(context);
    final soft = (_instagram
            ? ExpertiseAccents.instagramSoft
            : ExpertiseAccents.facebookSoft)
        .of(context);
    final platformName = _instagram ? 'Instagram' : 'Facebook';
    final platformIcon =
        _instagram ? FontAwesomeIcons.instagram : FontAwesomeIcons.facebookF;
    final catalogue = _catalogue;
    final slivers = <Widget>[];

    if (catalogue == null) {
      slivers.add(
        SliverToBoxAdapter(
          child: _loading
              ? ExpertiseMessage(
                  accent: accent,
                  loading: true,
                  text: arabic ? 'بنجهّزلك النماذج…' : 'Loading samples…',
                )
              : ExpertiseMessage(
                  accent: accent,
                  text: arabic
                      ? 'النماذج مش متاحة دلوقتي. جرّب مرة تانية.'
                      : 'Samples could not be loaded. Please try again.',
                  actionLabel: arabic ? 'إعادة المحاولة' : 'Try again',
                  onAction: _load,
                ),
        ),
      );
    } else {
      final groups = _groups(catalogue);
      final count = groups.fold<int>(0, (sum, group) => sum + group.$2.length);
      var specialties = const <ExpertiseSubcategory>[];
      for (final category in catalogue.categories) {
        if (category.id == _category) specialties = category.subcategories;
      }
      slivers.add(
        SliverToBoxAdapter(
          child: ExpertiseFilterPanel(
            children: [
              ExpertiseSearchField(
                label: arabic
                    ? 'دور على حساب أو مجال'
                    : 'Find an account or industry',
                hint: arabic
                    ? 'اسم الصفحة، اليوزر، أو المجال…'
                    : 'Page name, username, or industry…',
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
                onChanged: _selectCategory,
              ),
              if (specialties.isNotEmpty)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ExpertiseChoiceButton(
                      label: arabic ? 'كل التخصصات' : 'All specialties',
                      active: _specialty == 'all',
                      accent: accent,
                      onTap: () => setState(() => _specialty = 'all'),
                    ),
                    for (final item in specialties)
                      ExpertiseChoiceButton(
                        label: item.name.of(arabic),
                        active: _specialty == item.id,
                        accent: accent,
                        onTap: () => setState(() => _specialty = item.id),
                      ),
                  ],
                ),
              ExpertiseResultsBar(
                text: '$count ${arabic ? 'نتيجة' : 'results'}',
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
                title:
                    arabic ? 'مفيش نتيجة بالاسم ده' : 'No matching accounts',
                text: arabic
                    ? 'جرّب اسم تاني أو اختار مجال مختلف.'
                    : 'Try another name or choose a different industry.',
                actionLabel: arabic ? 'عرض كل النماذج' : 'Show all samples',
                onAction: _reset,
              ),
            ),
          ),
        );
      }
      for (final (category, accounts) in groups) {
        slivers
          ..add(
            SliverToBoxAdapter(
              child: ExpertiseGroupHeading(
                icon: expertiseIcon(category.icon),
                title: category.name.of(arabic),
                count: accounts.length,
                accent: accent,
              ),
            ),
          )
          ..add(
            SliverList.separated(
              itemCount: accounts.length,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                final account = accounts[index];
                String? specialty;
                for (final item in category.subcategories) {
                  if (item.id == account.subcategoryId) {
                    specialty = item.name.of(arabic);
                  }
                }
                return _AccountCard(
                  account: account,
                  instagram: _instagram,
                  specialty: specialty,
                  accent: accent,
                  soft: soft,
                  platformIcon: platformIcon,
                );
              },
            ),
          );
      }
    }

    return ExpertiseSamplePage(
      accent: accent,
      onRefresh: () => _load(refresh: true),
      header: ExpertiseSampleHeader(
        accent: accent,
        eyebrow: _PlatformBadge(
          icon: platformIcon,
          label: platformName,
          accent: accent,
          soft: soft,
        ),
        title: arabic ? 'قصص نجاحنا مع عملائنا' : 'Our client stories',
        highlight: arabic ? 'في مختلف المجالات ✨' : 'across industries ✨',
        highlightOnNewLine: true,
        description: arabic
            ? 'اختار المجال واتفرّج على صفحات وحسابات من نماذج شغلنا. كل كارت هيوصّلك للحساب مباشرة.'
            : 'Choose an industry and explore sample pages and accounts. Open any card to visit the profile.',
        below: Semantics(
          container: true,
          label: arabic ? 'اختار المنصة' : 'Choose platform',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExpertiseChoiceButton(
                label: 'Facebook',
                icon: FontAwesomeIcons.facebookF,
                active: !_instagram,
                fill: true,
                accent: accent,
                onTap: () {
                  if (_instagram) context.go(AppRoutes.expertiseFacebook);
                },
              ),
              SizedBox(width: 10.w),
              ExpertiseChoiceButton(
                label: 'Instagram',
                icon: FontAwesomeIcons.instagram,
                active: _instagram,
                fill: true,
                accent: accent,
                onTap: () {
                  if (!_instagram) context.go(AppRoutes.expertiseInstagram);
                },
              ),
            ],
          ),
        ),
      ),
      slivers: slivers,
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({
    required this.icon,
    required this.label,
    required this.accent,
    required this.soft,
  });

  final FaIconData icon;
  final String label;
  final Color accent;
  final Color soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: soft.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: ExpertiseEyebrow(icon: icon, label: label, color: accent),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.account,
    required this.instagram,
    required this.specialty,
    required this.accent,
    required this.soft,
    required this.platformIcon,
  });

  final SocialAccount account;
  final bool instagram;
  final String? specialty;
  final Color accent;
  final Color soft;
  final FaIconData platformIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final arabic = expertiseArabic(context);
    final name = account.nameFor(arabic);
    final radius = BorderRadius.circular(24.r);
    final handle = Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        instagram ? '@${account.username}' : account.username,
        textAlign: TextAlign.center,
        style: instagram
            ? TextStyle(
                color: colors.textMain,
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
                height: 1.6,
              )
            : TextStyle(color: colors.textMuted, fontSize: 13.sp, height: 1.8),
      ),
    );
    final title = instagram
        ? handle
        : Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textMain,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              height: 1.6,
            ),
          );
    final subtitle = instagram
        ? Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMuted, fontSize: 13.sp, height: 1.8),
          )
        : handle;

    return Semantics(
      link: true,
      label: '$name · ${instagram ? 'Instagram' : 'Facebook'}',
      excludeSemantics: true,
      child: Material(
        color: colors.bgCard,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: colors.borderColor),
        ),
        child: InkWell(
          onTap: () => openExpertiseLink(context, account.profileUrl),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 0.9,
                colors: [
                  soft.withValues(alpha: 0.13),
                  soft.withValues(alpha: 0),
                ],
              ),
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 18.w,
                  top: 18.h,
                  child: FaIcon(
                    platformIcon,
                    size: 17.sp,
                    color: accent.withValues(alpha: 0.8),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 16.h),
                  child: Column(
                    children: [
                      _AccountLogo(
                        account: account,
                        instagram: instagram,
                        accent: accent,
                        soft: soft,
                        initials: account.initialsFor(arabic),
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child: title),
                          if (account.verified) ...[
                            SizedBox(width: 7.w),
                            Semantics(
                              label:
                                  arabic ? 'حساب موثّق' : 'Verified account',
                              child: SvgPicture.string(
                                _verifiedBadge,
                                width: 20.r,
                                height: 20.r,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      subtitle,
                      if (specialty != null) ...[
                        SizedBox(height: 10.h),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: soft.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 3.h,
                            ),
                            child: Text(
                              specialty!,
                              style: TextStyle(color: accent, fontSize: 11.sp),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 18.h),
                      Container(
                        padding: EdgeInsets.only(top: 14.h),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: colors.borderColor),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              arabic ? 'شوف الحساب' : 'View profile',
                              style: TextStyle(
                                color: accent,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            FaIcon(
                              FontAwesomeIcons.arrowUpRightFromSquare,
                              size: 11.sp,
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
    );
  }
}

class _AccountLogo extends StatelessWidget {
  const _AccountLogo({
    required this.account,
    required this.instagram,
    required this.accent,
    required this.soft,
    required this.initials,
  });

  final SocialAccount account;
  final bool instagram;
  final Color accent;
  final Color soft;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final inner = 110.r;
    final fallback = Container(
      width: inner,
      height: inner,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.bgCard, shape: BoxShape.circle),
      child: Text(
        initials,
        style: TextStyle(
          color: accent,
          fontSize: 32.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
    final logo = account.logoUrl;
    return Container(
      width: 120.r,
      height: 120.r,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: instagram
            ? null
            : Border.all(
                color: Color.alphaBlend(
                  accent.withValues(alpha: 0.45),
                  colors.borderColor,
                ),
              ),
        gradient: instagram
            ? const SweepGradient(
                colors: [
                  Color(0xFFF4B65D),
                  Color(0xFFD24C89),
                  Color(0xFF8D5BE2),
                  Color(0xFFF4B65D),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [soft, colors.bgCard],
                stops: const [0, 0.65],
              ),
        boxShadow: [
          BoxShadow(
            color: soft.withValues(alpha: 0.12),
            blurRadius: 25.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: logo == null || logo.isEmpty
          ? fallback
          : ClipOval(
              child: ColoredBox(
                color: Colors.white,
                child: CachedNetworkImage(
                  imageUrl: logo,
                  width: inner,
                  height: inner,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => fallback,
                  errorWidget: (context, url, error) => fallback,
                ),
              ),
            ),
    );
  }
}

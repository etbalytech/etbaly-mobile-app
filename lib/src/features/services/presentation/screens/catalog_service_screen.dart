import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../data/services_catalog_data.dart';
import '../../data/services_catalog_repository.dart';
import '../widgets/service_package_card.dart';

/// A service page driven by the dashboard packages catalogue — the same
/// page the website shows for these services (its `CatalogCategoryPage`).
class CatalogServiceScreen extends StatefulWidget {
  const CatalogServiceScreen({super.key, required this.slug});

  final String slug;

  @override
  State<CatalogServiceScreen> createState() => _CatalogServiceScreenState();
}

class _CatalogServiceScreenState extends State<CatalogServiceScreen> {
  List<InternalPackage>? _packages;
  bool _loading = true;
  bool _failed = false;

  CatalogService? get _service => catalogServiceBySlug(widget.slug);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cached = await ServicesCatalogRepository.cached();
    if (!mounted) return;
    setState(() {
      if (cached != null) _packages = cached;
      _loading = cached == null;
      _failed = false;
    });
    try {
      final fresh = await ServicesCatalogRepository.fetch();
      if (!mounted) return;
      setState(() {
        _packages = fresh;
        _loading = false;
        _failed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = _packages == null;
      });
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.services);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';
    final service = _service;

    if (service == null) {
      return Scaffold(
        backgroundColor: colors.bgMain,
        body: Center(
          child: TextButton(
            onPressed: _back,
            child: Text(isAr ? 'الخدمة غير موجودة' : 'Service not found'),
          ),
        ),
      );
    }

    final packages = _packages;
    final groups = packages == null
        ? const <PackageGroup>[]
        : groupPackages(packages.where(service.matches).toList());

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colors.bgMain,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _Header(service: service, isArabic: isAr, onBack: _back),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 36.h),
              sliver: SliverList.list(
                children: [
                  // What the service includes
                  for (final feature in service.features(isAr))
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.gold.withValues(alpha: 0.16),
                            ),
                            child: Center(
                              child: Icon(Icons.check_rounded,
                                  color: colors.gold, size: 13.sp),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: colors.textMain,
                                fontSize: 13.sp,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 18.h),
                  if (packages == null && _loading)
                    _StateBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                              color: colors.gold, strokeWidth: 2.5),
                          SizedBox(height: 12.h),
                          Text(
                            isAr ? 'جاري تحميل الباقات...' : 'Loading packages...',
                            style: TextStyle(
                                color: colors.textMuted, fontSize: 13.sp),
                          ),
                        ],
                      ),
                    )
                  else if (packages == null && _failed)
                    _StateBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.triangleExclamation,
                              color: colors.gold, size: 26.sp),
                          SizedBox(height: 10.h),
                          Text(
                            isAr
                                ? 'تعذر تحميل الباقات حاليًا.'
                                : 'Packages could not be loaded right now.',
                            style: TextStyle(
                                color: colors.textMuted, fontSize: 13.sp),
                          ),
                          SizedBox(height: 12.h),
                          OutlinedButton.icon(
                            onPressed: _load,
                            icon: Icon(Icons.refresh_rounded, size: 18.sp),
                            label: Text(isAr ? 'إعادة المحاولة' : 'Try again'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.gold,
                              side: BorderSide(
                                  color: colors.gold.withValues(alpha: 0.5)),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (groups.isEmpty)
                    _StateBox(
                      child: Text(
                        isAr
                            ? 'لا توجد باقات في الوقت الحالي'
                            : 'No packages are available right now',
                        style:
                            TextStyle(color: colors.textMuted, fontSize: 13.sp),
                      ),
                    )
                  else
                    for (final group in groups) ...[
                      Text(
                        group.label(isAr),
                        style: TextStyle(
                          color: colors.textMain,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      for (final pkg in group.packages) ...[
                        ServicePackageCard(
                          pkg: pkg,
                          categoryLabel: group.label(isAr),
                        ),
                        SizedBox(height: 12.h),
                      ],
                      SizedBox(height: 8.h),
                    ],
                  SizedBox(height: 12.h),
                  _ContactBanner(isArabic: isAr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.service,
    required this.isArabic,
    required this.onBack,
  });

  final CatalogService service;
  final bool isArabic;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final accent = service.accent;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 52.h, 18.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            accent.withValues(alpha: 0.22),
            colors.bgSecondary,
            colors.bgMain,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: colors.bgCard.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(color: colors.borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isArabic
                        ? Icons.chevron_right_rounded
                        : Icons.chevron_left_rounded,
                    color: colors.textMain,
                    size: 18.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    isArabic ? 'رجوع' : 'Back',
                    style: TextStyle(
                      color: colors.textMain,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Container(
                width: 62.w,
                height: 62.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      accent.withValues(alpha: 0.32),
                      accent.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(color: accent.withValues(alpha: 0.45)),
                ),
                child: Center(
                  child: FaIcon(service.icon, color: accent, size: 26.sp),
                ),
              ),
              const Spacer(),
              Text(
                service.number,
                style: TextStyle(
                  color: colors.gold.withValues(alpha: 0.75),
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            service.title(isArabic),
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            service.desc(isArabic),
            style: context.textTheme.bodyMedium
                ?.copyWith(color: colors.textMuted, height: 1.75),
          ),
        ],
      ),
    );
  }
}

class _StateBox extends StatelessWidget {
  const _StateBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 34.h),
        child: Center(child: child),
      );
}

class _ContactBanner extends StatelessWidget {
  const _ContactBanner({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: colors.bgCard,
        border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Text(
            isArabic ? 'هل تحتاج باقة مخصصة؟' : 'Need a custom package?',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            isArabic
                ? 'تواصل مع فريقنا وسنجهز لك العرض المناسب لمشروعك'
                : 'Talk to our team and we will prepare the right offer for your project',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMuted, fontSize: 12.sp, height: 1.6),
          ),
          SizedBox(height: 14.h),
          FilledButton.icon(
            onPressed: () => context.go(AppRoutes.contact),
            style: FilledButton.styleFrom(
              backgroundColor: colors.gold,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 13.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            iconAlignment: IconAlignment.end,
            icon: Icon(
              isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
              size: 18.sp,
            ),
            label: Text(
              isArabic ? 'تواصل معنا' : 'Contact Us',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

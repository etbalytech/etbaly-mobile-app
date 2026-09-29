import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../data/services_catalog_data.dart';
import 'service_package_card.dart';

/// "Choose the right package for you" — the dashboard catalogue, grouped into
/// category tabs, exactly like the website's services page.
class EtbalyPackagesCatalogSection extends StatefulWidget {
  const EtbalyPackagesCatalogSection({
    super.key,
    required this.packages,
    required this.loading,
    required this.failed,
    required this.onRetry,
  });

  /// `null` until the first answer (cached or fresh) has arrived.
  final List<InternalPackage>? packages;
  final bool loading;
  final bool failed;
  final VoidCallback onRetry;

  @override
  State<EtbalyPackagesCatalogSection> createState() =>
      _EtbalyPackagesCatalogSectionState();
}

class _EtbalyPackagesCatalogSectionState
    extends State<EtbalyPackagesCatalogSection> {
  String _selectedKey = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';
    final packages = widget.packages;
    final groups = packages == null ? const <PackageGroup>[] : groupPackages(packages);
    final selected = groups.isEmpty
        ? null
        : groups.firstWhere((g) => g.key == _selectedKey, orElse: () => groups.first);

    Widget stateBox(Widget child) => Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h),
          child: Center(child: child),
        );

    return EtbalyWebSectionShell(
      backgroundColor: colors.bgSecondary,
      margin: EdgeInsets.only(top: 18.h),
      child: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: EtbalyWebBadge(label: isAr ? 'باقاتنا' : 'Our Packages')),
            SizedBox(height: 14.h),
            Center(
              child: Text(
                isAr ? 'اختر الباقة المناسبة لك' : 'Choose the Right Package for You',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: colors.textMain,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                isAr
                    ? 'كل الباقات والأسعار محدثة مباشرة من كتالوج باقاتنا المعتمد.'
                    : 'Every package and price is updated directly from our approved catalogue.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: colors.textMuted, height: 1.7),
              ),
            ),
            SizedBox(height: 18.h),
            if (packages == null && widget.loading)
              stateBox(Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: colors.gold, strokeWidth: 2.5),
                  SizedBox(height: 12.h),
                  Text(
                    isAr ? 'جاري تحميل الباقات...' : 'Loading packages...',
                    style: TextStyle(color: colors.textMuted, fontSize: 13.sp),
                  ),
                ],
              ))
            else if (packages == null && widget.failed)
              stateBox(Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.triangleExclamation,
                      color: colors.gold, size: 26.sp),
                  SizedBox(height: 10.h),
                  Text(
                    isAr
                        ? 'تعذر تحميل الباقات حاليًا.'
                        : 'Packages could not be loaded right now.',
                    style: TextStyle(color: colors.textMuted, fontSize: 13.sp),
                  ),
                  SizedBox(height: 12.h),
                  OutlinedButton.icon(
                    onPressed: widget.onRetry,
                    icon: Icon(Icons.refresh_rounded, size: 18.sp),
                    label: Text(isAr ? 'إعادة المحاولة' : 'Try again'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.gold,
                      side: BorderSide(color: colors.gold.withValues(alpha: 0.5)),
                    ),
                  ),
                ],
              ))
            else if (selected == null)
              stateBox(Text(
                isAr
                    ? 'لا توجد باقات في الوقت الحالي'
                    : 'No packages are available right now',
                style: TextStyle(color: colors.textMuted, fontSize: 13.sp),
              ))
            else ...[
              // Category tabs
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.layerGroup,
                          color: colors.primary, size: 15.sp),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'اختر التصنيف' : 'Choose a category',
                          style: TextStyle(
                            color: colors.textMain,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          isAr
                              ? '${groups.length} تصنيف متاح'
                              : '${groups.length} categories available',
                          style: TextStyle(color: colors.textMuted, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 58.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, i) {
                    final group = groups[i];
                    final active = group.key == selected.key;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedKey = group.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        constraints: BoxConstraints(maxWidth: 240.w),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: active
                              ? colors.gold.withValues(alpha: 0.14)
                              : colors.bgCard,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: active
                                ? colors.gold.withValues(alpha: 0.7)
                                : colors.borderColor,
                            width: active ? 1.4 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.label(isAr),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: active ? colors.gold : colors.textMain,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              isAr
                                  ? '${group.packages.length} باقة'
                                  : '${group.packages.length} packages',
                              style: TextStyle(color: colors.textMuted, fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'الباقات المتاحة ضمن' : 'Available packages in',
                          style: TextStyle(color: colors.textMuted, fontSize: 11.sp),
                        ),
                        Text(
                          selected.label(isAr),
                          style: TextStyle(
                            color: colors.textMain,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colors.gold.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      '${selected.packages.length}',
                      style: TextStyle(
                        color: colors.gold,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              EtbalyWebResponsiveGrid(
                gap: 14,
                children: [
                  for (final pkg in selected.packages)
                    ServicePackageCard(
                      pkg: pkg,
                      categoryLabel: selected.label(isAr),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Ready to launch? Pay now" banner that leads to the payment methods tab.
class EtbalyServicesPayCta extends StatelessWidget {
  const EtbalyServicesPayCta({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';
    final perks = isAr
        ? const ['دفع آمن ومضمون', 'بدء تنفيذ خلال 24 ساعة', 'دعم مستمر طوال الفترة']
        : const ['Safe & Secure Payment', 'Execution starts within 24h', 'Ongoing support throughout'];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.only(top: 18.h),
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              colors.gold.withValues(alpha: 0.14),
              colors.bgCard,
              colors.primary.withValues(alpha: 0.12),
            ],
          ),
          border: Border.all(color: colors.gold.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.gold.withValues(alpha: 0.14),
                border: Border.all(color: colors.gold.withValues(alpha: 0.4)),
              ),
              child: Center(
                child: FaIcon(FontAwesomeIcons.creditCard,
                    color: colors.gold, size: 24.sp),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              isAr
                  ? 'جاهز للانطلاق؟ ادفع الآن وابدأ رحلتك نحو القمة'
                  : 'Ready to launch? Pay now and start your journey to the top',
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                color: colors.textMain,
                fontWeight: FontWeight.w900,
                height: 1.3,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isAr
                  ? 'آلية دفع سهلة وآمنة — نبدأ خلال 24 ساعة من استلام الدفع'
                  : 'Easy & secure payment — we start within 24 hours of receiving payment',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: colors.textMuted, height: 1.7),
            ),
            SizedBox(height: 14.h),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14.r,
              runSpacing: 8.r,
              children: [
                for (final perk in perks)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: const Color(0xFF22C55E), size: 16.sp),
                      SizedBox(width: 6.w),
                      Text(
                        perk,
                        style: TextStyle(
                          color: colors.textMain,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 18.h),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
                boxShadow: [
                  BoxShadow(
                    color: colors.gold.withValues(alpha: 0.28),
                    blurRadius: 22.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Material(
                color: colors.gold,
                borderRadius: BorderRadius.circular(999.r),
                child: InkWell(
                  onTap: () => context.go(AppRoutes.payments),
                  borderRadius: BorderRadius.circular(999.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 14.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isAr ? 'إتمام الدفع الآن' : 'Complete Payment Now',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                          color: Colors.black,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

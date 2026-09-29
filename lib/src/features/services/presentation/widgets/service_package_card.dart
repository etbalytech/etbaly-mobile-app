import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../contact/data/contact_session.dart';
import '../../data/services_catalog_data.dart';

const _whatsappNumber = '201010285020';

/// `1234.5` → `1,235` (Latin digits, no decimals — like the website's `1.0-0`).
String formatPackagePrice(double value) {
  final digits = value.round().toString();
  final out = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
    out.write(digits[i]);
  }
  return out.toString();
}

String _priceLabel(InternalPackage pkg, bool isAr) => pkg.isCustom
    ? (isAr ? 'حسب الطلب' : 'On request')
    : '${formatPackagePrice(pkg.price)} ${pkg.currency}';

/// A package from the dashboard catalogue, laid out like the website's card.
class ServicePackageCard extends StatelessWidget {
  const ServicePackageCard({
    super.key,
    required this.pkg,
    required this.categoryLabel,
  });

  final InternalPackage pkg;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';
    final badge = pkg.badgeLabel(isAr);
    final subtitle = pkg.subtitleFor(isAr);
    final duration = pkg.durationFor(isAr);
    final features = pkg.featuresFor(isAr);
    final accent = pkg.isMostRequested ? colors.gold : colors.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: pkg.isMostRequested
              ? colors.gold.withValues(alpha: 0.65)
              : colors.borderColor,
          width: pkg.isMostRequested ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: pkg.isMostRequested
                ? colors.gold.withValues(alpha: 0.12)
                : colors.cardShadow,
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (pkg.packageCode.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.bgSubtle,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: colors.borderColor),
                  ),
                  child: Text(
                    pkg.packageCode,
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              const Spacer(),
              if (badge.isNotEmpty)
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: colors.gold.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(color: colors.gold.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, color: colors.gold, size: 13.sp),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            badge,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.gold,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: accent.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: FaIcon(FontAwesomeIcons.boxOpen, color: accent, size: 18.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pkg.titleFor(isAr),
                      style: TextStyle(
                        color: colors.textMain,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.3,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 12.sp,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (pkg.isCustom)
            Row(
              children: [
                Icon(Icons.tune_rounded, color: colors.gold, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  isAr ? 'السعر حسب الطلب' : 'Price on request',
                  style: TextStyle(
                    color: colors.gold,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatPackagePrice(pkg.price),
                  style: TextStyle(
                    color: colors.gold,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  pkg.currency,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (pkg.oldPrice != null && pkg.oldPrice! > pkg.price) ...[
                  SizedBox(width: 10.w),
                  Text(
                    '${formatPackagePrice(pkg.oldPrice!)} ${pkg.currency}',
                    style: TextStyle(
                      color: colors.textLight,
                      fontSize: 12.sp,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          if (duration.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.event_available_rounded, color: colors.primary, size: 16.sp),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    duration,
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (features.isNotEmpty) ...[
            SizedBox(height: 12.h),
            for (final feature in features)
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Icon(Icons.check_circle_rounded,
                          color: const Color(0xFF22C55E), size: 15.sp),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: colors.textMain,
                          fontSize: 12.sp,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => showPackageOrderSheet(context, pkg, categoryLabel),
              style: FilledButton.styleFrom(
                backgroundColor: colors.gold,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: Icon(
                isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                size: 18.sp,
              ),
              label: Text(
                pkg.isCustom
                    ? (isAr ? 'اطلب تخصيص الباقة' : 'Request customization')
                    : (isAr ? 'ابدأ الآن' : 'Start Now'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The website's "Order your package" popup: contact us or send it on WhatsApp.
Future<void> showPackageOrderSheet(
  BuildContext context,
  InternalPackage pkg,
  String categoryLabel,
) {
  final isAr = context.locale.languageCode == 'ar';
  final duration = pkg.durationFor(isAr);
  final name = pkg.titleFor(isAr);
  final price = _priceLabel(pkg, isAr);

  final message = StringBuffer()
    ..writeln('${isAr ? 'التصنيف' : 'Category'}: $categoryLabel')
    ..writeln('${isAr ? 'الباقة' : 'Package'}: $name')
    ..write('${isAr ? 'السعر' : 'Price'}: $price');
  if (duration.isNotEmpty) {
    message.write('\n${isAr ? 'المدة' : 'Duration'}: $duration');
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final colors = sheetContext.etbalyColors;

      Widget line(String label, String value) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              style: TextStyle(fontSize: 13.sp, height: 1.5),
            ),
          );

      return Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 20.h + MediaQuery.paddingOf(sheetContext).bottom),
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
            border: Border.all(color: colors.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colors.borderColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                isAr ? '✨ اطلب باقتك الآن' : '✨ Order Your Package',
                style: TextStyle(
                  color: colors.textMain,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                isAr
                    ? 'ابدأ دلوقتي وخلي شغلك يوصل لمستوى أعلى 🚀'
                    : 'Start now and take your business to the next level 🚀',
                style: TextStyle(color: colors.textMuted, fontSize: 12.sp),
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: colors.bgSubtle,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: colors.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    line(isAr ? 'التصنيف' : 'Category', categoryLabel),
                    line(isAr ? 'الباقة' : 'Package', name),
                    line(isAr ? 'السعر الإجمالي' : 'Total Price', price),
                    if (duration.isNotEmpty) line(isAr ? 'المدة' : 'Duration', duration),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        ContactSession.pendingPackage = SelectedPackage(
                          name: name,
                          category: categoryLabel,
                          price: pkg.isCustom ? null : pkg.price.round().toString(),
                          isCustom: pkg.isCustom,
                        );
                        context.go(AppRoutes.contact);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      icon: Icon(Icons.support_agent_rounded, size: 18.sp),
                      label: Text(
                        isAr ? 'تواصل معنا' : 'Contact Us',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        launchUrl(
                          Uri.parse(
                            'https://wa.me/$_whatsappNumber?text=${Uri.encodeComponent(message.toString())}',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      icon: FaIcon(FontAwesomeIcons.whatsapp, size: 18.sp),
                      label: Text(
                        isAr ? 'واتساب' : 'WhatsApp',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(
                    isAr ? 'إلغاء' : 'Cancel',
                    style: TextStyle(color: colors.textMuted),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

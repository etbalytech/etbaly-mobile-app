import 'package:etbaly/src/imports/core_imports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  static const _supportWhatsapp = '+201010285020';

  String? _copiedKey;

  bool get _isArabic => context.locale.languageCode == 'ar';

  static final _methods = <_PaymentMethod>[
    _PaymentMethod(
      key: 'vodafone',
      titleAr: 'auto.t_7a1f9b12ae'.tr(),
      titleEn: 'Vodafone Cash',
      tagAr: 'auto.t_fc4453ad89'.tr(),
      tagEn: 'Available Now',
      accent: const Color(0xFFE60000),
      icon: FontAwesomeIcons.mobileScreenButton,
      fields: [
        _PaymentField(
            labelAr: 'auto.t_211cce4ca4'.tr(),
            labelEn: 'Number 1',
            value: '01010285020'),
        _PaymentField(
            labelAr: 'auto.t_dcc5197735'.tr(),
            labelEn: 'Number 2',
            value: '01003628888'),
      ],
    ),
    _PaymentMethod(
      key: 'orange',
      titleAr: 'auto.t_83b4639371'.tr(),
      titleEn: 'Orange Cash',
      tagAr: 'auto.t_fc4453ad89'.tr(),
      tagEn: 'Available Now',
      accent: const Color(0xFFFF7F00),
      icon: FontAwesomeIcons.mobileScreenButton,
      fields: [
        _PaymentField(
            labelAr: 'auto.t_467a9738a3'.tr(),
            labelEn: 'Number',
            value: '01278696383'),
      ],
    ),
    _PaymentMethod(
      key: 'instapay',
      titleAr: 'auto.t_d1ac318944'.tr(),
      titleEn: 'InstaPay',
      tagAr: 'auto.t_fc4453ad89'.tr(),
      tagEn: 'Available Now',
      accent: const Color(0xFF00B074),
      icon: FontAwesomeIcons.bolt,
      fields: [
        _PaymentField(
            labelAr: 'auto.t_211cce4ca4'.tr(),
            labelEn: 'Number 1',
            value: '01010285020'),
        _PaymentField(
            labelAr: 'auto.t_dcc5197735'.tr(),
            labelEn: 'Number 2',
            value: '01003628888'),
      ],
    ),
    _PaymentMethod(
      key: 'fawry',
      titleAr: 'auto.t_298df67750'.tr(),
      titleEn: 'Fawry Pay',
      tagAr: 'auto.t_fc4453ad89'.tr(),
      tagEn: 'Available Now',
      accent: const Color(0xFFF5A623),
      icon: FontAwesomeIcons.receipt,
      noteAr: 'auto.t_18bb28842c'.tr(),
      noteEn:
          'A code will be sent based on your amount - pay at any Fawry machine.',
    ),
    _PaymentMethod(
      key: 'telda',
      titleAr: 'auto.t_f1b710f681'.tr(),
      titleEn: 'Telda',
      tagAr: 'auto.t_fc4453ad89'.tr(),
      tagEn: 'Available Now',
      accent: const Color(0xFF6C47FF),
      icon: FontAwesomeIcons.creditCard,
      fields: [
        _PaymentField(
            labelAr: 'auto.t_c3acd581a5'.tr(),
            labelEn: 'Telda Number',
            value: '01010285020'),
      ],
    ),
    _PaymentMethod(
      key: 'binance',
      titleAr: 'auto.t_9df124773a'.tr(),
      titleEn: 'Binance USDT',
      tagAr: 'USDT',
      tagEn: 'USDT',
      accent: const Color(0xFFF0B90B),
      icon: FontAwesomeIcons.bitcoin,
      fields: [
        _PaymentField(
            labelAr: 'auto.t_d72110a8e9'.tr(),
            labelEn: 'Binance ID',
            value: '740502271'),
      ],
    ),
    _PaymentMethod(
      key: 'bank',
      titleAr: 'auto.t_f7d07c2a41'.tr(),
      titleEn: 'Bank Transfer',
      tagAr: 'auto.t_d435bc4712'.tr(),
      tagEn: 'National Bank of Egypt',
      accent: const Color(0xFFD4AF37),
      icon: FontAwesomeIcons.buildingColumns,
      fields: [
        _PaymentField(
            labelAr: 'auto.t_d249c7b6df'.tr(),
            labelEn: 'Account Number',
            value: '2305000886592101011'),
        _PaymentField(
            labelAr: 'IBAN',
            labelEn: 'IBAN',
            value: 'EG060003023050008865921010110'),
        _PaymentField(labelAr: 'SWIFT', labelEn: 'SWIFT', value: 'NBEGEGCX230'),
      ],
    ),
  ];

  Future<void> _copy(String value, String key) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    setState(() => _copiedKey = key);
    context.showSuccessSnackBar('auto.t_fc22e4e579'.tr());
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    if (mounted && _copiedKey == key) setState(() => _copiedKey = null);
  }

  Future<void> _openContact() async {
    final message = 'auto.t_95ce8c58a6'.tr();
    final uri = Uri.parse(
      'https://wa.me/${_supportWhatsapp.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        mounted) {
      context.showErrorSnackBar('auto.t_bd30dcd40b'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: EtbalyWebColors.sectionBlack,
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _PaymentHero(isArabic: _isArabic)),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  context.width < 390 ? 14 : 18,
                  0,
                  context.width < 390 ? 14 : 18,
                  30,
                ),
                sliver: SliverList.list(
                  children: [
                    _StepsSection(isArabic: _isArabic),
                    SizedBox(height: 18.h),
                    _MethodsGrid(
                      methods: _methods,
                      copiedKey: _copiedKey,
                      isArabic: _isArabic,
                      onCopy: _copy,
                    ),
                    SizedBox(height: 18.h),
                    _SecureNote(isArabic: _isArabic),
                    SizedBox(height: 18.h),
                    _FraudAlert(methods: _methods, isArabic: _isArabic),
                    SizedBox(height: 18.h),
                    _NeedHelpCard(isArabic: _isArabic, onTap: _openContact),
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

class _PaymentHero extends StatelessWidget {
  const _PaymentHero({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.width >= 700;
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _PaymentBackgroundPainter())),
        Padding(
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _Badge(
                  label: isArabic
                      ? 'auto.t_358c3df2ee'.tr()
                      : 'Secure Payment Gateway',
                  icon: FontAwesomeIcons.shieldHalved,
                ),
                SizedBox(height: 24.h),
                Text(
                  isArabic
                      ? 'auto.t_dc5c5cd5b3'.tr()
                      : 'Choose the Right Payment Method',
                  textAlign: TextAlign.center,
                  style: context.textTheme.displaySmall?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontSize: isTablet ? 42.sp : 32.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                  ),
                ),
                SizedBox(height: 14.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 720.w),
                  child: Text(
                    isArabic
                        ? 'auto.t_31e8a10add'.tr()
                        : 'We provide the fastest and easiest e-payment methods - transfer the amount and start with us instantly.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: EtbalyWebColors.body,
                      height: 1.7,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                _TrustRow(isArabic: isArabic),
              ],
            ),
          ),
        ],
      );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final items = [
      (FontAwesomeIcons.lock, 'auto.t_8995b8ebd5'.tr()),
      (FontAwesomeIcons.bolt, 'auto.t_cff72a0737'.tr()),
      (FontAwesomeIcons.headset, 'auto.t_a434f8e8f8'.tr()),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0x331D1830),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14.r,
        runSpacing: 8.r,
        children: [
          for (final item in items)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.$1, color: EtbalyWebColors.gold, size: 14.sp),
                SizedBox(width: 8.w),
                Text(
                  item.$2,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: EtbalyWebColors.body,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StepsSection extends StatelessWidget {
  const _StepsSection({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        'auto.t_2e36840ad3'.tr(),
        'auto.t_f878fe284d'.tr(),
      ),
      (
        'auto.t_7f3fbae712'.tr(),
        'auto.t_937be694c8'.tr(),
      ),
      (
        'auto.t_fb80dfb452'.tr(),
        'auto.t_65b3e018f2'.tr(),
      ),
    ];

    return Column(
      children: [
        Text(
          'auto.t_74f77b5efa'.tr(),
          style: context.textTheme.labelLarge?.copyWith(
            color: EtbalyWebColors.body,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 12.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 820 ? 3 : 1;
            final gap = columns == 3 ? 12.0 : 10.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (var i = 0; i < steps.length; i++)
                  SizedBox(
                    width: width,
                    child: _StepCard(
                      number: i + 1,
                      title: steps[i].$1,
                      subtitle: steps[i].$2,
                      active: i == 2,
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

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  final int number;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 76.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xBB0D0A17),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: active
                  ? const LinearGradient(
                      colors: [Color(0xFFD4AF37), Color(0xFFB8860B)])
                  : null,
              color: active ? null : const Color(0xFF262033),
              border: Border.all(color: EtbalyWebColors.goldBorder),
              boxShadow: active
                  ? [
                      BoxShadow(
                          color: EtbalyWebColors.gold.withValues(alpha: 0.35),
                          blurRadius: 16.r)
                    ]
                  : null,
            ),
            child: Text(
              '$number',
              style: context.textTheme.labelLarge?.copyWith(
                color: active ? Colors.white : EtbalyWebColors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: EtbalyWebColors.body,
                    height: 1.35,
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

class _MethodsGrid extends StatelessWidget {
  const _MethodsGrid({
    required this.methods,
    required this.copiedKey,
    required this.isArabic,
    required this.onCopy,
  });

  final List<_PaymentMethod> methods;
  final String? copiedKey;
  final bool isArabic;
  final Future<void> Function(String value, String key) onCopy;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 920
            ? 3
            : constraints.maxWidth >= 640
                ? 2
                : 1;
        const gap = 14.0;
        final tileWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final method in methods)
              SizedBox(
                width: method.key == 'bank' && columns > 1
                    ? constraints.maxWidth
                    : tileWidth,
                child: _PaymentCard(
                  method: method,
                  isArabic: isArabic,
                  copiedKey: copiedKey,
                  onCopy: onCopy,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.method,
    required this.isArabic,
    required this.copiedKey,
    required this.onCopy,
  });

  final _PaymentMethod method;
  final bool isArabic;
  final String? copiedKey;
  final Future<void> Function(String value, String key) onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: method.key == 'bank' ? 208 : 176),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xEE0E0A16),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: method.accent.withValues(alpha: 0.82)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.4,
                  colors: [
                    method.accent.withValues(alpha: 0.08),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _MethodMark(method: method),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? method.titleAr : method.titleEn,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: EtbalyWebColors.heading,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                color: const Color(0xFF22C55E), size: 7.sp),
                            SizedBox(width: 6.w),
                            Text(
                              isArabic ? method.tagAr : method.tagEn,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF22C55E),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              if (method.noteAr != null)
                _InfoField(text: isArabic ? method.noteAr! : method.noteEn!)
              else
                ...method.fields.map(
                  (field) {
                    final key = '${method.key}-${field.value}';
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _CopyField(
                        label: isArabic ? field.labelAr : field.labelEn,
                        value: field.value,
                        isArabic: isArabic,
                        copied: copiedKey == key,
                        onTap: () => onCopy(field.value, key),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyField extends StatelessWidget {
  const _CopyField({
    required this.label,
    required this.value,
    required this.isArabic,
    required this.copied,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool isArabic;
  final bool copied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(FontAwesomeIcons.mobileScreenButton,
                  color: EtbalyWebColors.gold, size: 11.sp),
              SizedBox(width: 6.w),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: EtbalyWebColors.body,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xFF281F43),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: EtbalyWebColors.border),
          ),
          child: Row(
            textDirection: TextDirection.ltr,
            children: isArabic
                ? [
                    _CopyButton(copied: copied, onTap: onTap),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          value,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: EtbalyWebColors.heading,
                            fontWeight: FontWeight.w900,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ]
                : [
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          value,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: EtbalyWebColors.heading,
                            fontWeight: FontWeight.w900,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ),
                    _CopyButton(copied: copied, onTap: onTap),
                  ],
          ),
        ),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.copied, required this.onTap});

  final bool copied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(copied ? Icons.check : Icons.copy, size: 16.sp),
      color: copied ? const Color(0xFF22C55E) : EtbalyWebColors.body,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF332757),
        fixedSize: Size(34.w, 34.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF281F43),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(FontAwesomeIcons.receipt,
              color: EtbalyWebColors.gold, size: 13.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodySmall?.copyWith(
                color: EtbalyWebColors.body,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecureNote extends StatelessWidget {
  const _SecureNote({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.shieldHalved,
              color: const Color(0xFF22C55E), size: 14.sp),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              isArabic
                  ? 'auto.t_a16b15d445'.tr()
                  : 'All transfers are secure and encrypted - your data is safe.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall
                  ?.copyWith(color: EtbalyWebColors.body),
            ),
          ),
        ],
      ),
    );
  }
}

class _FraudAlert extends StatelessWidget {
  const _FraudAlert({required this.methods, required this.isArabic});

  final List<_PaymentMethod> methods;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final official = methods
        .where((method) =>
            method.key == 'vodafone' ||
            method.key == 'orange' ||
            method.key == 'instapay' ||
            method.key == 'bank')
        .toList();

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xF4070103),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xAA7F1D1D)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x22EF4444),
                  border: Border.all(color: const Color(0x88EF4444)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                        blurRadius: 22.r),
                  ],
                ),
                child: Icon(FontAwesomeIcons.shieldHalved,
                    color: const Color(0xFFEF4444), size: 24.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AlertBadge(label: 'auto.t_57c4dee83f'.tr()),
                    SizedBox(height: 8.h),
                    Text(
                      'auto.t_205d3abc78'.tr(),
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'auto.t_293f720408'.tr(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.62),
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0x335B4B1D))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  'auto.t_c496311c70'.tr(),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: EtbalyWebColors.gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Color(0x335B4B1D))),
            ],
          ),
          SizedBox(height: 14.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 700 ? 2 : 1;
              const gap = 12.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final method in official)
                    SizedBox(
                      width: width,
                      child: _OfficialTile(method: method, isArabic: isArabic),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: 16.h),
          _WarningBox(
            icon: FontAwesomeIcons.triangleExclamation,
            color: const Color(0xFFF59E0B),
            title: 'auto.t_b440709acf'.tr(),
            text: 'auto.t_c06d241c7f'.tr(),
          ),
          SizedBox(height: 10.h),
          _WarningBox(
            icon: FontAwesomeIcons.scaleBalanced,
            color: const Color(0xFF818CF8),
            title: 'auto.t_7ce1febc0d'.tr(),
            text: 'auto.t_82611d9baa'.tr(),
          ),
          SizedBox(height: 16.h),
          Text(
            'auto.t_188c48f51d'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.42),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialTile extends StatelessWidget {
  const _OfficialTile({required this.method, required this.isArabic});

  final _PaymentMethod method;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final checkIcon = Icon(
      Icons.check_circle,
      color: const Color(0xFF22C55E),
      size: 18.sp,
    );
    final methodIcon = _MethodMark(method: method, small: true);

    final fields = method.fields.take(2).toList();
    final content = Expanded(
      child: Column(
        // CrossAxisAlignment.start = RIGHT in RTL context, LEFT in LTR context
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? method.titleAr : method.titleEn,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelLarge?.copyWith(
              color: method.accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4.h),
          for (final field in fields)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: isArabic
                    ? MainAxisAlignment.end // push to RIGHT in LTR row
                    : MainAxisAlignment.start,
                children: isArabic
                    ? [
                        Flexible(
                          child: Text(
                            field.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.74),
                              fontWeight: FontWeight.w800,
                              fontFeatures: [
                                const FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Icon(Icons.circle,
                            size: 5.sp,
                            color: method.accent.withValues(alpha: 0.75)),
                      ]
                    : [
                        Icon(Icons.circle,
                            size: 5.sp,
                            color: method.accent.withValues(alpha: 0.75)),
                        SizedBox(width: 5.w),
                        Flexible(
                          child: Text(
                            field.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.74),
                              fontWeight: FontWeight.w800,
                              fontFeatures: [
                                const FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                        ),
                      ],
              ),
            ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: isArabic
            ? [
                checkIcon,
                SizedBox(width: 10.w),
                content,
                SizedBox(width: 10.w),
                methodIcon
              ]
            : [
                methodIcon,
                SizedBox(width: 10.w),
                content,
                SizedBox(width: 10.w),
                checkIcon
              ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 17.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  text,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.66),
                    height: 1.65,
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

class _NeedHelpCard extends StatelessWidget {
  const _NeedHelpCard({required this.isArabic, required this.onTap});

  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xCC11101D),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.circleQuestion,
              color: EtbalyWebColors.gold, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'auto.t_48b043613b'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'auto.t_76a158e9e1'.tr(),
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: EtbalyWebColors.body),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          OutlinedButton.icon(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: EtbalyWebColors.gold,
              side: const BorderSide(color: EtbalyWebColors.goldBorder),
              backgroundColor: EtbalyWebColors.gold.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.r)),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            ),
            icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back,
                size: 18.sp),
            label: Text(
              'auto.t_9886382321'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            iconAlignment: isArabic ? IconAlignment.end : IconAlignment.start,
          ),
        ],
      ),
    );
  }
}

class _MethodMark extends StatelessWidget {
  const _MethodMark({required this.method, this.small = false});

  final _PaymentMethod method;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 42.0 : 46.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: method.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: method.accent.withValues(alpha: 0.55)),
      ),
      child: Icon(method.icon, color: method.accent, size: small ? 18 : 21),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: EtbalyWebColors.gold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: EtbalyWebColors.gold, size: 6.sp),
          SizedBox(width: 10.w),
          Icon(icon, color: EtbalyWebColors.gold, size: 13.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: EtbalyWebColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0x22EF4444),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: const Color(0x55EF4444)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.triangleExclamation,
              color: const Color(0xFFF87171), size: 12.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: const Color(0xFFF87171),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBackgroundPainter extends CustomPainter {
  _PaymentBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF100821), Color(0xFF070511)],
        ).createShader(rect),
    );

    final gridPaint = Paint()
      ..color = EtbalyWebColors.grid
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y <= size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final linePaint = Paint()
      ..color = EtbalyWebColors.purpleLine.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawLine(
        Offset(size.width * 0.08, 0), Offset(0, size.height * 0.62), linePaint);
    canvas.drawLine(Offset(size.width * 0.88, 0),
        Offset(size.width, size.height * 0.35), linePaint);
    canvas.drawLine(Offset(size.width * 0.14, size.height),
        Offset(size.width * 0.42, size.height * 0.68), linePaint);
    canvas.drawLine(Offset(size.width * 0.68, size.height),
        Offset(size.width, size.height * 0.76), linePaint);

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          EtbalyWebColors.gold.withValues(alpha: 0.13),
          Colors.transparent
        ],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.5, 20), radius: size.width * 0.6));
    canvas.drawCircle(Offset(size.width * 0.5, 20), size.width * 0.6, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PaymentMethod {
  _PaymentMethod({
    required this.key,
    required this.titleAr,
    required this.titleEn,
    required this.tagAr,
    required this.tagEn,
    required this.accent,
    required this.icon,
    this.fields = const [],
    this.noteAr,
    this.noteEn,
  });

  final String key;
  final String titleAr;
  final String titleEn;
  final String tagAr;
  final String tagEn;
  final Color accent;
  final IconData icon;
  final List<_PaymentField> fields;
  final String? noteAr;
  final String? noteEn;
}

class _PaymentField {
  _PaymentField({
    required this.labelAr,
    required this.labelEn,
    required this.value,
  });

  final String labelAr;
  final String labelEn;
  final String value;
}

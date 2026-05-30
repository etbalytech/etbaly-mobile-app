import 'package:etbaly/src/imports/core_imports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  static const _supportWhatsapp = '+201010285020';

  String? _copiedKey;

  bool get _isArabic => context.locale.languageCode == 'ar';

  static const _methods = <_PaymentMethod>[
    _PaymentMethod(
      key: 'vodafone',
      titleAr: 'فودافون كاش',
      titleEn: 'Vodafone Cash',
      tagAr: 'متاح الآن',
      tagEn: 'Available Now',
      accent: Color(0xFFE60000),
      icon: FontAwesomeIcons.mobileScreenButton,
      fields: [
        _PaymentField(
            labelAr: 'رقم الهاتف', labelEn: 'Number 1', value: '01010285020'),
        _PaymentField(
            labelAr: 'رقم الهاتف الثاني',
            labelEn: 'Number 2',
            value: '01003628888'),
      ],
    ),
    _PaymentMethod(
      key: 'orange',
      titleAr: 'اورنج كاش',
      titleEn: 'Orange Cash',
      tagAr: 'متاح الآن',
      tagEn: 'Available Now',
      accent: Color(0xFFFF7F00),
      icon: FontAwesomeIcons.mobileScreenButton,
      fields: [
        _PaymentField(
            labelAr: 'رقم المحفظة', labelEn: 'Number', value: '01278696383'),
      ],
    ),
    _PaymentMethod(
      key: 'instapay',
      titleAr: 'انستا باي',
      titleEn: 'InstaPay',
      tagAr: 'متاح الآن',
      tagEn: 'Available Now',
      accent: Color(0xFF00B074),
      icon: FontAwesomeIcons.bolt,
      fields: [
        _PaymentField(
            labelAr: 'رقم الهاتف', labelEn: 'Number 1', value: '01010285020'),
        _PaymentField(
            labelAr: 'رقم الهاتف الثاني',
            labelEn: 'Number 2',
            value: '01003628888'),
      ],
    ),
    _PaymentMethod(
      key: 'fawry',
      titleAr: 'فوري',
      titleEn: 'Fawry Pay',
      tagAr: 'متاح الآن',
      tagEn: 'Available Now',
      accent: Color(0xFFF5A623),
      icon: FontAwesomeIcons.receipt,
      noteAr: 'قم بإرسال كود لك حسب المبلغ - يتم الدفع من أي ماكينة فوري',
      noteEn:
          'A code will be sent based on your amount - pay at any Fawry machine.',
    ),
    _PaymentMethod(
      key: 'telda',
      titleAr: 'تيلدا',
      titleEn: 'Telda',
      tagAr: 'متاح الآن',
      tagEn: 'Available Now',
      accent: Color(0xFF6C47FF),
      icon: FontAwesomeIcons.creditCard,
      fields: [
        _PaymentField(
            labelAr: 'رقم تيلدا',
            labelEn: 'Telda Number',
            value: '01010285020'),
      ],
    ),
    _PaymentMethod(
      key: 'binance',
      titleAr: 'باينانس',
      titleEn: 'Binance USDT',
      tagAr: 'USDT',
      tagEn: 'USDT',
      accent: Color(0xFFF0B90B),
      icon: FontAwesomeIcons.bitcoin,
      fields: [
        _PaymentField(
            labelAr: 'المعرف', labelEn: 'Binance ID', value: '740502271'),
      ],
    ),
    _PaymentMethod(
      key: 'bank',
      titleAr: 'تحويل بنكي',
      titleEn: 'Bank Transfer',
      tagAr: 'البنك المصري',
      tagEn: 'National Bank of Egypt',
      accent: Color(0xFFD4AF37),
      icon: FontAwesomeIcons.buildingColumns,
      fields: [
        _PaymentField(
            labelAr: 'رقم الحساب',
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
    context.showSuccessSnackBar(
        _isArabic ? 'تم النسخ بنجاح' : 'Copied successfully');
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    if (mounted && _copiedKey == key) setState(() => _copiedKey = null);
  }

  Future<void> _openContact() async {
    final message = _isArabic
        ? 'مرحباً، أحتاج مساعدة في عملية الدفع.'
        : 'Hello, I need help with my payment.';
    final uri = Uri.parse(
      'https://wa.me/${_supportWhatsapp.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        mounted) {
      context.showErrorSnackBar(
          _isArabic ? 'تعذر فتح واتساب' : 'Could not open WhatsApp');
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
                    const SizedBox(height: 18),
                    _MethodsGrid(
                      methods: _methods,
                      copiedKey: _copiedKey,
                      isArabic: _isArabic,
                      onCopy: _copy,
                    ),
                    const SizedBox(height: 18),
                    _SecureNote(isArabic: _isArabic),
                    const SizedBox(height: 18),
                    _FraudAlert(methods: _methods, isArabic: _isArabic),
                    const SizedBox(height: 18),
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
    return SizedBox(
      height: isTablet ? 330 : 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: _PaymentBackgroundPainter()),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 42, 18, 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Badge(
                  label: isArabic
                      ? 'بوابة الدفع الآمنة'
                      : 'Secure Payment Gateway',
                  icon: FontAwesomeIcons.shieldHalved,
                ),
                const SizedBox(height: 24),
                Text(
                  isArabic
                      ? 'اختر وسيلة الدفع المناسبة'
                      : 'Choose the Right Payment Method',
                  textAlign: TextAlign.center,
                  style: context.textTheme.displaySmall?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontSize: isTablet ? 42 : 34,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Text(
                    isArabic
                        ? 'نوفر لك أسرع وأسهل وسائل الدفع الإلكتروني - حوّل المبلغ وابدأ رحلتك معنا فوراً'
                        : 'We provide the fastest and easiest e-payment methods - transfer the amount and start with us instantly.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: EtbalyWebColors.body,
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _TrustRow(isArabic: isArabic),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        FontAwesomeIcons.lock,
        isArabic ? 'مدفوعات مشفرة' : 'Encrypted Payments'
      ),
      (FontAwesomeIcons.bolt, isArabic ? 'تفعيل فوري' : 'Instant Activation'),
      (FontAwesomeIcons.headset, isArabic ? 'دعم 24/7' : '24/7 Support'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x331D1830),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 8,
        children: [
          for (final item in items)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.$1, color: EtbalyWebColors.gold, size: 14),
                const SizedBox(width: 8),
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
        isArabic ? 'اختر الباقة' : 'Choose Package',
        isArabic
            ? 'حدد الباقة المناسبة لاحتياجاتك من صفحة خدماتنا'
            : 'Select the package that fits your needs.',
      ),
      (
        isArabic ? 'حوّل المبلغ' : 'Transfer Amount',
        isArabic
            ? 'أرسل المبلغ عبر إحدى وسائل الدفع المتاحة أدناه'
            : 'Send the amount through any available method below.',
      ),
      (
        isArabic ? 'أرسل الإيصال' : 'Send Receipt',
        isArabic
            ? 'أرسل لقطة الإيصال على واتساب ويتمنا خلال 24 ساعة'
            : 'Send the receipt screenshot on WhatsApp within 24 hours.',
      ),
    ];

    return Column(
      children: [
        Text(
          isArabic ? 'كيف تدفع في 3 خطوات؟' : 'How to pay in 3 steps?',
          style: context.textTheme.labelLarge?.copyWith(
            color: EtbalyWebColors.body,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
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
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xBB0D0A17),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
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
                          blurRadius: 16)
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
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEE0E0A16),
        borderRadius: BorderRadius.circular(14),
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
                  const SizedBox(width: 10),
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
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.circle,
                                color: Color(0xFF22C55E), size: 7),
                            const SizedBox(width: 6),
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
              const SizedBox(height: 18),
              if (method.noteAr != null)
                _InfoField(text: isArabic ? method.noteAr! : method.noteEn!)
              else
                ...method.fields.map(
                  (field) {
                    final key = '${method.key}-${field.value}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: EtbalyWebColors.body,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(FontAwesomeIcons.mobileScreenButton,
                color: EtbalyWebColors.gold, size: 11),
          ],
        ),
        const SizedBox(height: 7),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF281F43),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: EtbalyWebColors.border),
          ),
          child: Row(
            textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
            children: [
              _CopyButton(copied: copied, onTap: onTap),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    value,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: EtbalyWebColors.heading,
                      fontWeight: FontWeight.w900,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
      icon: Icon(copied ? Icons.check : Icons.copy, size: 16),
      color: copied ? const Color(0xFF22C55E) : EtbalyWebColors.body,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF332757),
        fixedSize: const Size(34, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF281F43),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(FontAwesomeIcons.receipt,
              color: EtbalyWebColors.gold, size: 13),
          const SizedBox(width: 8),
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
          const Icon(FontAwesomeIcons.shieldHalved,
              color: Color(0xFF22C55E), size: 14),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              isArabic
                  ? 'جميع التحويلات آمنة ومشفرة - بياناتك في أمان تام'
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xF4070103),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xAA7F1D1D)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x22EF4444),
                  border: Border.all(color: const Color(0x88EF4444)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                        blurRadius: 22),
                  ],
                ),
                child: const Icon(FontAwesomeIcons.shieldHalved,
                    color: Color(0xFFEF4444), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AlertBadge(
                        label: isArabic ? 'تنبيه هام' : 'Important Alert'),
                    const SizedBox(height: 8),
                    Text(
                      isArabic ? 'احذر من المحتالين' : 'Beware of scammers',
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isArabic
                          ? 'نوفر لك قنوات عملائنا الكرام إلى أنه قد تم رصد بعض المحاولات لانتحال صفة المتحدثين باسم شركتنا.'
                          : 'We warn our clients that attempts to impersonate our company representatives have been detected.',
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
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0x335B4B1D))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  isArabic
                      ? 'وسائل الدفع والتواصل الرسمية الوحيدة'
                      : 'Only official payment channels',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: EtbalyWebColors.gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Color(0x335B4B1D))),
            ],
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 16),
          _WarningBox(
            icon: FontAwesomeIcons.triangleExclamation,
            color: const Color(0xFFF59E0B),
            title: isArabic ? 'تحذير مهم' : 'Important Warning',
            text: isArabic
                ? 'نهيب بجميع عملائنا عدم التعامل مع أي جهات أو أشخاص يدّعون تمثيل الشركة دون الرجوع إلى الأرقام الرسمية المذكورة أعلاه.'
                : 'Please do not deal with any party claiming to represent the company without checking the official numbers above.',
          ),
          const SizedBox(height: 10),
          _WarningBox(
            icon: FontAwesomeIcons.scaleBalanced,
            color: const Color(0xFF818CF8),
            title: isArabic ? 'إجراء قانوني' : 'Legal Action',
            text: isArabic
                ? 'ستتخذ الإجراءات القانونية اللازمة بحق كل من يثبت تورطه في انتحال شخصية الشركة أو التواصل مع عملائنا بشكل غير قانوني.'
                : 'Legal action will be taken against anyone impersonating the company or contacting our clients illegally.',
          ),
          const SizedBox(height: 16),
          Text(
            isArabic
                ? 'شاكرين لكم تعاونكم وثقتكم الدائمة - إدارة الشركة'
                : 'Thank you for your cooperation and trust - Company Management',
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
    final values = method.fields.map((field) => field.value).take(2).join('\n');
    const checkIcon = Icon(
      Icons.check_circle,
      color: Color(0xFF22C55E),
      size: 18,
    );
    final methodIcon = _MethodMark(method: method, small: true);
    final content = Expanded(
      child: Column(
        crossAxisAlignment:
            isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? method.titleAr : method.titleEn,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: context.textTheme.labelLarge?.copyWith(
              color: method.accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              values,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.74),
                fontWeight: FontWeight.w800,
                height: 1.35,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
        children: isArabic
            ? [
                checkIcon,
                const SizedBox(width: 10),
                content,
                const SizedBox(width: 10),
                methodIcon
              ]
            : [
                methodIcon,
                const SizedBox(width: 10),
                content,
                const SizedBox(width: 10),
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
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 10),
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
                const SizedBox(height: 4),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xCC11101D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.circleQuestion,
              color: EtbalyWebColors.gold, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'تحتاج مساعدة؟' : 'Need help?',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? 'فريقنا متاح لمساعدتك في عملية الدفع'
                      : 'Our team is available to help with your payment.',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: EtbalyWebColors.body),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: EtbalyWebColors.gold,
              side: const BorderSide(color: EtbalyWebColors.goldBorder),
              backgroundColor: EtbalyWebColors.gold.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            icon: Icon(isArabic ? Icons.arrow_back : Icons.arrow_forward,
                size: 18),
            label: Text(
              isArabic ? 'تواصل معنا' : 'Contact Us',
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
        borderRadius: BorderRadius.circular(10),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: EtbalyWebColors.gold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: EtbalyWebColors.gold, size: 6),
          const SizedBox(width: 10),
          Icon(icon, color: EtbalyWebColors.gold, size: 13),
          const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x22EF4444),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x55EF4444)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FontAwesomeIcons.triangleExclamation,
              color: Color(0xFFF87171), size: 12),
          const SizedBox(width: 6),
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
  const _PaymentBackgroundPainter();

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
  const _PaymentMethod({
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
  const _PaymentField({
    required this.labelAr,
    required this.labelEn,
    required this.value,
  });

  final String labelAr;
  final String labelEn;
  final String value;
}

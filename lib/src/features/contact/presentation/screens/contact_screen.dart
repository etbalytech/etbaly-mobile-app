import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/contact_email_policy.dart';
import '../../data/contact_session.dart';

const _whatsappUrl = 'https://wa.me/201010285020';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  static const _formUrl = 'https://api.web3forms.com/submit';
  static const _subscribeUrl = 'https://etba3ly-dm.com/api-email/subscribe.php';
  static const _accessKey = 'eef10318-b29e-4033-b122-535fe44348f1';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _businessController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _messageController = TextEditingController();

  /// Lets a failed validation scroll to the first field that needs attention.
  final _fieldKeys = <_ContactField, GlobalKey>{
    for (final field in _ContactField.values) field: GlobalKey(),
  };

  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  bool get _isArabic => context.locale.languageCode == 'ar';

  bool _isSubmitting = false;
  bool _showSuccess = false;
  bool _showValidationBanner = false;
  bool _submitFailed = false;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _whatsappError;
  bool _emailDomainBlocked = false;
  SelectedPackage? _package;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;
  Timer? _successTimer;
  Timer? _validationTimer;
  Timer? _failureTimer;

  @override
  void initState() {
    super.initState();
    _restoreSession();
    _resumeCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _successTimer?.cancel();
    _validationTimer?.cancel();
    _failureTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _businessController.dispose();
    _specialtyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.etbalyColors.bgMain,
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  context.width < 390 ? 14 : 18,
                  14,
                  context.width < 390 ? 14 : 18,
                  30,
                ),
                sliver: SliverList.list(
                  children: [
                    const _ContactHero(),
                    SizedBox(height: 22.h),
                    _buildMainLayout(context),
                    SizedBox(height: 26.h),
                    const _MapSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Channels first, then the form — the website's order in both layouts.
  Widget _buildMainLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 820;
        final form = _ContactFormCard(
          fieldKeys: _fieldKeys,
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
          whatsappController: _whatsappController,
          businessController: _businessController,
          specialtyController: _specialtyController,
          messageController: _messageController,
          nameError: _nameError,
          emailError: _emailError,
          phoneError: _phoneError,
          whatsappError: _whatsappError,
          emailDomainBlocked: _emailDomainBlocked,
          package: _package,
          showSuccess: _showSuccess,
          showValidationBanner: _showValidationBanner,
          submitFailed: _submitFailed,
          cooldownSeconds: _cooldownSeconds,
          isSubmitting: _isSubmitting,
          onSubmit: _submitForm,
          onChanged: _onFieldChanged,
          onBlur: _onFieldBlur,
          onChangePackage: _changePackage,
          onRemovePackage: _removePackage,
        );
        const channels = _ContactInfoColumn();

        if (!wide) {
          return Column(
            children: [
              channels,
              SizedBox(height: 18.h),
              form,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 4, child: channels),
            SizedBox(width: 18.w),
            Expanded(flex: 7, child: form),
          ],
        );
      },
    );
  }

  // ── Session (draft, package, cooldown) ───────────────────────────────────

  void _restoreSession() {
    final draft = ContactSession.draft;
    _nameController.text = draft.name;
    _emailController.text = draft.email;
    _phoneController.text = draft.phone;
    _whatsappController.text = draft.whatsapp;
    _businessController.text = draft.business;
    _specialtyController.text = draft.specialty;
    _messageController.text = draft.message;

    // A package picked on the services tab wins over the one kept in the draft.
    final pending = ContactSession.pendingPackage;
    if (pending != null) {
      _package = pending;
      ContactSession.pendingPackage = null;
      ContactSession.package = pending;
    } else {
      _package = ContactSession.package;
    }
  }

  void _saveDraft() {
    ContactSession.draft = ContactDraft(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      whatsapp: _whatsappController.text,
      business: _businessController.text,
      specialty: _specialtyController.text,
      message: _messageController.text,
    );
    ContactSession.package = _package;
  }

  Future<void> _resumeCooldown() async {
    final left = await ContactSession.remainingCooldown();
    if (!mounted || left == Duration.zero) return;
    _startCooldown(left);
  }

  void _startCooldown(Duration duration) {
    _cooldownTimer?.cancel();
    setState(() => _cooldownSeconds = (duration.inMilliseconds / 1000).ceil());
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _cooldownSeconds--;
        if (_cooldownSeconds <= 0) {
          _cooldownSeconds = 0;
          timer.cancel();
        }
      });
    });
  }

  void _changePackage() {
    _saveDraft();
    context.go(AppRoutes.services);
  }

  void _removePackage() {
    setState(() => _package = null);
    _saveDraft();
  }

  // ── Field events ─────────────────────────────────────────────────────────

  /// Typing clears that field's error, exactly like the website.
  void _onFieldChanged(_ContactField field) {
    final hadError = switch (field) {
      _ContactField.name => _nameError != null,
      _ContactField.email => _emailError != null || _emailDomainBlocked,
      _ContactField.phone => _phoneError != null,
      _ContactField.whatsapp => _whatsappError != null,
      _ => false,
    };
    if (hadError) {
      setState(() {
        switch (field) {
          case _ContactField.name:
            _nameError = null;
          case _ContactField.email:
            _emailError = null;
            _emailDomainBlocked = false;
          case _ContactField.phone:
            _phoneError = null;
          case _ContactField.whatsapp:
            _whatsappError = null;
          default:
            break;
        }
      });
    }
    _saveDraft();
  }

  void _onFieldBlur(_ContactField field) {
    switch (field) {
      case _ContactField.name:
        _validateName();
      case _ContactField.email:
        _validateEmail();
      case _ContactField.phone:
        _validatePhone();
      case _ContactField.whatsapp:
        _validateWhatsapp();
      default:
        break;
    }
  }

  void _validateName() {
    final name = _nameController.text.trim();
    setState(() {
      _nameError = name.isEmpty
          ? 'auto.t_0925fc6b3b'.tr()
          : name.length < 2
              ? 'auto.t_dd829b9c35'.tr()
              : null;
    });
  }

  /// The email is optional, but when present it must be well formed and not a
  /// throwaway-mail address.
  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      _emailDomainBlocked = false;
      if (email.isEmpty) {
        _emailError = null;
      } else if (!isValidContactEmail(email)) {
        _emailError = 'auto.t_96c47f9dfa'.tr();
      } else if (!isAllowedEmailDomain(email)) {
        _emailDomainBlocked = true;
        _emailError = 'auto.t_contact_email_blocked'.tr();
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePhone() {
    final phone = _phoneController.text.trim();
    setState(() {
      _phoneError = phone.isEmpty
          ? 'auto.t_e9030fa52c'.tr()
          : !_isValidPhone(phone)
              ? 'auto.t_dad81a3abf'.tr()
              : null;
    });
  }

  void _validateWhatsapp() {
    final whatsapp = _whatsappController.text.trim();
    setState(() {
      _whatsappError = whatsapp.isEmpty
          ? 'auto.t_5f52637da9'.tr()
          : !_isValidPhone(whatsapp)
              ? 'auto.t_8d87b0c1e6'.tr()
              : null;
    });
  }

  bool _isValidPhone(String value) {
    final cleaned = value.replaceAll(RegExp(r'[\s\-().]'), '');
    return RegExp(r'^0(10|11|12|15)\d{8}$').hasMatch(cleaned) ||
        RegExp(r'^(\+2|002)(010|011|012|015)\d{8}$').hasMatch(cleaned) ||
        RegExp(r'^\+\d{7,15}$').hasMatch(cleaned) ||
        RegExp(r'^0\d{6,14}$').hasMatch(cleaned);
  }

  // ── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submitForm() async {
    if (_isSubmitting || _cooldownSeconds > 0) return;
    FocusScope.of(context).unfocus();

    _validateName();
    _validateEmail();
    _validatePhone();
    _validateWhatsapp();

    final firstInvalid = [
      if (_nameError != null) _ContactField.name,
      if (_emailError != null) _ContactField.email,
      if (_phoneError != null) _ContactField.phone,
      if (_whatsappError != null) _ContactField.whatsapp,
    ].firstOrNull;
    if (firstInvalid != null) {
      _validationTimer?.cancel();
      setState(() => _showValidationBanner = true);
      _validationTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showValidationBanner = false);
      });
      final target = _fieldKeys[firstInvalid]?.currentContext;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          alignment: 0.15,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
      _showSuccess = false;
      _submitFailed = false;
    });

    final submittedEmail = _emailController.text.trim();
    final payload = {
      'access_key': _accessKey,
      'name': _nameController.text.trim(),
      'email': submittedEmail,
      'phone': _phoneController.text.trim(),
      'whatsapp': _whatsappController.text.trim(),
      'companyName': _businessController.text.trim(),
      'specialty': _specialtyController.text.trim(),
      'message': _messageController.text.trim(),
      'package': _package?.name ?? '',
      'price': _package?.price ?? '',
      'source': 'Etbaly Flutter App',
    };

    try {
      final response = await _dio.post<dynamic>(_formUrl, data: payload);
      final ok = response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;

      if (!ok) throw DioException(requestOptions: response.requestOptions);

      unawaited(_subscribeEmailSilently(submittedEmail));
      _resetForm();
      await ContactSession.recordSubmit();

      if (!mounted) return;
      setState(() => _showSuccess = true);
      _successTimer?.cancel();
      _successTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) setState(() => _showSuccess = false);
      });
      _startCooldown(ContactSession.cooldown);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitFailed = true);
      _failureTimer?.cancel();
      _failureTimer = Timer(const Duration(seconds: 10), () {
        if (mounted) setState(() => _submitFailed = false);
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _subscribeEmailSilently(String email) async {
    if (email.isEmpty) return;

    try {
      await _dio.post<dynamic>(
        _subscribeUrl,
        data: 'email=${Uri.encodeComponent(email)}'
            '&lang=${_isArabic ? 'ar' : 'en'}',
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );
    } catch (_) {
      // Newsletter subscription is a bonus after contact submit.
    }
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _whatsappController.clear();
    _businessController.clear();
    _specialtyController.clear();
    _messageController.clear();
    _package = null;
    ContactSession.clear();
    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _whatsappError = null;
      _emailDomainBlocked = false;
    });
  }
}

/// The form's inputs; also the keys for scrolling to a field that needs fixing.
enum _ContactField {
  name,
  email,
  phone,
  whatsapp,
  business,
  specialty,
  message
}

class _ContactHero extends StatefulWidget {
  const _ContactHero();

  @override
  State<_ContactHero> createState() => _ContactHeroState();
}

class _ContactHeroState extends State<_ContactHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 330.h),
      decoration: BoxDecoration(
        color: context.etbalyColors.bgSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ContactBackgroundPainter(progress: _controller.value),
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 42.h, 18.w, 34.h),
              child: Column(
                children: [
                  _WebBadge(
                          label: 'auto.t_9886382321'.tr(),
                          icon: Icons.send_rounded)
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 450))
                      .slideY(
                        begin: -0.25,
                        duration: const Duration(milliseconds: 450),
                      ),
                  SizedBox(height: 18.h),
                  Text(
                    'auto.t_0f6336ed48'.tr(),
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: context.etbalyColors.textMain,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                      fontSize: context.width < 390 ? 32 : 38,
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 90),
                        duration: const Duration(milliseconds: 520),
                      )
                      .slideY(
                        begin: 0.18,
                        delay: const Duration(milliseconds: 90),
                        duration: const Duration(milliseconds: 520),
                      ),
                  SizedBox(height: 20.h),
                  _AnimatedGoldFrame(
                    progress: _controller.value,
                    child: Container(
                      width: math.min(context.width - 58, 520),
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: context.etbalyColors.bgCard,
                        borderRadius: BorderRadius.circular(17.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x3328155E),
                            blurRadius: 28.r,
                            offset: Offset(0.w, 14.h),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'auto.t_e6899218c8'.tr(),
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.etbalyColors.textMain,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          EtbalyWebGoldDivider(width: 120.w),
                          SizedBox(height: 12.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.etbalyColors.textMuted,
                                height: 1.55,
                              ),
                              children: [
                                TextSpan(text: 'auto.t_54b9db9b2e'.tr()),
                                TextSpan(
                                  text: 'auto.t_cc10003c5c'.tr(),
                                  style: const TextStyle(
                                    color: EtbalyWebColors.gold,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(text: 'auto.t_cab8379b19'.tr()),
                                TextSpan(
                                  text: 'auto.t_7d2e3e23d6'.tr(),
                                  style: const TextStyle(
                                    color: Color(0xFFE8C878),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8.r,
                            runSpacing: 8.r,
                            children: [
                              Text(
                                'auto.t_contact_talk_today'.tr(),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.etbalyColors.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              _MiniPill(text: 'auto.t_d9f0ff2067'.tr()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 180),
                        duration: const Duration(milliseconds: 560),
                      )
                      .slideY(
                        begin: 0.12,
                        delay: const Duration(milliseconds: 180),
                        duration: const Duration(milliseconds: 560),
                      ),
                  SizedBox(height: 20.h),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.r,
                    runSpacing: 10.r,
                    children: [
                      _HeroStat(
                          icon: Icons.timer_rounded,
                          text: 'auto.t_e0b1480986'.tr()),
                      _HeroStat(
                          icon: Icons.shield_rounded,
                          text: 'auto.t_637c01de60'.tr()),
                      _HeroStat(
                          icon: Icons.headset_mic_rounded,
                          text: 'auto.t_27212b9ed6'.tr()),
                    ],
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 280),
                        duration: const Duration(milliseconds: 520),
                      )
                      .slideY(
                        begin: 0.16,
                        delay: const Duration(milliseconds: 280),
                        duration: const Duration(milliseconds: 520),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 450)).slideY(
          begin: 0.05,
          duration: const Duration(milliseconds: 450),
        );
  }
}

class _ContactFormCard extends StatelessWidget {
  const _ContactFormCard({
    required this.fieldKeys,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.whatsappController,
    required this.businessController,
    required this.specialtyController,
    required this.messageController,
    required this.nameError,
    required this.emailError,
    required this.phoneError,
    required this.whatsappError,
    required this.emailDomainBlocked,
    required this.package,
    required this.showSuccess,
    required this.showValidationBanner,
    required this.submitFailed,
    required this.cooldownSeconds,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onChanged,
    required this.onBlur,
    required this.onChangePackage,
    required this.onRemovePackage,
  });

  final Map<_ContactField, GlobalKey> fieldKeys;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController whatsappController;
  final TextEditingController businessController;
  final TextEditingController specialtyController;
  final TextEditingController messageController;
  final String? nameError;
  final String? emailError;
  final String? phoneError;
  final String? whatsappError;
  final bool emailDomainBlocked;
  final SelectedPackage? package;
  final bool showSuccess;
  final bool showValidationBanner;
  final bool submitFailed;
  final int cooldownSeconds;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final ValueChanged<_ContactField> onChanged;
  final ValueChanged<_ContactField> onBlur;
  final VoidCallback onChangePackage;
  final VoidCallback onRemovePackage;

  @override
  Widget build(BuildContext context) {
    final cardPadding = context.width < 390 ? 16.r : 20.r;

    Widget field(
      _ContactField id, {
      required String label,
      required String hint,
      required Object icon,
      required TextEditingController controller,
      String? error,
      TextInputType? keyboardType,
      Color? iconColor,
      int minLines = 1,
      int maxLines = 1,
      bool validateOnBlur = true,
    }) {
      return _ContactTextField(
        fieldKey: fieldKeys[id],
        label: label,
        hint: hint,
        icon: icon,
        iconColor: iconColor,
        keyboardType: keyboardType,
        controller: controller,
        errorText: error,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: () => onChanged(id),
        onBlur: validateOnBlur ? () => onBlur(id) : null,
      );
    }

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: context.etbalyColors.bgCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.etbalyColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66000000),
            blurRadius: 26.r,
            offset: Offset(0.w, 16.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _SquareIcon(icon: Icons.send_rounded),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'auto.t_8a31c1a876'.tr(),
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.etbalyColors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'auto.t_604899061b'.tr(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.etbalyColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(color: context.etbalyColors.borderColor, height: 1.h),
          SizedBox(height: 20.h),
          _ResponsiveFields(
            children: [
              field(
                _ContactField.name,
                label: 'auto.t_e19b16bdb7'.tr(),
                hint: 'auto.t_462426235d'.tr(),
                icon: Icons.person_rounded,
                controller: nameController,
                error: nameError,
              ),
              Column(
                children: [
                  field(
                    _ContactField.email,
                    label: 'auto.t_73698845ba'.tr(),
                    hint: 'auto.t_373bbbafbb'.tr(),
                    icon: Icons.mail_rounded,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    error: emailError,
                  ),
                  if (emailDomainBlocked) const _EmailSuggestCard(),
                ],
              ),
              field(
                _ContactField.phone,
                label: 'auto.t_e32f70222a'.tr(),
                hint: 'auto.t_9037988ed7'.tr(),
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                controller: phoneController,
                error: phoneError,
              ),
              field(
                _ContactField.whatsapp,
                label: '${'auto.t_7b5629bcb4'.tr()} *',
                hint: 'auto.t_1c84106115'.tr(),
                icon: FontAwesomeIcons.whatsapp,
                iconColor: const Color(0xFF25D366),
                keyboardType: TextInputType.phone,
                controller: whatsappController,
                error: whatsappError,
              ),
              field(
                _ContactField.business,
                label: 'auto.t_869ea5ba41'.tr(),
                hint: 'auto.t_7315f53e4a'.tr(),
                icon: Icons.storefront_rounded,
                controller: businessController,
                validateOnBlur: false,
              ),
              field(
                _ContactField.specialty,
                label: 'auto.t_7e204f3892'.tr(),
                hint: 'auto.t_28489e99c1'.tr(),
                icon: Icons.sell_rounded,
                controller: specialtyController,
                validateOnBlur: false,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const _PackageDivider(),
          SizedBox(height: 14.h),
          if (package != null)
            _PackageSelectedBox(
              package: package!,
              onChange: onChangePackage,
              onRemove: onRemovePackage,
            )
          else
            _PackageEmptyBox(onPick: onChangePackage),
          SizedBox(height: 18.h),
          field(
            _ContactField.message,
            label: 'auto.t_1752e5546d'.tr(),
            hint: 'auto.t_e8c347a148'.tr(),
            icon: Icons.chat_bubble_rounded,
            controller: messageController,
            minLines: 4,
            maxLines: 6,
            validateOnBlur: false,
          ),
          if (showSuccess) ...[
            SizedBox(height: 14.h),
            _FormAlert(
              kind: _AlertKind.success,
              message: 'auto.t_contact_success'.tr(),
            ),
          ],
          if (showValidationBanner) ...[
            SizedBox(height: 14.h),
            _FormAlert(
              kind: _AlertKind.error,
              message: 'auto.t_contact_validation'.tr(),
            ),
          ],
          if (submitFailed) ...[
            SizedBox(height: 14.h),
            _FormAlert(
              kind: _AlertKind.error,
              message: 'auto.t_contact_submit_error'.tr(),
              actionLabel: 'auto.t_7b5629bcb4'.tr(),
              onAction: () => _open(_whatsappUrl),
            ),
          ],
          if (cooldownSeconds > 0) ...[
            SizedBox(height: 14.h),
            _FormAlert(
              kind: _AlertKind.warn,
              message: 'auto.t_contact_cooldown'
                  .tr(namedArgs: {'time': '$cooldownSeconds'}),
            ),
          ],
          SizedBox(height: 20.h),
          _SubmitGradientButton(
            isSubmitting: isSubmitting,
            isDisabled: cooldownSeconds > 0,
            onTap: onSubmit,
          ),
        ],
      ),
    );
  }
}

class _ContactInfoColumn extends StatelessWidget {
  const _ContactInfoColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactChannelCard(
          label: 'auto.t_7b5629bcb4'.tr(),
          value: '+201010285020',
          subtitle: 'auto.t_a6e45fe589'.tr(),
          icon: FontAwesomeIcons.whatsapp,
          color: const Color(0xFF25D366),
          pulse: true,
          onTap: () => _open(_whatsappUrl),
        ),
        _ContactChannelCard(
          label: 'auto.t_ac86ec8e2a'.tr(),
          value: 'auto.t_e2731f0b11'.tr(),
          subtitle: 'auto.t_fce036ec2a'.tr(),
          icon: FontAwesomeIcons.facebookF,
          color: const Color(0xFF1877F2),
          onTap: () =>
              _open('https://www.facebook.com/etba3lydigitalmarketing'),
        ),
        _ContactChannelCard(
          label: 'auto.t_0915ef8ea5'.tr(),
          value: 'support@etba3ly-dm.com',
          subtitle: 'auto.t_d35d3e7a1b'.tr(),
          icon: Icons.mail_rounded,
          color: EtbalyWebColors.gold,
          onTap: () => _open('mailto:support@etba3ly-dm.com'),
        ),
        _ContactChannelCard(
          label: 'auto.t_42d151cf6f'.tr(),
          value: '@etba3ly2022',
          subtitle: 'auto.t_e3b0c2a6a0'.tr(),
          icon: FontAwesomeIcons.instagram,
          color: const Color(0xFFE4405F),
          onTap: () => _open('https://www.instagram.com/etba3ly2022'),
        ),
        _ContactChannelCard(
          label: 'auto.t_2c6de2dad3'.tr(),
          value: '@etba3ly4adv',
          subtitle: 'auto.t_db2f568d09'.tr(),
          icon: FontAwesomeIcons.youtube,
          color: const Color(0xFFFF0000),
          onTap: () => _open('https://www.youtube.com/@etba3ly4adv'),
        ),
        _ContactChannelCard(
          label: 'auto.t_5f19dfe113'.tr(),
          value: '@etba3ly2',
          subtitle: 'auto.t_c98cad67e9'.tr(),
          icon: FontAwesomeIcons.tiktok,
          color: EtbalyWebColors.purple,
          onTap: () => _open('https://www.tiktok.com/@etba3ly2'),
        ),
        _ContactChannelCard(
          label: 'auto.t_snapchat_label'.tr(),
          value: '@etba3ly',
          subtitle: 'auto.t_snapchat_sub'.tr(),
          icon: FontAwesomeIcons.snapchat,
          color: const Color(0xFFFFFC00),
          onTap: () => _open('https://www.snapchat.com/@etba3ly'),
        ),
        _ContactChannelCard(
          label: 'auto.t_9e63c17fd2'.tr(),
          value: '@etba3ly_studio',
          subtitle: 'auto.t_2abf9dd7fb'.tr(),
          icon: FontAwesomeIcons.telegram,
          color: const Color(0xFF229ED9),
          onTap: () => _open('https://t.me/etba3ly_studio'),
        ),
        _ContactChannelCard(
          label: 'auto.t_linkedin_label'.tr(),
          value: 'etba3ly-digital-marketing',
          subtitle: 'auto.t_linkedin_sub'.tr(),
          icon: FontAwesomeIcons.linkedinIn,
          color: const Color(0xFF0A66C2),
          onTap: () => _open(
            'https://www.linkedin.com/company/etba3ly-digital-marketing',
          ),
        ),
        const _HoursCard(),
      ],
    ).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideX(
          begin: -0.04,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
  }
}

class _ContactChannelCard extends StatelessWidget {
  const _ContactChannelCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.pulse = false,
  });

  final String label;
  final String value;
  final String subtitle;
  final Object icon;
  final Color color;
  final VoidCallback onTap;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: context.etbalyColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: context.etbalyColors.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.06),
                      blurRadius: 22.r,
                      offset: Offset(0.w, 12.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            Border.all(color: color.withValues(alpha: 0.32)),
                      ),
                      child: Center(
                        child: icon is FaIconData
                            ? FaIcon(icon as FaIconData,
                                color: color, size: 22.sp)
                            : Icon(icon as IconData, color: color, size: 22.sp),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.etbalyColors.textMuted,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            value,
                            textDirection: value.startsWith('+') ||
                                    value.startsWith('@') ||
                                    value.contains('@')
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: context.etbalyColors.textMain,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            subtitle,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.etbalyColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: context.etbalyColors.textMuted,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
              if (pulse)
                PositionedDirectional(
                  top: 12.h,
                  end: 12,
                  child: _PulseDot(color: color),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitGradientButton extends StatelessWidget {
  const _SubmitGradientButton({
    required this.isSubmitting,
    required this.onTap,
    this.isDisabled = false,
  });

  final bool isSubmitting;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The shadow lives on a DecoratedBox outside the Material: `Ink` paints
    // inside the Material's bounds and would clip it into a rectangle.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: EtbalyWebColors.gold.withValues(alpha: 0.26),
            blurRadius: 26.r,
            offset: Offset(0.w, 10.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (isSubmitting || isDisabled) ? null : onTap,
          borderRadius: BorderRadius.circular(999.r),
          child: Ink(
            height: 54.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999.r),
              gradient: LinearGradient(
                colors: (isSubmitting || isDisabled)
                    ? [
                        EtbalyWebColors.gold.withValues(alpha: 0.48),
                        EtbalyWebColors.gold.withValues(alpha: 0.72),
                      ]
                    : [
                        const Color(0xFFB8922A),
                        EtbalyWebColors.gold,
                        const Color(0xFFE8C878),
                      ],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSubmitting)
                    SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.r,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF1A1501),
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_back_rounded,
                      color: const Color(0xFF1A1501),
                      size: 20.sp,
                    ),
                  SizedBox(width: 10.w),
                  Text(
                    isSubmitting
                        ? 'auto.t_b303cc20c1'.tr()
                        : 'auto.t_c43aa55fa9'.tr(),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF1A1501),
                      fontWeight: FontWeight.w900,
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

class _PulseDot extends StatelessWidget {
  const _PulseDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.7),
            blurRadius: 10.r,
            spreadRadius: 3.r,
          ),
        ],
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: Offset(0.72.w, 0.72.h),
          end: Offset(1.25.w, 1.25.h),
          duration: const Duration(milliseconds: 900),
        )
        .fade(
          begin: 0.65,
          end: 1,
          duration: const Duration(milliseconds: 900),
        );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.etbalyColors.bgSecondary,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  color: EtbalyWebColors.gold, size: 19.sp),
              SizedBox(width: 8.w),
              Text(
                'auto.t_0be90459f2'.tr(),
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.etbalyColors.textMain,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Office hours.
          _HoursGroupLabel(
            icon: Icon(Icons.apartment_rounded,
                color: EtbalyWebColors.gold, size: 15.sp),
            label: 'auto.t_f7e554583d'.tr(),
            color: EtbalyWebColors.gold,
          ),
          SizedBox(height: 10.h),
          _HoursRow(
            label: 'auto.t_9c43f9b4ee'.tr(),
            value: 'auto.t_10c46d4ef8'.tr(),
          ),
          _HoursRow(
            label: 'auto.t_8d067a376a'.tr(),
            value: 'auto.t_e944ebd608'.tr(),
            warning: true,
          ),
          Divider(color: context.etbalyColors.borderColor, height: 26.h),
          // Online support.
          _HoursGroupLabel(
            icon: Container(
              width: 7.w,
              height: 7.h,
              decoration: const BoxDecoration(
                color: EtbalyWebColors.green,
                shape: BoxShape.circle,
              ),
            ),
            label: 'auto.t_hours_online'.tr(),
            color: EtbalyWebColors.green,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'auto.t_hours_every_day'.tr(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.etbalyColors.textMuted,
                  ),
                ),
              ),
              const _MiniPill(text: '24/7', green: true),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.whatsapp,
                  color: const Color(0xFF25D366), size: 14.sp),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  'auto.t_hours_wa_note'.tr(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.etbalyColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HoursGroupLabel extends StatelessWidget {
  const _HoursGroupLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final Widget icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16.w, child: Center(child: icon)),
        SizedBox(width: 7.w),
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _HoursRow extends StatelessWidget {
  const _HoursRow({
    required this.label,
    required this.value,
    this.warning = false,
  });

  final String label;
  final String value;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.etbalyColors.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              color: warning ? const Color(0xFFFF6B6B) : EtbalyWebColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapSection extends StatefulWidget {
  const _MapSection();

  @override
  State<_MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<_MapSection> {
  late final WebViewController _mapCtrl;
  bool _mapLoaded = false;

  static const _embedHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; overflow: hidden; background: #1a1a2e; }
    iframe { display: block; width: 100%; height: 100%; border: none; }
  </style>
</head>
<body>
  <iframe
    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d359.1200937378907!2d29.754102770189352!3d31.094570914184775!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14f5c3c361fd4617%3A0xc29b8d30dfb8a980!2z2KfYt9pi2LnZhNmKINmE2YLYr9i52KfZitipINmI2KfZhNil2LnZhNin2YY!5e0!3m2!1sar!2seg!4v1781724241984!5m2!1sar!2seg"
    allowfullscreen
    loading="lazy">
  </iframe>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();
    _mapCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _mapLoaded = true);
        },
      ))
      ..loadHtmlString(_embedHtml);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.etbalyColors.bgCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.etbalyColors.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 18.h),
            child: Column(
              children: [
                _WebBadge(
                  label: 'auto.t_320910a8ba'.tr(),
                  icon: Icons.location_on_rounded,
                ),
                SizedBox(height: 14.h),
                Text(
                  'auto.t_acd4a23c87'.tr(),
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.etbalyColors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'auto.t_6cde5c70d7'.tr(),
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.etbalyColors.textMuted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const _MapInfoStrip(),
          SizedBox(
            height: 260.h,
            width: double.infinity,
            child: Stack(
              children: [
                WebViewWidget(controller: _mapCtrl),
                if (!_mapLoaded)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4AF37),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Wrap(
              spacing: 10.r,
              runSpacing: 10.r,
              alignment: WrapAlignment.center,
              children: [
                _OutlinedAction(
                  label: 'auto.t_d2c8cef56d'.tr(),
                  icon: Icons.directions_rounded,
                  onTap: () =>
                      _open('https://maps.app.goo.gl/kHdWiv47KVqSdRgd8'),
                ),
                _OutlinedAction(
                  label: 'auto.t_a3326e7683'.tr(),
                  icon: FontAwesomeIcons.whatsapp,
                  color: const Color(0xFF25D366),
                  onTap: () => _open(_whatsappUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapInfoStrip extends StatelessWidget {
  const _MapInfoStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.etbalyColors.bgSecondary,
        border: Border(
          top: BorderSide(color: context.etbalyColors.borderColor),
          bottom: BorderSide(color: context.etbalyColors.borderColor),
        ),
      ),
      child: Wrap(
        spacing: 14.r,
        runSpacing: 8.r,
        alignment: WrapAlignment.center,
        children: [
          _MapInfoItem(
              icon: Icons.location_on_rounded, text: 'auto.t_19c155b158'.tr()),
          _MapInfoItem(
              icon: Icons.schedule_rounded, text: 'auto.t_0069eb3e9e'.tr()),
          const _MapInfoItem(icon: Icons.phone_rounded, text: '+201010285020'),
        ],
      ),
    );
  }
}

class _MapInfoItem extends StatelessWidget {
  const _MapInfoItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: EtbalyWebColors.gold, size: 16.sp),
        SizedBox(width: 6.w),
        Text(
          text,
          textDirection:
              text.startsWith('+') ? TextDirection.ltr : TextDirection.rtl,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.etbalyColors.textMuted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620 ? 2 : 1;
        const gap = 12.0;
        final width = (constraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: 14.r,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

class _ContactTextField extends StatelessWidget {
  const _ContactTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.onChanged,
    this.onBlur,
    this.fieldKey,
    this.errorText,
    this.keyboardType,
    this.iconColor,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final Object icon;
  final TextEditingController controller;
  final VoidCallback onChanged;

  /// Runs when the field loses focus (the website validates on blur).
  final VoidCallback? onBlur;
  final Key? fieldKey;
  final String? errorText;
  final TextInputType? keyboardType;
  final Color? iconColor;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      key: fieldKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon is FaIconData
                ? FaIcon(icon as FaIconData,
                    size: 15.sp,
                    color: iconColor ?? context.etbalyColors.textMuted)
                : Icon(icon as IconData,
                    size: 15.sp,
                    color: iconColor ?? context.etbalyColors.textMuted),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.etbalyColors.textMuted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) onBlur?.call();
          },
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            minLines: minLines,
            maxLines: maxLines,
            textInputAction:
                maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
            onChanged: (_) => onChanged(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.etbalyColors.textMain,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: context.textTheme.bodySmall?.copyWith(
                color: context.etbalyColors.textLight,
              ),
              filled: true,
              fillColor: context.etbalyColors.bgSubtle,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: hasError
                      ? const Color(0xFFFF6B6B)
                      : EtbalyWebColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color:
                      hasError ? const Color(0xFFFF6B6B) : EtbalyWebColors.gold,
                ),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 13.sp,
                  color: const Color(0xFFFF8A8A),
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  errorText!,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFFF8A8A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// "Selected Package" label with hairlines, as on the website's form.
class _PackageDivider extends StatelessWidget {
  const _PackageDivider();

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(color: context.etbalyColors.borderColor, height: 1),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'auto.t_contact_pkg_title'.tr(),
            style: context.textTheme.labelMedium?.copyWith(
              color: context.etbalyColors.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

class _PackageEmptyBox extends StatelessWidget {
  const _PackageEmptyBox({required this.onPick});

  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.etbalyColors.bgSubtle,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: EtbalyWebColors.gold.withValues(alpha: 0.36),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: EtbalyWebColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: EtbalyWebColors.gold,
              size: 21.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'auto.t_80a0344904'.tr(),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.etbalyColors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'auto.t_9b84bd8cbe'.tr(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.etbalyColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onPick,
            icon: Icon(Icons.arrow_back_rounded, size: 17.sp),
            label: Text('auto.t_ac442fdb57'.tr()),
            style: TextButton.styleFrom(
              foregroundColor: EtbalyWebColors.gold,
              textStyle: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The package picked on the services tab, with "Change" and "Remove".
class _PackageSelectedBox extends StatelessWidget {
  const _PackageSelectedBox({
    required this.package,
    required this.onChange,
    required this.onRemove,
  });

  final SelectedPackage package;
  final VoidCallback onChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    Widget action({
      required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: color.withValues(alpha: 0.5)),
            color: color.withValues(alpha: 0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: color),
              SizedBox(width: 6.w),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: EtbalyWebColors.gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: EtbalyWebColors.gold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: EtbalyWebColors.gold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: EtbalyWebColors.gold,
                  size: 21.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.category,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      package.name,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: colors.textMain,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (package.price != null) ...[
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sell_rounded,
                              size: 13.sp, color: EtbalyWebColors.gold),
                          SizedBox(width: 5.w),
                          Text(
                            '${package.price} EGP',
                            textDirection: TextDirection.ltr,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: EtbalyWebColors.gold,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const _MiniPill(text: '✓', green: true),
              action(
                icon: Icons.sync_rounded,
                label: 'auto.t_contact_pkg_change'.tr(),
                color: EtbalyWebColors.gold,
                onTap: onChange,
              ),
              action(
                icon: Icons.close_rounded,
                label: 'auto.t_contact_pkg_remove'.tr(),
                color: const Color(0xFFFF6B6B),
                onTap: onRemove,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shown under the email field when its domain is a throwaway-mail service.
class _EmailSuggestCard extends StatelessWidget {
  const _EmailSuggestCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: EtbalyWebColors.gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: EtbalyWebColors.gold.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded,
                  size: 16.sp, color: EtbalyWebColors.gold),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  'auto.t_contact_email_try'.tr(),
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.etbalyColors.textMain,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            children: [
              _OutlinedAction(
                label: 'Gmail',
                icon: FontAwesomeIcons.google,
                color: const Color(0xFFEA4335),
                onTap: () => _open('https://mail.google.com'),
              ),
              _OutlinedAction(
                label: 'Outlook',
                icon: FontAwesomeIcons.microsoft,
                color: const Color(0xFF0078D4),
                onTap: () => _open('https://outlook.live.com'),
              ),
              _OutlinedAction(
                label: 'Yahoo',
                icon: FontAwesomeIcons.yahoo,
                color: const Color(0xFF7B3FF2),
                onTap: () => _open('https://mail.yahoo.com'),
              ),
              _OutlinedAction(
                label: 'Proton',
                icon: Icons.mail_lock_rounded,
                color: const Color(0xFF6D4AFF),
                onTap: () => _open('https://proton.me/mail'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _AlertKind { success, error, warn }

class _FormAlert extends StatelessWidget {
  const _FormAlert({
    required this.message,
    required this.kind,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final _AlertKind kind;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = switch (kind) {
      _AlertKind.success => EtbalyWebColors.green,
      _AlertKind.error => const Color(0xFFFF6B6B),
      _AlertKind.warn => const Color(0xFFF59E0B),
    };
    final icon = switch (kind) {
      _AlertKind.success => Icons.check_circle_rounded,
      _AlertKind.error => Icons.error_outline_rounded,
      _AlertKind.warn => Icons.hourglass_bottom_rounded,
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.34)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                height: 1.4,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(width: 8.w),
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(999.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(color: const Color(0xFF25D366)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(FontAwesomeIcons.whatsapp,
                        size: 13.sp, color: const Color(0xFF25D366)),
                    SizedBox(width: 5.w),
                    Text(
                      actionLabel!,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF25D366),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  const _OutlinedAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = EtbalyWebColors.gold,
  });

  final String label;
  final Object icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: color.withValues(alpha: 0.62)),
            color: color.withValues(alpha: 0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon is FaIconData
                  ? FaIcon(icon as FaIconData, color: color, size: 17.sp)
                  : Icon(icon as IconData, color: color, size: 17.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: color,
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

class _WebBadge extends StatelessWidget {
  const _WebBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.etbalyColors.badgeBg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: EtbalyWebColors.gold, size: 15.sp),
          SizedBox(width: 7.w),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: EtbalyWebColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 5.w,
            height: 5.h,
            decoration: const BoxDecoration(
              color: EtbalyWebColors.gold,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.etbalyColors.badgeBg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: EtbalyWebColors.gold, size: 16.sp),
          SizedBox(width: 7.w),
          Text(
            text,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.etbalyColors.textMuted,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.text, this.green = false});

  final String text;
  final bool green;

  @override
  Widget build(BuildContext context) {
    final color = green ? EtbalyWebColors.green : EtbalyWebColors.gold;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withValues(alpha: 0.38)),
      ),
      child: Text(
        text,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SquareIcon extends StatelessWidget {
  const _SquareIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: EtbalyWebColors.gold.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Icon(icon, color: EtbalyWebColors.gold, size: 24.sp),
    );
  }
}

class _AnimatedGoldFrame extends StatelessWidget {
  const _AnimatedGoldFrame({
    required this.progress,
    required this.child,
  });

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GoldFramePainter(progress: progress),
      child: Padding(
        padding: EdgeInsets.all(2.r),
        child: child,
      ),
    );
  }
}

class _GoldFramePainter extends CustomPainter {
  _GoldFramePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(18.r));
    final sweep = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      transform: GradientRotation(progress * math.pi * 2),
      colors: const [
        Colors.transparent,
        Color(0xFFD4AF37),
        Color(0xFFFFE08A),
        Color(0xFFD4AF37),
        Colors.transparent,
        Color(0x66B8922A),
        Colors.transparent,
      ],
      stops: const [0, 0.18, 0.27, 0.36, 0.52, 0.76, 1],
    );

    final paint = Paint()
      ..shader = sweep.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7;

    canvas.drawRRect(rrect.deflate(0.9), paint);
  }

  @override
  bool shouldRepaint(covariant _GoldFramePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ContactBackgroundPainter extends CustomPainter {
  _ContactBackgroundPainter({this.progress = 0});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    _drawOrb(
      canvas,
      Offset(
        size.width * (0.86 + math.sin(progress * math.pi * 2) * 0.025),
        size.height * (0.02 + math.cos(progress * math.pi * 2) * 0.035),
      ),
      210,
      EtbalyWebColors.gold.withValues(alpha: 0.13),
    );
    _drawOrb(
      canvas,
      Offset(
        size.width * (0.08 + math.cos(progress * math.pi * 2) * 0.025),
        size.height * (0.86 + math.sin(progress * math.pi * 2) * 0.035),
      ),
      170,
      EtbalyWebColors.gold.withValues(alpha: 0.08),
    );
    _drawOrb(
      canvas,
      Offset(
        size.width * (0.32 + math.sin(progress * math.pi * 4) * 0.02),
        size.height * (0.46 + math.cos(progress * math.pi * 4) * 0.025),
      ),
      110,
      EtbalyWebColors.purple.withValues(alpha: 0.06),
    );

    final gridPaint = Paint()
      ..color = EtbalyWebColors.grid
      ..strokeWidth = 1;
    const gap = 42.0;

    for (var x = 0.0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final linePaint = Paint()
      ..color = EtbalyWebColors.gold.withValues(alpha: 0.14)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 5; i++) {
      final baseY = size.height * (0.22 + i * 0.15);
      final offset = ((progress + i * 0.18) % 1) * size.width * 2;
      canvas.drawLine(
        Offset(size.width - offset, baseY),
        Offset(size.width * 1.35 - offset, baseY),
        linePaint,
      );
    }
  }

  void _drawOrb(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _ContactBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

Future<void> _open(String url) async {
  final uri = Uri.parse(url);
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened) {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}

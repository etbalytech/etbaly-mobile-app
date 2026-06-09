import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  static const _formUrl = 'https://api.web3forms.com/submit';
  static const _subscribeUrl =
      'https://corsproxy.io/?url=https://etba3ly-api.xo.je/subscribe.php';
  static const _accessKey = 'eef10318-b29e-4033-b122-535fe44348f1';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _businessController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _messageController = TextEditingController();

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
  String? _successMessage;
  String? _errorMessage;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _whatsappError;

  @override
  void dispose() {
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

  Widget _buildMainLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 820;
        final form = _ContactFormCard(
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
          successMessage: _successMessage,
          errorMessage: _errorMessage,
          isSubmitting: _isSubmitting,
          onSubmit: _submitForm,
          onChanged: _clearMessages,
        );
        const channels = _ContactInfoColumn();

        if (!wide) {
          return Column(
            children: [
              form,
              SizedBox(height: 18.h),
              channels,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: form),
            SizedBox(width: 18.w),
            const Expanded(flex: 4, child: channels),
          ],
        );
      },
    );
  }

  void _clearMessages() {
    if (_successMessage == null && _errorMessage == null) return;
    setState(() {
      _successMessage = null;
      _errorMessage = null;
    });
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    final valid = _validate();
    if (!valid) {
      setState(() {
        _successMessage = null;
        _errorMessage = 'auto.t_feeba6be8f'.tr();
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _successMessage = null;
      _errorMessage = null;
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
      'package': '',
      'price': '',
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

      if (!mounted) return;
      setState(() {
        _successMessage = 'auto.t_8156a21ea5'.tr();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'auto.t_4071062caa'.tr();
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
        data: 'email=${Uri.encodeComponent(email)}&lang=ar',
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );
    } catch (_) {
      // Newsletter subscription is a bonus after contact submit.
    }
  }

  bool _validate() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final whatsapp = _whatsappController.text.trim();

    setState(() {
      _nameError = name.isEmpty
          ? 'auto.t_0925fc6b3b'.tr()
          : name.length < 2
              ? 'auto.t_dd829b9c35'.tr()
              : null;
      _emailError = email.isNotEmpty && !_isValidEmail(email)
          ? 'auto.t_96c47f9dfa'.tr()
          : null;
      _phoneError = phone.isEmpty
          ? 'auto.t_e9030fa52c'.tr()
          : !_isValidPhone(phone)
              ? 'auto.t_dad81a3abf'.tr()
              : null;
      _whatsappError = whatsapp.isEmpty
          ? 'auto.t_5f52637da9'.tr()
          : !_isValidPhone(whatsapp)
              ? 'auto.t_8d87b0c1e6'.tr()
              : null;
    });

    return _nameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _whatsappError == null;
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  }

  bool _isValidPhone(String value) {
    final cleaned = value.replaceAll(RegExp(r'[\s\-().]'), '');
    return RegExp(r'^0(10|11|12|15)\d{8}$').hasMatch(cleaned) ||
        RegExp(r'^(\+2|002)(010|011|012|015)\d{8}$').hasMatch(cleaned) ||
        RegExp(r'^\+\d{7,15}$').hasMatch(cleaned) ||
        RegExp(r'^0\d{6,14}$').hasMatch(cleaned);
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _whatsappController.clear();
    _businessController.clear();
    _specialtyController.clear();
    _messageController.clear();
    _nameError = null;
    _emailError = null;
    _phoneError = null;
    _whatsappError = null;
  }
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
                          _MiniPill(text: 'auto.t_d9f0ff2067'.tr()),
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
    required this.successMessage,
    required this.errorMessage,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onChanged,
  });

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
  final String? successMessage;
  final String? errorMessage;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final cardPadding = context.width < 390 ? 16.r : 20.r;

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
              _ContactTextField(
                label: 'auto.t_e19b16bdb7'.tr(),
                hint: 'auto.t_462426235d'.tr(),
                icon: Icons.person_rounded,
                controller: nameController,
                errorText: nameError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'auto.t_73698845ba'.tr(),
                hint: 'auto.t_373bbbafbb'.tr(),
                icon: Icons.mail_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                errorText: emailError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'auto.t_e32f70222a'.tr(),
                hint: 'auto.t_9037988ed7'.tr(),
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                controller: phoneController,
                errorText: phoneError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'auto.t_7b5629bcb4'.tr(),
                hint: 'auto.t_1c84106115'.tr(),
                icon: FontAwesomeIcons.whatsapp,
                iconColor: const Color(0xFF25D366),
                keyboardType: TextInputType.phone,
                controller: whatsappController,
                errorText: whatsappError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'auto.t_869ea5ba41'.tr(),
                hint: 'auto.t_7315f53e4a'.tr(),
                icon: Icons.storefront_rounded,
                controller: businessController,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'auto.t_7e204f3892'.tr(),
                hint: 'auto.t_28489e99c1'.tr(),
                icon: Icons.sell_rounded,
                controller: specialtyController,
                onChanged: onChanged,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          const _PackageEmptyBox(),
          SizedBox(height: 18.h),
          _ContactTextField(
            label: 'auto.t_1752e5546d'.tr(),
            hint: 'auto.t_e8c347a148'.tr(),
            icon: Icons.chat_bubble_rounded,
            controller: messageController,
            minLines: 4,
            maxLines: 6,
            onChanged: onChanged,
          ),
          if (successMessage != null || errorMessage != null) ...[
            SizedBox(height: 14.h),
            _FormAlert(
              message: successMessage ?? errorMessage!,
              isSuccess: successMessage != null,
            ),
          ],
          SizedBox(height: 20.h),
          _SubmitGradientButton(
            isSubmitting: isSubmitting,
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
          onTap: () => _open('https://wa.me/01010285020'),
        ),
        _ContactChannelCard(
          label: 'auto.t_ac86ec8e2a'.tr(),
          value: 'auto.t_e2731f0b11'.tr(),
          subtitle: 'auto.t_fce036ec2a'.tr(),
          icon: FontAwesomeIcons.facebookF,
          color: const Color(0xFF1877F2),
          onTap: () => _open('https://www.facebook.com/share/1Gw1i4iuXq'),
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
          label: 'auto.t_9e63c17fd2'.tr(),
          value: '@etba3ly_studio',
          subtitle: 'auto.t_2abf9dd7fb'.tr(),
          icon: FontAwesomeIcons.telegram,
          color: const Color(0xFF229ED9),
          onTap: () => _open('https://t.me/etba3ly_studio'),
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
  final IconData icon;
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
                      child: Icon(icon, color: color, size: 22.sp),
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
  });

  final bool isSubmitting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSubmitting ? null : onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          height: 54.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            gradient: LinearGradient(
              colors: isSubmitting
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
            boxShadow: [
              BoxShadow(
                color: EtbalyWebColors.gold.withValues(alpha: 0.26),
                blurRadius: 26.r,
                offset: Offset(0.w, 10.h),
              ),
            ],
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
          _HoursRow(
              label: 'auto.t_f7e554583d'.tr(), value: 'auto.t_9c43f9b4ee'.tr()),
          _HoursRow(
              label: 'auto.t_b4e73ac2bc'.tr(), value: 'auto.t_10c46d4ef8'.tr()),
          _HoursRow(
              label: 'auto.t_8d067a376a'.tr(),
              value: 'auto.t_e944ebd608'.tr(),
              warning: true),
          Divider(color: context.etbalyColors.borderColor, height: 26.h),
          Row(
            children: [
              Container(
                width: 7.w,
                height: 7.h,
                decoration: const BoxDecoration(
                  color: EtbalyWebColors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'auto.t_98017f5ce6'.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: EtbalyWebColors.green,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              const _MiniPill(text: '24/7', green: true),
            ],
          ),
        ],
      ),
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

class _MapSection extends StatelessWidget {
  const _MapSection();

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
          ClipRect(
            child: SizedBox(
              height: 260.h,
              width: double.infinity,
              child: CustomPaint(
                painter: _MapPreviewPainter(),
                child: Center(
                  child: Container(
                    width: 54.w,
                    height: 54.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_pin,
                      color: const Color(0xFFE53935),
                      size: 42.sp,
                    ),
                  ),
                ),
              ),
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
                      _open('https://maps.google.com/?q=31.094632,29.753261'),
                ),
                _OutlinedAction(
                  label: 'auto.t_a3326e7683'.tr(),
                  icon: FontAwesomeIcons.whatsapp,
                  color: const Color(0xFF25D366),
                  onTap: () => _open('https://wa.me/01010285020'),
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
    this.errorText,
    this.keyboardType,
    this.iconColor,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final Color? iconColor;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15.sp, color: iconColor ?? context.etbalyColors.textMuted),
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
        TextField(
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
                color:
                    hasError ? const Color(0xFFFF6B6B) : EtbalyWebColors.border,
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
        if (hasError) ...[
          SizedBox(height: 6.h),
          Text(
            errorText!,
            style: context.textTheme.labelSmall?.copyWith(
              color: const Color(0xFFFF8A8A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _PackageEmptyBox extends StatelessWidget {
  const _PackageEmptyBox();

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
            onPressed: () => context.go(AppRoutes.services),
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

class _FormAlert extends StatelessWidget {
  const _FormAlert({required this.message, required this.isSuccess});

  final String message;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? EtbalyWebColors.green : const Color(0xFFFF6B6B);

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
          Icon(
            isSuccess
                ? Icons.check_circle_rounded
                : Icons.error_outline_rounded,
            color: color,
            size: 18.sp,
          ),
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
  final IconData icon;
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
              Icon(icon, color: color, size: 17.sp),
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

class _MapPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    final bg = Paint()..color = const Color(0xFFEFF4F8);
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFFC8D7E2)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final roadLight = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final green = Paint()..color = const Color(0xFFCDEFD9);

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.18, 90, 42),
      green,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.66, size.height * 0.58, 120, 48),
      green,
    );

    for (var i = -2; i < 7; i++) {
      final y = size.height * 0.18 + i * 38;
      canvas.drawLine(Offset(-20, y), Offset(size.width + 20, y + 80), road);
      canvas.drawLine(
          Offset(-20, y + 12), Offset(size.width + 20, y + 92), roadLight);
    }

    for (var i = -1; i < 6; i++) {
      final x = size.width * 0.08 + i * 58;
      canvas.drawLine(Offset(x, -20), Offset(x + 95, size.height + 20), road);
      canvas.drawLine(
          Offset(x + 12, -20), Offset(x + 107, size.height + 20), roadLight);
    }

    final labelStyle = TextStyle(
      color: const Color(0xFF6B7280).withValues(alpha: 0.8),
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
    );
    _drawLabel(
        canvas, 'El Imam Ali', Offset(size.width * 0.58, 58), labelStyle);
    _drawLabel(
        canvas, 'Bim Market', Offset(size.width * 0.44, 150), labelStyle);
    _drawLabel(
        canvas, 'Alexandria', Offset(size.width * 0.18, 205), labelStyle);

    canvas.restore();
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> _open(String url) async {
  final uri = Uri.parse(url);
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened) {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}
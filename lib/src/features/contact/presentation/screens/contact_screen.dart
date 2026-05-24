import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EtbalyWebColors.sectionBlack,
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
                    const SizedBox(height: 22),
                    _buildMainLayout(context),
                    const SizedBox(height: 26),
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
              const SizedBox(height: 18),
              channels,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: form),
            const SizedBox(width: 18),
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
        _errorMessage = 'راجع البيانات المطلوبة ثم حاول مرة أخرى.';
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
        _successMessage =
            'تم إرسال رسالتك بنجاح. سنتواصل معك خلال ساعات قليلة.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'حدث خطأ أثناء الإرسال. يمكنك التواصل مباشرة عبر واتساب.';
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
          ? 'الاسم مطلوب'
          : name.length < 2
              ? 'الاسم قصير جداً'
              : null;
      _emailError = email.isNotEmpty && !_isValidEmail(email)
          ? 'صيغة البريد غير صحيحة'
          : null;
      _phoneError = phone.isEmpty
          ? 'رقم الهاتف مطلوب'
          : !_isValidPhone(phone)
              ? 'رقم الهاتف غير صحيح - مثال: 01012345678'
              : null;
      _whatsappError = whatsapp.isEmpty
          ? 'رقم واتساب مطلوب'
          : !_isValidPhone(whatsapp)
              ? 'رقم واتساب غير صحيح - مثال: 01012345678'
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

class _ContactHero extends StatelessWidget {
  const _ContactHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 330),
      decoration: BoxDecoration(
        color: EtbalyWebColors.sectionDeep,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _ContactBackgroundPainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 42, 18, 34),
          child: Column(
            children: [
              const _WebBadge(label: 'تواصل معنا', icon: Icons.send_rounded),
              const SizedBox(height: 18),
              Text(
                'نحن هنا لمساعدتك',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: EtbalyWebColors.heading,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  fontSize: context.width < 390 ? 32 : 38,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: math.min(context.width - 58, 520),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: EtbalyWebColors.sectionBlack.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: EtbalyWebColors.goldBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3328155E),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'هل لديك مشروع في ذهنك؟',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: EtbalyWebColors.heading,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const EtbalyWebGoldDivider(width: 120),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: EtbalyWebColors.body,
                          height: 1.45,
                        ),
                        children: const [
                          TextSpan(text: 'نحن هنا لنحوّل '),
                          TextSpan(
                            text: 'أفكارك',
                            style: TextStyle(
                              color: EtbalyWebColors.gold,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(text: ' إلى واقع رقمي مؤثر'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _MiniPill(text: 'الاستشارة مجانية +'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroStat(icon: Icons.timer_rounded, text: 'رد سريع'),
                  _HeroStat(icon: Icons.shield_rounded, text: 'بيانات محمية'),
                  _HeroStat(icon: Icons.headset_mic_rounded, text: 'دوام كامل'),
                ],
              ),
            ],
          ),
        ),
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
    return Container(
      padding: EdgeInsets.all(context.width < 390 ? 16 : 20),
      decoration: BoxDecoration(
        color: EtbalyWebColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EtbalyWebColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 26,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _SquareIcon(icon: Icons.send_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أرسل لنا رسالة',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: EtbalyWebColors.heading,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سنتواصل معك خلال ساعات قليلة',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: EtbalyWebColors.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: EtbalyWebColors.border, height: 1),
          const SizedBox(height: 20),
          _ResponsiveFields(
            children: [
              _ContactTextField(
                label: 'الاسم الكامل',
                hint: 'اكتب اسمك',
                icon: Icons.person_rounded,
                controller: nameController,
                errorText: nameError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'البريد الإلكتروني (اختياري)',
                hint: 'اكتب بريدك الإلكتروني',
                icon: Icons.mail_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                errorText: emailError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'رقم الجوال',
                hint: 'اكتب رقم موبايلك',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                controller: phoneController,
                errorText: phoneError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'واتساب',
                hint: 'اكتب رقم واتساب',
                icon: FontAwesomeIcons.whatsapp,
                iconColor: const Color(0xFF25D366),
                keyboardType: TextInputType.phone,
                controller: whatsappController,
                errorText: whatsappError,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'اسم النشاط (اختياري)',
                hint: 'اكتب اسم نشاطك',
                icon: Icons.storefront_rounded,
                controller: businessController,
                onChanged: onChanged,
              ),
              _ContactTextField(
                label: 'التخصص / المجال (اختياري)',
                hint: 'مثال: مطعم، صالون، متجر إلكتروني...',
                icon: Icons.sell_rounded,
                controller: specialtyController,
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _PackageEmptyBox(),
          const SizedBox(height: 18),
          _ContactTextField(
            label: 'رسالتك (اختياري)',
            hint: 'اكتب رسالتك',
            icon: Icons.chat_bubble_rounded,
            controller: messageController,
            minLines: 4,
            maxLines: 6,
            onChanged: onChanged,
          ),
          if (successMessage != null || errorMessage != null) ...[
            const SizedBox(height: 14),
            _FormAlert(
              message: successMessage ?? errorMessage!,
              isSuccess: successMessage != null,
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isSubmitting ? null : onSubmit,
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_back_rounded),
              label: Text(isSubmitting ? 'جاري الإرسال...' : 'أرسل الرسالة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: EtbalyWebColors.gold,
                foregroundColor: Colors.black,
                disabledBackgroundColor:
                    EtbalyWebColors.gold.withValues(alpha: 0.52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                textStyle: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
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
          label: 'واتساب',
          value: '+201010285020',
          subtitle: 'متاح 7 أيام في الأسبوع',
          icon: FontAwesomeIcons.whatsapp,
          color: const Color(0xFF25D366),
          onTap: () => _open('https://wa.me/+201010285020'),
        ),
        _ContactChannelCard(
          label: 'فيسبوك',
          value: 'اطبعلي للدعاية والإعلان',
          subtitle: 'تابعنا على فيسبوك',
          icon: FontAwesomeIcons.facebookF,
          color: const Color(0xFF1877F2),
          onTap: () =>
              _open('https://www.facebook.com/etba3lydigitalmarketing'),
        ),
        _ContactChannelCard(
          label: 'البريد الإلكتروني',
          value: 'support@etba3ly-dm.com',
          subtitle: 'نرد خلال 24 ساعة',
          icon: Icons.mail_rounded,
          color: EtbalyWebColors.gold,
          onTap: () => _open('mailto:support@etba3ly-dm.com'),
        ),
        _ContactChannelCard(
          label: 'انستجرام',
          value: '@etba3ly2022',
          subtitle: 'تابعنا وشاهد أعمالنا',
          icon: FontAwesomeIcons.instagram,
          color: const Color(0xFFE4405F),
          onTap: () => _open('https://www.instagram.com/etba3ly2022'),
        ),
        _ContactChannelCard(
          label: 'يوتيوب',
          value: '@etba3ly4adv',
          subtitle: 'شاهد أعمالنا على يوتيوب',
          icon: FontAwesomeIcons.youtube,
          color: const Color(0xFFFF0000),
          onTap: () => _open('https://www.youtube.com/@etba3ly4adv'),
        ),
        _ContactChannelCard(
          label: 'تيك توك',
          value: '@etba3ly2',
          subtitle: 'تابعنا على تيك توك',
          icon: FontAwesomeIcons.tiktok,
          color: EtbalyWebColors.purple,
          onTap: () => _open('https://www.tiktok.com/@etba3ly2'),
        ),
        _ContactChannelCard(
          label: 'تيليجرام',
          value: '@etba3ly_studio',
          subtitle: 'تابعنا على تيليجرام',
          icon: FontAwesomeIcons.telegram,
          color: const Color(0xFF229ED9),
          onTap: () => _open('https://t.me/etba3ly_studio'),
        ),
        const _HoursCard(),
      ],
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
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: EtbalyWebColors.sectionDeep.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: EtbalyWebColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.32)),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: EtbalyWebColors.body,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        value,
                        textDirection: value.startsWith('+') ||
                                value.startsWith('@') ||
                                value.contains('@')
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        textAlign: TextAlign.right,
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
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: EtbalyWebColors.body,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EtbalyWebColors.sectionDeep.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  color: EtbalyWebColors.gold, size: 19),
              const SizedBox(width: 8),
              Text(
                'ساعات العمل',
                style: context.textTheme.titleMedium?.copyWith(
                  color: EtbalyWebColors.heading,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _HoursRow(label: 'ساعات مكتبية', value: 'السبت إلى الخميس'),
          const _HoursRow(label: 'المواعيد', value: '12 مساءً حتى 9 مساءً'),
          const _HoursRow(label: 'الجمعة', value: 'إجازة', warning: true),
          const Divider(color: EtbalyWebColors.border, height: 26),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: EtbalyWebColors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'دوام أونلاين طوال أيام الأسبوع',
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: EtbalyWebColors.body,
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
        color: EtbalyWebColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EtbalyWebColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
            child: Column(
              children: [
                const _WebBadge(
                  label: 'موقعنا',
                  icon: Icons.location_on_rounded,
                ),
                const SizedBox(height: 14),
                Text(
                  'زورنا في مقرنا الرئيسي',
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'الإسكندرية، مصر - متاحون للزيارة خلال ساعات العمل المكتبية',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: EtbalyWebColors.body,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const _MapInfoStrip(),
          ClipRect(
            child: SizedBox(
              height: 260,
              width: double.infinity,
              child: CustomPaint(
                painter: _MapPreviewPainter(),
                child: Center(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_pin,
                      color: Color(0xFFE53935),
                      size: 42,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _OutlinedAction(
                  label: 'احصل على الاتجاهات',
                  icon: Icons.directions_rounded,
                  onTap: () =>
                      _open('https://maps.google.com/?q=31.094632,29.753261'),
                ),
                _OutlinedAction(
                  label: 'تواصل قبل الزيارة',
                  icon: FontAwesomeIcons.whatsapp,
                  color: const Color(0xFF25D366),
                  onTap: () => _open('https://wa.me/+201010285020'),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: EtbalyWebColors.sectionDeep,
        border: Border(
          top: BorderSide(color: EtbalyWebColors.border),
          bottom: BorderSide(color: EtbalyWebColors.border),
        ),
      ),
      child: const Wrap(
        spacing: 14,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _MapInfoItem(
              icon: Icons.location_on_rounded, text: 'الإسكندرية، مصر'),
          _MapInfoItem(icon: Icons.schedule_rounded, text: 'السبت - الخميس'),
          _MapInfoItem(icon: Icons.phone_rounded, text: '+201010285020'),
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
        Icon(icon, color: EtbalyWebColors.gold, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          textDirection:
              text.startsWith('+') ? TextDirection.ltr : TextDirection.rtl,
          style: context.textTheme.labelSmall?.copyWith(
            color: EtbalyWebColors.body,
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
          runSpacing: 14,
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
            Icon(icon, size: 15, color: iconColor ?? EtbalyWebColors.body),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: EtbalyWebColors.body,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
          onChanged: (_) => onChanged(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: EtbalyWebColors.heading,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.textTheme.bodySmall?.copyWith(
              color: EtbalyWebColors.muted,
            ),
            filled: true,
            fillColor: const Color(0xFF282240),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    hasError ? const Color(0xFFFF6B6B) : EtbalyWebColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    hasError ? const Color(0xFFFF6B6B) : EtbalyWebColors.gold,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EtbalyWebColors.sectionBlack.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: EtbalyWebColors.gold.withValues(alpha: 0.36),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: EtbalyWebColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: EtbalyWebColors.gold,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لم تختر باقة بعد',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: EtbalyWebColors.heading,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'يمكنك اختيار باقة مناسبة لك',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: EtbalyWebColors.body,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => context.go(AppRoutes.services),
            icon: const Icon(Icons.arrow_back_rounded, size: 17),
            label: const Text('عرض الباقات'),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.34)),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess
                ? Icons.check_circle_rounded
                : Icons.error_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
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
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.62)),
            color: color.withValues(alpha: 0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x33251D33),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: EtbalyWebColors.gold, size: 15),
          const SizedBox(width: 7),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: EtbalyWebColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 5,
            height: 5,
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x33251D33),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: EtbalyWebColors.gold, size: 16),
          const SizedBox(width: 7),
          Text(
            text,
            style: context.textTheme.labelMedium?.copyWith(
              color: EtbalyWebColors.body,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
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
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: EtbalyWebColors.gold.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EtbalyWebColors.goldBorder),
      ),
      child: Icon(icon, color: EtbalyWebColors.gold, size: 24),
    );
  }
}

class _ContactBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
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
      ..color = EtbalyWebColors.purpleLine
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(-20, size.height * 0.18),
      Offset(size.width * 0.28, -40),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.76, 0),
      Offset(size.width + 40, size.height * 0.2),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.92, size.height * 0.78),
      Offset(size.width + 40, size.height * 0.98),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
      fontSize: 12,
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
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

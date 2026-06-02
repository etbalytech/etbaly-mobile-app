import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const _draftKey = 'start_now_draft';
const _endpoint = 'https://etba3ly-dm.com/api/proxy.php';
const _whatsAppUrl = 'https://wa.me/+201010285020';

class StartNowPage extends StatefulWidget {
  const StartNowPage({super.key});

  @override
  State<StartNowPage> createState() => _StartNowPageState();
}

class _StartNowPageState extends State<StartNowPage> {
  final _dio = Dio();
  final _contactName = TextEditingController();
  final _whatsApp = TextEditingController();
  final _email = TextEditingController();
  final _company = TextEditingController();
  final _brandColors = TextEditingController();
  final Map<String, TextEditingController> _answers = {};
  final Map<String, TextEditingController> _socials = {
    'facebook': TextEditingController(),
    'instagram': TextEditingController(),
    'tiktok': TextEditingController(),
  };
  final Map<String, String> _phoneErrors = {};

  _StartServiceId _selectedServiceId = _StartServiceId.content;
  String _identityMode = 'from-logo';
  bool _noSocialPages = false;
  bool _formTouched = false;
  bool _isSubmitting = false;
  String _successMessage = '';
  String _errorMessage = '';
  String _validationMessage = '';
  String _logoError = '';
  PlatformFile? _logoFile;

  bool get _isArabic => context.locale.languageCode == 'ar';

  _StartServiceConfig get _selectedService => _services.firstWhere(
        (service) => service.id == _selectedServiceId,
        orElse: () => _services.last,
      );

  List<_StartServiceConfig> get _orderedServices => [
        _serviceById(_StartServiceId.content),
        _serviceById(_StartServiceId.web),
        _serviceById(_StartServiceId.mobile),
      ];

  int get _completedRequiredCount {
    var count = 0;
    if (_contactName.text.trim().length >= 2) count++;
    if (_whatsApp.text.trim().length >= 7) count++;
    for (final question in _selectedService.questions) {
      if (question.required &&
          _controllerFor(question.key).text.trim().isNotEmpty) {
        count++;
      }
    }
    if (_identityMode != 'from-logo' || _logoFile != null) count++;
    return count;
  }

  int get _requiredTotal {
    final serviceRequired =
        _selectedService.questions.where((q) => q.required).length;
    final logoRequired = _identityMode == 'from-logo' ? 1 : 0;
    return 2 + serviceRequired + logoRequired;
  }

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _contactName.dispose();
    _whatsApp.dispose();
    _email.dispose();
    _company.dispose();
    _brandColors.dispose();
    for (final controller in _answers.values) {
      controller.dispose();
    }
    for (final controller in _socials.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.width >= 720;

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0E18),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 34.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _HeroHeader(isArabic: _isArabic),
                    SizedBox(height: 24.h),
                    if (isTablet)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 292.w,
                            child: _buildSidePanel(showWhatsApp: true),
                          ),
                          SizedBox(width: 18.w),
                          Expanded(child: _buildForm()),
                        ],
                      )
                    else ...[
                      _buildSidePanel(showWhatsApp: false),
                      SizedBox(height: 16.h),
                      _buildForm(),
                      SizedBox(height: 14.h),
                      _WhatsAppButton(isArabic: _isArabic),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidePanel({required bool showWhatsApp}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: Text(
                _isArabic ? 'نوع الخدمة' : 'Service type',
                textAlign: TextAlign.left,
                style:
                    _mutedStyle(fontSize: 12.sp, fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              _selectedService.title.text(_isArabic),
              textAlign: TextAlign.end,
              style: _mainStyle(fontSize: 13.sp, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final horizontalTabs = constraints.maxWidth > 430;
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _orderedServices.map((service) {
                return SizedBox(
                  width: horizontalTabs
                      ? (constraints.maxWidth - 16.w) / 3
                      : double.infinity,
                  child: _ServiceTab(
                    service: service,
                    isArabic: _isArabic,
                    isActive: service.id == _selectedServiceId,
                    onTap: () => _selectService(service.id),
                  ),
                );
              }).toList(),
            );
          },
        ),
        SizedBox(height: 12.h),
        _SummaryCard(
          service: _selectedService,
          isArabic: _isArabic,
          completed: _completedRequiredCount,
          total: _requiredTotal,
        ),
        if (showWhatsApp) ...[
          SizedBox(height: 12.h),
          _WhatsAppButton(isArabic: _isArabic),
        ],
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _FormBlock(
          number: '01',
          title: _isArabic ? 'بيانات التواصل' : 'Contact details',
          subtitle: _isArabic
              ? 'هنستخدمها للتأكيد والمتابعة فقط.'
              : 'We use this only for confirmation and follow-up.',
          children: [
            _responsiveFields([
              _TextFieldBox(
                label: _isArabic ? 'اسمك' : 'Your name',
                required: true,
                controller: _contactName,
                hint: _isArabic ? 'مثال: أحمد محمد' : 'Example: Ahmed Mohamed',
                error: _formTouched && _contactName.text.trim().length < 2
                    ? (_isArabic
                        ? 'الاسم مطلوب (حرفين على الأقل)'
                        : 'Name is required (at least 2 characters)')
                    : null,
                onChanged: (_) => _saveDraft(),
              ),
              _TextFieldBox(
                label: _isArabic ? 'واتساب' : 'WhatsApp',
                required: true,
                controller: _whatsApp,
                hint: '+201010285020',
                keyboardType: TextInputType.phone,
                error: _phoneErrors['whatsapp'] ??
                    (_formTouched && _whatsApp.text.trim().length < 7
                        ? (_isArabic
                            ? 'رقم الواتساب مطلوب'
                            : 'WhatsApp number is required')
                        : null),
                onChanged: (value) =>
                    _onPhoneChanged('whatsapp', value, _whatsApp),
              ),
              _TextFieldBox(
                label: _isArabic ? 'البريد الإلكتروني' : 'Email',
                controller: _email,
                hint: 'name@email.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _saveDraft(),
              ),
              _TextFieldBox(
                label: _isArabic ? 'اسم النشاط' : 'Business name',
                controller: _company,
                hint: _isArabic
                    ? 'اسم الشركة أو البراند'
                    : 'Company or brand name',
                onChanged: (_) => _saveDraft(),
              ),
            ]),
          ],
        ),
        SizedBox(height: 14.h),
        _FormBlock(
          number: '02',
          title: _isArabic ? 'تفاصيل المشروع' : 'Project details',
          subtitle: _isArabic
              ? 'الأسئلة تتغير حسب الخدمة المختارة.'
              : 'Questions change based on the selected service.',
          children: [
            _responsiveFields(
              _selectedService.questions.map(_buildQuestionField).toList(),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _buildIdentityBlock(),
        SizedBox(height: 14.h),
        if (_successMessage.isNotEmpty) ...[
          _AlertBox(message: _successMessage, isSuccess: true),
          SizedBox(height: 10.h),
        ],
        if (_validationMessage.isNotEmpty) ...[
          _AlertBox(message: _validationMessage),
          SizedBox(height: 10.h),
        ],
        if (_errorMessage.isNotEmpty) ...[
          _AlertBox(
            message: _errorMessage,
            actionLabel: 'WhatsApp',
            onAction: _openWhatsApp,
          ),
          SizedBox(height: 10.h),
        ],
        _SubmitButton(
          isArabic: _isArabic,
          isSubmitting: _isSubmitting,
          onPressed: _submitForm,
        ),
      ],
    );
  }

  Widget _buildIdentityBlock() {
    return _FormBlock(
      number: '03',
      title: _isArabic ? 'الهوية والسوشيال' : 'Identity and socials',
      subtitle: _isArabic
          ? 'اختار مصدر الألوان وأضف الروابط أو فعل خيار لا أملك صفحات.'
          : 'Choose the color source and add links, or mark that you do not have social pages.',
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 520;
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _identityOptions.map((option) {
                return SizedBox(
                  width: twoColumns
                      ? (constraints.maxWidth - 8.w) / 2
                      : double.infinity,
                  child: _ChoicePill(
                    label: option.label.text(_isArabic),
                    selected: _identityMode == option.value,
                    onTap: () {
                      setState(() => _identityMode = option.value);
                      _saveDraft();
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
        SizedBox(height: 14.h),
        _TextFieldBox(
          label: _isArabic
              ? 'الألوان أو الهوية المستخدمة'
              : 'Used colors or identity notes',
          controller: _brandColors,
          hint: _isArabic
              ? 'اكتب أكواد الألوان، وصف الستايل، أو أي ملاحظات عن الهوية'
              : 'Add color codes, style notes, or identity details',
          maxLines: 3,
          onChanged: (_) => _saveDraft(),
        ),
        SizedBox(height: 14.h),
        _UploadBox(
          isArabic: _isArabic,
          fileName: _logoFile?.name,
          hasError:
              _formTouched && _identityMode == 'from-logo' && _logoFile == null,
          onPick: _pickLogo,
          onClear: _logoFile == null ? null : _clearLogo,
        ),
        if (_logoError.isNotEmpty) _InlineError(_logoError),
        if (_logoError.isEmpty &&
            _formTouched &&
            _identityMode == 'from-logo' &&
            _logoFile == null)
          _InlineError(
            _isArabic
                ? 'ارفع اللوجو لاستخراج الألوان منه'
                : 'Upload your logo to extract colors from it',
          ),
        SizedBox(height: 12.h),
        _CheckRow(
          value: _noSocialPages,
          label: _isArabic
              ? 'لا أملك صفحات تواصل اجتماعي حاليا'
              : 'I do not currently have social media pages',
          onChanged: (value) {
            setState(() {
              _noSocialPages = value;
              if (value) {
                for (final controller in _socials.values) {
                  controller.clear();
                }
              }
            });
            _saveDraft();
          },
        ),
        SizedBox(height: 12.h),
        Opacity(
          opacity: _noSocialPages ? 0.45 : 1,
          child: IgnorePointer(
            ignoring: _noSocialPages,
            child: _responsiveFields([
              _TextFieldBox(
                label: 'Facebook',
                controller: _socials['facebook']!,
                hint: 'https://facebook.com/...',
                keyboardType: TextInputType.url,
                onChanged: (_) => _saveDraft(),
              ),
              _TextFieldBox(
                label: 'Instagram',
                controller: _socials['instagram']!,
                hint: 'https://instagram.com/...',
                keyboardType: TextInputType.url,
                onChanged: (_) => _saveDraft(),
              ),
              _TextFieldBox(
                label: 'TikTok',
                controller: _socials['tiktok']!,
                hint: 'https://tiktok.com/@...',
                keyboardType: TextInputType.url,
                onChanged: (_) => _saveDraft(),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionField(_StartQuestion question) {
    final controller = _controllerFor(question.key);
    final invalid =
        _formTouched && question.required && controller.text.trim().isEmpty;
    final error = _phoneErrors[question.key] ??
        (invalid
            ? (_isArabic ? 'هذه الخانة مطلوبة' : 'This field is required')
            : null);

    if (question.options.isNotEmpty) {
      return _SelectBox(
        label: question.label.text(_isArabic),
        required: question.required,
        value: controller.text,
        hint: _isArabic ? 'اختر من القائمة' : 'Choose an option',
        options: question.options,
        isArabic: _isArabic,
        error: error,
        onChanged: (value) {
          controller.text = value ?? '';
          _saveDraft();
          setState(() {});
        },
      );
    }

    return _TextFieldBox(
      label: question.label.text(_isArabic),
      required: question.required,
      controller: controller,
      hint: question.placeholder?.text(_isArabic) ?? '',
      maxLines: question.type == _QuestionType.textarea ? question.rows : 1,
      keyboardType: question.type == _QuestionType.tel
          ? TextInputType.phone
          : TextInputType.text,
      error: error,
      onChanged: (value) {
        if (question.type == _QuestionType.tel) {
          _onPhoneChanged(question.key, value, controller);
        } else {
          _saveDraft();
          setState(() {});
        }
      },
    );
  }

  Widget _responsiveFields(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 560;
        return Wrap(
          spacing: 14.w,
          runSpacing: 14.h,
          children: children.map((child) {
            return SizedBox(
              width: twoColumns
                  ? (constraints.maxWidth - 14.w) / 2
                  : double.infinity,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }

  TextEditingController _controllerFor(String key) {
    return _answers.putIfAbsent(key, TextEditingController.new);
  }

  _StartServiceConfig _serviceById(_StartServiceId id) {
    return _services.firstWhere((service) => service.id == id);
  }

  void _selectService(_StartServiceId serviceId) {
    setState(() {
      _selectedServiceId = serviceId;
      _formTouched = false;
      _validationMessage = '';
      _successMessage = '';
      _errorMessage = '';
    });
    _saveDraft();
  }

  Future<void> _pickLogo() async {
    setState(() => _logoError = '');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'svg', 'pdf'],
      withData: false,
    );
    final file = result?.files.single;
    if (file == null) return;

    if (file.size > 5 * 1024 * 1024) {
      setState(() {
        _logoFile = null;
        _logoError = _isArabic
            ? 'حجم الملف كبير. ارفع ملف أقل من 5MB.'
            : 'File is too large. Please upload a file under 5MB.';
      });
      return;
    }

    setState(() => _logoFile = file);
  }

  void _clearLogo() {
    setState(() {
      _logoFile = null;
      _logoError = '';
    });
  }

  void _onPhoneChanged(
      String key, String value, TextEditingController controller) {
    final cleaned = value.replaceAll(RegExp(r'[^\d+\s\-()]'), '');
    if (cleaned != value) {
      controller.value = TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
    }
    final error = _validatePhone(cleaned);
    setState(() {
      if (error.isEmpty) {
        _phoneErrors.remove(key);
      } else {
        _phoneErrors[key] = error;
      }
    });
    _saveDraft();
  }

  String _validatePhone(String value) {
    if (value.trim().isEmpty) return '';
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7) {
      return _isArabic ? 'رقم الهاتف قصير جدا' : 'Phone number is too short';
    }
    if (digitsOnly.length > 15) {
      return _isArabic ? 'رقم الهاتف طويل جدا' : 'Phone number is too long';
    }
    return '';
  }

  Future<void> _submitForm() async {
    setState(() {
      _formTouched = true;
      _validationMessage = '';
      _errorMessage = '';
      _successMessage = '';
    });

    if (!_isValid()) {
      setState(() {
        _validationMessage = _isArabic
            ? 'راجع البيانات المطلوبة قبل الإرسال.'
            : 'Please review the required fields before submitting.';
      });
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final answers = <String, String>{
        for (final entry in _answers.entries)
          entry.key: entry.value.text.trim(),
      };
      final socials = <String, String>{
        for (final entry in _socials.entries)
          entry.key: entry.value.text.trim(),
      };

      final data = FormData.fromMap({
        'service_type': _selectedServiceId.name,
        'contact_name': _contactName.text.trim(),
        'whatsapp': _whatsApp.text.trim(),
        if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
        if (_company.text.trim().isNotEmpty) 'company': _company.text.trim(),
        'answers': jsonEncode(answers),
        'identity_mode': _identityMode,
        if (_brandColors.text.trim().isNotEmpty)
          'brand_colors': _brandColors.text.trim(),
        'social_links': jsonEncode(socials),
        'no_social': _noSocialPages ? '1' : '0',
        if (_logoFile?.path != null)
          'logo': await MultipartFile.fromFile(
            _logoFile!.path!,
            filename: _logoFile!.name,
          ),
      });

      final response = await _dio.post<dynamic>(
        _endpoint,
        data: data,
        options: Options(
          sendTimeout: const Duration(seconds: 45),
          receiveTimeout: const Duration(seconds: 45),
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final body = response.data;
      final failed = response.statusCode == null ||
          response.statusCode! >= 400 ||
          (body is Map && body['success'] == false);
      if (failed) throw Exception('send_failed');

      await _resetForm();
      setState(() {
        _successMessage = _isArabic
            ? 'تم إرسال الطلب بنجاح. فريقنا هيتواصل معاك قريبا.'
            : 'Your request was sent successfully. Our team will contact you soon.';
      });
    } on DioException {
      setState(() {
        _errorMessage = _isArabic
            ? 'تعذر الاتصال بالخادم. تحقق من الإنترنت أو تواصل معنا على واتساب.'
            : 'Could not reach the server. Check your connection or contact us on WhatsApp.';
      });
    } catch (_) {
      setState(() {
        _errorMessage = _isArabic
            ? 'حدث خطأ أثناء الإرسال. جرب مرة أخرى أو تواصل معنا على واتساب.'
            : 'Something went wrong while sending. Try again or contact us on WhatsApp.';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  bool _isValid() {
    final hasContact = _contactName.text.trim().length >= 2 &&
        _whatsApp.text.trim().length >= 7;
    final hasRequiredQuestions = _selectedService.questions.every((question) {
      if (!question.required) return true;
      return _controllerFor(question.key).text.trim().isNotEmpty;
    });
    final hasLogo = _identityMode != 'from-logo' || _logoFile != null;
    final noPhoneErrors = _phoneErrors.isEmpty;

    return hasContact &&
        hasRequiredQuestions &&
        hasLogo &&
        _logoError.isEmpty &&
        noPhoneErrors;
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _draftKey,
        jsonEncode({
          'selectedServiceId': _selectedServiceId.name,
          'contact': {
            'name': _contactName.text,
            'whatsapp': _whatsApp.text,
            'email': _email.text,
            'company': _company.text,
          },
          'answers': {
            for (final entry in _answers.entries) entry.key: entry.value.text,
          },
          'socialLinks': {
            for (final entry in _socials.entries) entry.key: entry.value.text,
          },
          'noSocialPages': _noSocialPages,
          'brandIdentityMode': _identityMode,
          'brandColors': _brandColors.text,
        }),
      );
    } catch (_) {}
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_draftKey);
      if (raw == null) return;
      final draft = jsonDecode(raw) as Map<String, dynamic>;
      final contact = (draft['contact'] as Map?) ?? {};
      final answers = (draft['answers'] as Map?) ?? {};
      final socials = (draft['socialLinks'] as Map?) ?? {};

      setState(() {
        _contactName.text = (contact['name'] ?? '').toString();
        _whatsApp.text = (contact['whatsapp'] ?? '').toString();
        _email.text = (contact['email'] ?? '').toString();
        _company.text = (contact['company'] ?? '').toString();
        for (final entry in answers.entries) {
          _controllerFor(entry.key.toString()).text = entry.value.toString();
        }
        for (final entry in socials.entries) {
          _socials[entry.key.toString()]?.text = entry.value.toString();
        }
        _noSocialPages = draft['noSocialPages'] == true;
        _identityMode =
            (draft['brandIdentityMode'] ?? _identityMode).toString();
        _brandColors.text = (draft['brandColors'] ?? '').toString();
      });
    } catch (_) {}
  }

  Future<void> _resetForm() async {
    _contactName.clear();
    _whatsApp.clear();
    _email.clear();
    _company.clear();
    _brandColors.clear();
    for (final controller in _answers.values) {
      controller.clear();
    }
    for (final controller in _socials.values) {
      controller.clear();
    }
    _phoneErrors.clear();
    setState(() {
      _noSocialPages = false;
      _identityMode = 'from-logo';
      _logoFile = null;
      _logoError = '';
      _formTouched = false;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(_whatsAppUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF332D55))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color(0x176F3FF5),
              border: Border.all(color: const Color(0x476F3FF5)),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded,
                    color: const Color(0xFFB9A3FF), size: 16.sp),
                SizedBox(width: 7.w),
                Text(
                  isArabic ? 'ابدأ الآن' : 'Start now',
                  style: _mainStyle(
                    color: const Color(0xFFB9A3FF),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            isArabic
                ? 'خلينا نجهز مشروعك صح من أول Brief'
                : 'Let us brief your project properly',
            style: _mainStyle(
                fontSize: 30.sp, fontWeight: FontWeight.w900, height: 1.12),
          ),
          SizedBox(height: 14.h),
          Text(
            isArabic
                ? 'اختار نوع الخدمة، املأ البيانات المهمة، وارفع اللوجو لو موجود. الفورم مصمم عشان يختصر وقت التواصل ويخلي فريقنا يبدأ بصورة واضحة.'
                : 'Choose a service, add the important details, and upload your logo if available. This form helps our team start with a clear picture.',
            style: _mutedStyle(
                fontSize: 14.sp, height: 1.65, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _MetaChip(
                  icon: Icons.shield_outlined,
                  label: isArabic ? 'بيانات آمنة' : 'Secure data'),
              _MetaChip(
                  icon: Icons.attach_file,
                  label: isArabic ? 'رفع لوجو' : 'Logo upload'),
              _MetaChip(
                  icon: Icons.layers_outlined,
                  label: isArabic ? 'قابل للتطوير' : 'Scalable'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: const Color(0xFF332D55)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 17.sp),
          SizedBox(width: 8.w),
          Text(label,
              style: _mainStyle(fontSize: 12.sp, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ServiceTab extends StatelessWidget {
  const _ServiceTab({
    required this.service,
    required this.isArabic,
    required this.isActive,
    required this.onTap,
  });

  final _StartServiceConfig service;
  final bool isArabic;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: isActive
                ? service.accent.withValues(alpha: 0.10)
                : const Color(0xFF1E1B30),
            border: Border.all(
              color: isActive
                  ? service.accent.withValues(alpha: 0.60)
                  : const Color(0xFF332D55),
            ),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: service.accent.withValues(alpha: 0.14),
                      blurRadius: 22.r,
                      offset: Offset(0, 8.h),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              _ServiceIcon(service: service),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.shortTitle.text(isArabic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _mainStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      service.title.text(isArabic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _mutedStyle(
                          fontSize: 11.sp, fontWeight: FontWeight.w700),
                    ),
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

class _ServiceIcon extends StatelessWidget {
  const _ServiceIcon({required this.service});

  final _StartServiceConfig service;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: service.accent.withValues(alpha: 0.14),
        border: Border.all(color: service.accent.withValues(alpha: 0.26)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(service.icon, color: service.accent, size: 22.sp),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.service,
    required this.isArabic,
    required this.completed,
    required this.total,
  });

  final _StartServiceConfig service;
  final bool isArabic;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: _panelDecoration(radius: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceIcon(service: service),
          SizedBox(height: 12.h),
          Text(
            service.title.text(isArabic),
            style: _mainStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 7.h),
          Text(
            service.description.text(isArabic),
            style: _mutedStyle(
                fontSize: 12.sp, height: 1.6, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  isArabic ? 'تقدم البيانات' : 'Brief progress',
                  style:
                      _mutedStyle(fontSize: 12.sp, fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '$completed/$total',
                style: _mainStyle(
                  color: const Color(0xFFB9A3FF),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          SizedBox(
            height: 6.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                backgroundColor: const Color(0xFF252040),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFD4AF37)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatsAppButton extends StatelessWidget {
  const _WhatsAppButton({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(_whatsAppUrl),
            mode: LaunchMode.externalApplication),
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: const Color(0x1425D366),
            border: Border.all(color: const Color(0x4725D366)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline,
                  color: const Color(0xFF25D366), size: 19.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  isArabic
                      ? 'محتاج مساعدة؟ كلمنا واتساب'
                      : 'Need help? WhatsApp us',
                  textAlign: TextAlign.center,
                  style: _mainStyle(
                    color: const Color(0xFF25D366),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormBlock extends StatelessWidget {
  const _FormBlock({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String number;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: _panelDecoration(radius: 14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x2E6F3FF5),
                  border: Border.all(color: const Color(0x336F3FF5)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  number,
                  style: _mainStyle(
                    color: const Color(0xFFB9A3FF),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: _mainStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w900)),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: _mutedStyle(
                          fontSize: 12.sp,
                          height: 1.45,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ...children,
        ],
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.label,
    required this.controller,
    this.required = false,
    this.hint = '',
    this.error,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final bool required;
  final String hint;
  final String? error;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, required: required, hasError: error != null),
        SizedBox(height: 7.h),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: maxLines > 1 ? maxLines : 1,
          style: _mainStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          decoration: _inputDecoration(hint, hasError: error != null),
        ),
        if (error != null) _InlineError(error!),
      ],
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.label,
    required this.value,
    required this.hint,
    required this.options,
    required this.isArabic,
    required this.onChanged,
    this.required = false,
    this.error,
  });

  final String label;
  final String value;
  final String hint;
  final List<_StartOption> options;
  final bool isArabic;
  final bool required;
  final String? error;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, required: required, hasError: error != null),
        SizedBox(height: 7.h),
        DropdownButtonFormField<String>(
          initialValue: value.isEmpty ? null : value,
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value: option.value,
                  child: Text(option.label.text(isArabic)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF252040),
          style: _mainStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
          decoration: _inputDecoration(hint, hasError: error != null),
        ),
        if (error != null) _InlineError(error!),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(
      {required this.label, required this.required, required this.hasError});

  final String label;
  final bool required;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: _mainStyle(
              color:
                  hasError ? const Color(0xFFEF4444) : const Color(0xFFEDE8FF),
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (required)
          Text(
            '*',
            style: _mainStyle(
              color: const Color(0xFFEF4444),
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: selected ? const Color(0x126F3FF5) : const Color(0xFF252040),
            border: Border.all(
              color:
                  selected ? const Color(0x886F3FF5) : const Color(0xFF332D55),
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected
                    ? const Color(0xFFB9A3FF)
                    : const Color(0xFF8B7DC8),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(label,
                    style: _mainStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.isArabic,
    required this.fileName,
    required this.hasError,
    required this.onPick,
    required this.onClear,
  });

  final bool isArabic;
  final String? fileName;
  final bool hasError;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPick,
              borderRadius: BorderRadius.circular(10.r),
              child: Ink(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: hasError
                      ? const Color(0x0CEF4444)
                      : const Color(0x106F3FF5),
                  border: Border.all(
                    color: hasError
                        ? const Color(0x99EF4444)
                        : const Color(0x736F3FF5),
                    width: 1.4.w,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        color: const Color(0x1F6F3FF5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.cloud_upload_outlined,
                          color: const Color(0xFFB9A3FF), size: 23.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            fileName ??
                                (isArabic ? 'ارفع اللوجو' : 'Upload logo'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _mainStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            isArabic
                                ? 'PNG, JPG, WEBP, SVG أو PDF'
                                : 'PNG, JPG, WEBP, SVG or PDF',
                            style: _mutedStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w600),
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
        if (onClear != null) ...[
          SizedBox(width: 8.w),
          IconButton.filledTonal(
            onPressed: onClear,
            icon: Icon(Icons.close, size: 20.sp),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0x12EF4444),
              foregroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
        ],
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow(
      {required this.value, required this.label, required this.onChanged});

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10.r),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (next) => onChanged(next ?? false),
            activeColor: const Color(0xFF6F3FF5),
          ),
          Expanded(
            child: Text(label,
                style:
                    _mainStyle(fontSize: 12.sp, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _AlertBox extends StatelessWidget {
  const _AlertBox({
    required this.message,
    this.isSuccess = false,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final bool isSuccess;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(isSuccess ? Icons.check_circle_outline : Icons.error_outline,
              color: color, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: _mainStyle(
                  color: color, fontSize: 12.sp, fontWeight: FontWeight.w800),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isArabic,
    required this.isSubmitting,
    required this.onPressed,
  });

  final bool isArabic;
  final bool isSubmitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6F3FF5),
          disabledBackgroundColor: const Color(0x996F3FF5),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: isSubmitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                  SizedBox(width: 10.w),
                  Text(isArabic ? 'جاري الإرسال...' : 'Sending...'),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isArabic ? 'إرسال الطلب' : 'Send request',
                    style: _mainStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 10.w),
                  Icon(isArabic ? Icons.arrow_forward : Icons.arrow_forward,
                      size: 19.sp),
                ],
              ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              color: const Color(0xFFEF4444), size: 15.sp),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              message,
              style: _mainStyle(
                color: const Color(0xFFEF4444),
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint, {required bool hasError}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: _mutedStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
    filled: true,
    fillColor: hasError ? const Color(0x0CEF4444) : const Color(0xFF252040),
    contentPadding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
    border: _fieldBorder(const Color(0xFF332D55)),
    enabledBorder: _fieldBorder(
        hasError ? const Color(0xB3EF4444) : const Color(0xFF332D55)),
    focusedBorder: _fieldBorder(
        hasError ? const Color(0xFFEF4444) : const Color(0x996F3FF5)),
  );
}

OutlineInputBorder _fieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.r),
    borderSide: BorderSide(color: color, width: 1.w),
  );
}

BoxDecoration _panelDecoration({required double radius}) {
  return BoxDecoration(
    color: const Color(0xFF1E1B30),
    border: Border.all(color: const Color(0xFF332D55)),
    borderRadius: BorderRadius.circular(radius),
  );
}

TextStyle _mainStyle({
  Color color = const Color(0xFFEDE8FF),
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: 0,
  );
}

TextStyle _mutedStyle({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
}) {
  return _mainStyle(
    color: const Color(0xFFB9A3FF),
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
  );
}

enum _StartServiceId { mobile, web, content }

enum _QuestionType { text, tel, textarea, select }

class _LangText {
  const _LangText(this.ar, this.en);

  final String ar;
  final String en;

  String text(bool isArabic) => isArabic ? ar : en;
}

class _StartOption {
  const _StartOption(this.value, this.label);

  final String value;
  final _LangText label;
}

class _StartQuestion {
  const _StartQuestion({
    required this.key,
    required this.label,
    required this.type,
    this.placeholder,
    this.required = false,
    this.rows = 3,
    this.options = const [],
  });

  final String key;
  final _LangText label;
  final _QuestionType type;
  final _LangText? placeholder;
  final bool required;
  final int rows;
  final List<_StartOption> options;
}

class _StartServiceConfig {
  const _StartServiceConfig({
    required this.id,
    required this.icon,
    required this.accent,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.questions,
  });

  final _StartServiceId id;
  final IconData icon;
  final Color accent;
  final _LangText title;
  final _LangText shortTitle;
  final _LangText description;
  final List<_StartQuestion> questions;
}

const _identityOptions = [
  _StartOption('from-logo', _LangText('الألوان من اللوجو', 'Colors from logo')),
  _StartOption('studio-style',
      _LangText('ستايل متفق عليه من قبل الاستوديو', 'Studio-approved style')),
  _StartOption(
      'custom-palette', _LangText('لدي ألوان محددة', 'I have specific colors')),
  _StartOption('need-help',
      _LangText('أحتاج اقتراح هوية', 'I need identity suggestions')),
];

const _services = [
  _StartServiceConfig(
    id: _StartServiceId.mobile,
    icon: Icons.phone_android,
    accent: Color(0xFF22C55E),
    shortTitle: _LangText('موبايل', 'Mobile'),
    title: _LangText('تطبيق موبايل', 'Mobile App'),
    description: _LangText(
      'ابدأ تطبيق Android أو iOS بمعلومات واضحة تساعدنا نفهم الفكرة والجمهور والخصائص الأساسية.',
      'Start an Android or iOS app brief with the key details we need to understand the idea, users, and features.',
    ),
    questions: [
      _StartQuestion(
        key: 'appIdea',
        type: _QuestionType.textarea,
        required: true,
        rows: 4,
        label: _LangText('فكرة التطبيق باختصار', 'App idea in brief'),
        placeholder: _LangText(
          'اكتب التطبيق هيحل مشكلة إيه أو هيقدم قيمة إيه للمستخدم',
          'Describe the problem the app solves or the value it provides.',
        ),
      ),
      _StartQuestion(
        key: 'targetUsers',
        type: _QuestionType.textarea,
        required: true,
        label: _LangText('مين المستخدم المستهدف؟', 'Who are the target users?'),
      ),
      _StartQuestion(
        key: 'platform',
        type: _QuestionType.select,
        required: true,
        label: _LangText('المنصة المطلوبة', 'Target platform'),
        options: [
          _StartOption('android', _LangText('Android', 'Android')),
          _StartOption('ios', _LangText('iOS', 'iOS')),
          _StartOption('both', _LangText('Android و iOS', 'Android and iOS')),
        ],
      ),
      _StartQuestion(
        key: 'features',
        type: _QuestionType.textarea,
        required: true,
        rows: 4,
        label: _LangText('أهم الخصائص المطلوبة', 'Main required features'),
        placeholder: _LangText(
          'مثال: تسجيل دخول، دفع إلكتروني، إشعارات، لوحة تحكم...',
          'Example: login, online payments, notifications, dashboard...',
        ),
      ),
      _StartQuestion(
        key: 'referenceApps',
        type: _QuestionType.textarea,
        label: _LangText(
            'تطبيقات مرجعية أو منافسين', 'Reference apps or competitors'),
      ),
    ],
  ),
  _StartServiceConfig(
    id: _StartServiceId.web,
    icon: Icons.desktop_windows_outlined,
    accent: Color(0xFF38BDF8),
    shortTitle: _LangText('ويب', 'Web'),
    title: _LangText('موقع ويب', 'Website'),
    description: _LangText(
      'جهز Brief واضح لموقع شركتك، متجر إلكتروني، أو Landing Page مع أهدافك ومحتوى الصفحات.',
      'Prepare a clean brief for a company website, online store, or landing page with your goals and page content.',
    ),
    questions: [
      _StartQuestion(
        key: 'websiteType',
        type: _QuestionType.select,
        required: true,
        label: _LangText('نوع الموقع', 'Website type'),
        options: [
          _StartOption(
              'company', _LangText('موقع تعريفي لشركة', 'Company website')),
          _StartOption('store', _LangText('متجر إلكتروني', 'E-commerce store')),
          _StartOption('landing', _LangText('Landing Page', 'Landing page')),
          _StartOption('custom', _LangText('نظام مخصص', 'Custom platform')),
        ],
      ),
      _StartQuestion(
        key: 'websiteGoal',
        type: _QuestionType.textarea,
        required: true,
        label: _LangText('هدف الموقع الأساسي', 'Main website goal'),
        placeholder: _LangText(
          'بيع، حجز، طلب عروض أسعار، تعريف بالبراند...',
          'Sales, bookings, quotation requests, brand awareness...',
        ),
      ),
      _StartQuestion(
        key: 'pages',
        type: _QuestionType.textarea,
        required: true,
        rows: 4,
        label: _LangText('الصفحات المطلوبة', 'Required pages'),
        placeholder: _LangText(
          'الرئيسية، من نحن، الخدمات، أعمالنا، تواصل معنا...',
          'Home, about, services, portfolio, contact...',
        ),
      ),
      _StartQuestion(
        key: 'integrations',
        type: _QuestionType.textarea,
        label: _LangText('تكاملات مطلوبة', 'Required integrations'),
        placeholder: _LangText(
          'دفع إلكتروني، واتساب، CRM، Analytics، شحن...',
          'Payments, WhatsApp, CRM, Analytics, shipping...',
        ),
      ),
      _StartQuestion(
        key: 'deadline',
        type: _QuestionType.text,
        label: _LangText('موعد الإطلاق المتوقع', 'Expected launch date'),
      ),
    ],
  ),
  _StartServiceConfig(
    id: _StartServiceId.content,
    icon: Icons.edit_note,
    accent: Color(0xFFD4AF37),
    shortTitle: _LangText('محتوى', 'Content'),
    title: _LangText('إنشاء المحتوى', 'Content Creation'),
    description: _LangText(
      'فورم مختصر يدي فريق التصميم والمحتوى كل تفاصيل البراند، الهوية، السوشيال، والعروض.',
      'A focused brief for the design and content team covering brand, identity, socials, and offers.',
    ),
    questions: [
      _StartQuestion(
        key: 'brandName',
        type: _QuestionType.text,
        required: true,
        label: _LangText('اسم الشركة / البراند', 'Company / brand name'),
      ),
      _StartQuestion(
        key: 'companyOverview',
        type: _QuestionType.textarea,
        required: true,
        label: _LangText('نبذة سريعة عن الشركة', 'Short company overview'),
      ),
      _StartQuestion(
        key: 'mainProducts',
        type: _QuestionType.textarea,
        required: true,
        label: _LangText(
            'الخدمات أو المنتجات الأساسية', 'Core services or products'),
      ),
      _StartQuestion(
        key: 'targetCustomer',
        type: _QuestionType.textarea,
        required: true,
        label:
            _LangText('مين العميل المستهدف؟', 'Who is your target customer?'),
      ),
      _StartQuestion(
        key: 'differentiator',
        type: _QuestionType.textarea,
        required: true,
        label: _LangText(
          'إيه أكتر حاجة بتميزكم عن المنافسين؟',
          'What makes you different from competitors?',
        ),
      ),
      _StartQuestion(
        key: 'designStyle',
        type: _QuestionType.select,
        required: true,
        label: _LangText('ستايل التصميم المطلوب', 'Preferred design style'),
        options: [
          _StartOption('modern', _LangText('مودرن', 'Modern')),
          _StartOption('luxury', _LangText('فاخر', 'Luxury')),
          _StartOption('simple', _LangText('بسيط', 'Simple')),
          _StartOption('bold', _LangText('جريء', 'Bold')),
          _StartOption('friendly', _LangText('ودود', 'Friendly')),
          _StartOption('other', _LangText('ستايل آخر', 'Other style')),
        ],
      ),
      _StartQuestion(
        key: 'contactNumber',
        type: _QuestionType.tel,
        label: _LangText(
            'رقم التواصل الذي يظهر في التصميم', 'Contact number for designs'),
      ),
      _StartQuestion(
          key: 'address',
          type: _QuestionType.text,
          label: _LangText('العنوان', 'Address')),
      _StartQuestion(
        key: 'offerLine',
        type: _QuestionType.textarea,
        label:
            _LangText('أي عروض أو جملة تسويقية', 'Offers or marketing slogan'),
      ),
      _StartQuestion(
        key: 'focusFeatures',
        type: _QuestionType.textarea,
        required: true,
        label: _LangText(
          'خدمات أو مميزات حابب نركز عليها في المحتوى',
          'Services or benefits you want us to focus on',
        ),
      ),
      _StartQuestion(
        key: 'notes',
        type: _QuestionType.textarea,
        label: _LangText('ملاحظات إضافية', 'Additional notes'),
      ),
    ],
  ),
];

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const _draftKey = 'start_now_draft';
const _endpoint = 'https://etba3ly-dm.com/api/proxy.php';
const _projectImagesEndpoint =
    'https://etba3ly-dm.com/api/upload-project-images.php';
const _whatsAppUrl = 'https://wa.me/+201010285020';

class StartNowPage extends StatefulWidget {
  const StartNowPage({super.key, this.initialService});

  /// Pre-selects a service tab (`mobile`, `web`, `content` or `rebrand`), like
  /// the website's `?service=` link.
  final String? initialService;

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

  // Logo state
  PlatformFile? _logoFile;
  String _logoError = '';
  bool _logoProcessing = false;
  String _logoSizeMb = '';
  Uint8List? _logoBytes; // compressed bytes for raster logos

  // Project images state
  final List<_ProjectImageEntry> _projectImages = [];
  String _projectImagesError = '';
  bool _projectImagesProcessing = false;

  bool get _isArabic => context.locale.languageCode == 'ar';

  _StartServiceConfig get _selectedService => _services.firstWhere(
        (service) => service.id == _selectedServiceId,
        orElse: () => _services[2],
      );

  bool get _isRebrand => _selectedServiceId == _StartServiceId.rebrand;

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
    if (_identityMode == 'from-logo' && _logoFile != null) count++;
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
    _loadDraft().then((_) => _applyInitialService());
  }

  void _applyInitialService() {
    final requested = widget.initialService;
    if (!mounted || requested == null) return;
    for (final service in _services) {
      if (service.id.name == requested) {
        setState(() => _selectedServiceId = service.id);
        _saveDraft();
        return;
      }
    }
  }

  @override
  void dispose() {
    for (final image in _projectImages) {
      image.dispose();
    }
    _contactName.dispose();
    _whatsApp.dispose();
    _email.dispose();
    _company.dispose();
    _brandColors.dispose();
    for (final c in _answers.values) {
      c.dispose();
    }
    for (final c in _socials.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.width >= 720;

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.etbalyColors.bgMain,
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
                style: _mutedStyle(context,
                    fontSize: 12.sp, fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              _selectedService.title.text(_isArabic),
              textAlign: TextAlign.end,
              style: _mainStyle(context,
                  fontSize: 13.sp, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth > 430;
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _services.map((service) {
                return SizedBox(
                  width: twoColumns
                      ? (constraints.maxWidth - 8.w) / 2
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
                forceLtr: true,
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
          isDisabled: _logoProcessing || _projectImagesProcessing,
          onPressed: _submitForm,
        ),
        SizedBox(height: 8.h),
        const EtbalyPrivacyLink(),
      ],
    );
  }

  Widget _buildIdentityBlock() {
    final rebrand = _isRebrand;
    final ar = _isArabic;
    final needsLogo = _identityMode == 'from-logo';
    final logoMissing =
        _formTouched && needsLogo && _logoFile == null && !_logoProcessing;

    final uploadTitle = ar
        ? (rebrand
            ? (needsLogo ? 'ارفع اللوجو القديم' : 'ارفع اللوجو القديم إن وجد')
            : 'ارفع اللوجو')
        : (rebrand
            ? (needsLogo ? 'Upload old logo' : 'Upload old logo if available')
            : 'Upload logo');

    return _FormBlock(
      number: '03',
      title: rebrand
          ? (ar ? 'اللوجو القديم والألوان' : 'Old logo and colors')
          : (ar ? 'الهوية والسوشيال' : 'Identity and socials'),
      subtitle: rebrand
          ? (ar
              ? 'ارفع اللوجو القديم إن وجد، وحدد هل تفضل ألوان معينة أو تترك الاستوديو يحلل الاتجاه الأنسب.'
              : 'Upload the old logo if available, then choose preferred colors or let the studio analyze the best direction.')
          : (ar
              ? 'اختار مصدر الألوان وأضف الروابط أو فعل خيار لا أملك صفحات.'
              : 'Choose the color source and add links, or mark that you do not have social pages.'),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 520;
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _identityOptionsFor(rebrand: rebrand).map((option) {
                return SizedBox(
                  width: twoColumns
                      ? (constraints.maxWidth - 8.w) / 2
                      : double.infinity,
                  child: _ChoicePill(
                    label: option.label.text(ar),
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
          label: rebrand
              ? (ar ? 'الألوان المفضل استخدامها' : 'Preferred colors')
              : (ar
                  ? 'الألوان أو الهوية المستخدمة'
                  : 'Used colors or identity notes'),
          controller: _brandColors,
          hint: rebrand
              ? (ar
                  ? 'اكتب لون أو اتنين أو 3 ألوان مفضلة بالاسم أو الكود'
                  : 'Write one, two, or three preferred colors by name or code')
              : (ar
                  ? 'اكتب أكواد الألوان، وصف الستايل، أو أي ملاحظات عن الهوية'
                  : 'Add color codes, style notes, or identity details'),
          maxLines: 3,
          onChanged: (_) => _saveDraft(),
        ),
        SizedBox(height: 14.h),
        _UploadBox(
          isArabic: ar,
          title: uploadTitle,
          fileName: _logoFile?.name,
          sizeMb: _logoSizeMb.isNotEmpty ? _logoSizeMb : null,
          isProcessing: _logoProcessing,
          hasError: logoMissing,
          onPick: _pickLogo,
          onClear: _logoFile == null ? null : _clearLogo,
        ),
        if (_logoError.isNotEmpty) _InlineError(_logoError),
        if (_logoError.isEmpty && logoMissing)
          _InlineError(
            rebrand
                ? (ar
                    ? 'ارفع اللوجو القديم عند اختيار هذا الاتجاه'
                    : 'Upload the old logo when choosing this direction')
                : (ar
                    ? 'ارفع اللوجو لاستخراج الألوان منه'
                    : 'Upload your logo to extract colors from it'),
          ),
        SizedBox(height: 14.h),
        _ProjectImagesSection(
          isArabic: ar,
          images: _projectImages,
          isProcessing: _projectImagesProcessing,
          error: _projectImagesError,
          formTouched: _formTouched,
          onPick: _pickProjectImages,
          onRemove: _removeProjectImage,
          onClearAll: _clearProjectImages,
          onDetailsChanged: () => setState(() => _projectImagesError = ''),
          maxImages: _maxProjectImages,
        ),
        // The Rebrand brief has no social-media section.
        if (!rebrand) ...[
          SizedBox(height: 12.h),
          _CheckRow(
            value: _noSocialPages,
            label: ar
                ? 'لا أملك صفحات تواصل اجتماعي حاليًا'
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

    if (question.type == _QuestionType.multiselect) {
      return _MultiSelectBox(
        label: question.label.text(_isArabic),
        required: question.required,
        options: question.options,
        selected: _selectionsOf(controller),
        maxSelections: question.maxSelections,
        isArabic: _isArabic,
        error: error,
        onToggle: (value, checked) =>
            _toggleMultiOption(question, value, checked),
      );
    }

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

    final isPhone = question.type == _QuestionType.tel;
    return _TextFieldBox(
      label: question.label.text(_isArabic),
      required: question.required,
      controller: controller,
      hint: question.placeholder?.text(_isArabic) ?? '',
      maxLines: question.type == _QuestionType.textarea ? question.rows : 1,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      forceLtr: isPhone,
      error: error,
      onChanged: (value) {
        if (isPhone) {
          _onPhoneChanged(question.key, value, controller);
        } else {
          _saveDraft();
          setState(() {});
        }
      },
    );
  }

  /// A multi-select answer is stored as "a, b, c" — the website's format.
  List<String> _selectionsOf(TextEditingController controller) {
    return controller.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  void _toggleMultiOption(_StartQuestion question, String value, bool checked) {
    final controller = _controllerFor(question.key);
    final selections = _selectionsOf(controller);
    final current = selections.toSet();

    if (checked) {
      final limit = question.maxSelections;
      if (limit != null &&
          selections.length >= limit &&
          !current.contains(value)) {
        return;
      }
      current.add(value);
    } else {
      current.remove(value);
    }

    controller.text = current.join(', ');
    _saveDraft();
    setState(() {});
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

    final ext = (file.extension ?? '').toLowerCase();

    // SVG and PDF: no compression needed
    if (ext == 'svg' || ext == 'pdf') {
      setState(() {
        _logoFile = file;
        _logoBytes = null;
        _logoSizeMb = '${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB';
      });
      return;
    }

    final path = file.path;
    if (path == null) {
      setState(() {
        _logoError =
            _isArabic ? 'تعذر قراءة الملف.' : 'Could not read the file.';
      });
      return;
    }

    setState(() => _logoProcessing = true);
    try {
      final rawBytes = await File(path).readAsBytes();
      final compressed = await _compressImage(rawBytes);
      setState(() {
        _logoFile = file;
        _logoBytes = compressed;
        _logoSizeMb =
            '${(compressed.length / (1024 * 1024)).toStringAsFixed(2)} MB';
      });
    } catch (_) {
      setState(() {
        _logoError = _isArabic
            ? 'تعذر تجهيز الصورة. جرب ملفاً آخر أو استخدم SVG أو PDF.'
            : 'Could not process the image. Try another file or use SVG/PDF.';
      });
    } finally {
      setState(() => _logoProcessing = false);
    }
  }

  void _clearLogo() {
    setState(() {
      _logoFile = null;
      _logoBytes = null;
      _logoSizeMb = '';
      _logoError = '';
      _logoProcessing = false;
    });
  }

  static const _maxProjectImages = 10;

  Future<void> _pickProjectImages() async {
    setState(() => _projectImagesError = '');

    final remaining = _maxProjectImages - _projectImages.length;
    if (remaining <= 0) {
      setState(() {
        _projectImagesError = _isArabic
            ? 'وصلت للحد الأقصى ($_maxProjectImages صور)'
            : 'Maximum of $_maxProjectImages images reached';
      });
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
      allowMultiple: true,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    setState(() => _projectImagesProcessing = true);
    final rejected = <String>[];
    final toProcess = result.files.take(remaining).toList();

    for (final file in toProcess) {
      final bytes = file.bytes;
      if (bytes == null) {
        rejected.add(file.name);
        continue;
      }
      try {
        final compressed = await _compressImage(bytes);
        _projectImages
            .add(_ProjectImageEntry(name: file.name, bytes: compressed));
      } catch (_) {
        rejected.add(file.name);
      }
    }

    setState(() {
      _projectImagesProcessing = false;
      if (result.files.length > remaining) {
        _projectImagesError = _isArabic
            ? 'تم إضافة $remaining صورة فقط — الحد الأقصى $_maxProjectImages صور'
            : 'Only $remaining image(s) added — maximum is $_maxProjectImages';
      } else if (rejected.isNotEmpty) {
        _projectImagesError = _isArabic
            ? 'تعذر إضافة بعض الملفات: ${rejected.join('، ')}'
            : 'Some files could not be added: ${rejected.join(', ')}';
      }
    });
  }

  void _removeProjectImage(int index) {
    final removed = _projectImages[index];
    setState(() {
      _projectImages.removeAt(index);
      _projectImagesError = '';
    });
    _disposeLater([removed]);
  }

  void _clearProjectImages() {
    final removed = List.of(_projectImages);
    setState(() {
      _projectImages.clear();
      _projectImagesError = '';
    });
    _disposeLater(removed);
  }

  /// The removed cards' text fields are still on screen until the next frame.
  void _disposeLater(List<_ProjectImageEntry> entries) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final entry in entries) {
        entry.dispose();
      }
    });
  }

  Future<Uint8List> _compressImage(Uint8List bytes) async {
    const targetSize = 4 * 1024 * 1024; // 4 MB
    if (bytes.length <= targetSize) return bytes;

    for (final quality in [90, 80, 70, 60]) {
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        quality: quality,
        format: CompressFormat.webp,
      );
      if (result.length <= targetSize) return result;
    }

    return FlutterImageCompress.compressWithList(
      bytes,
      quality: 50,
      format: CompressFormat.webp,
    );
  }

  /// Western digits only, with an optional leading "+": the website turns
  /// Arabic-Indic digits into Latin ones and drops spaces, dashes and marks.
  String _normalizePhone(String value) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const persian = '۰۱۲۳۴۵۶۷۸۹';
    final latin = StringBuffer();
    for (final rune in value.runes) {
      final char = String.fromCharCode(rune);
      var index = arabicIndic.indexOf(char);
      if (index < 0) index = persian.indexOf(char);
      latin.write(index >= 0 ? '$index' : char);
    }
    final text = latin
        .toString()
        .replaceAll(RegExp(r'[\u200e\u200f\u202a-\u202e\u2066-\u2069]'), '');
    final hasLeadingPlus = text.trim().startsWith('+');
    final digits = text.replaceAll(RegExp(r'\D'), '');
    return '${hasLeadingPlus ? '+' : ''}$digits';
  }

  void _onPhoneChanged(
      String key, String value, TextEditingController controller) {
    final cleaned = _normalizePhone(value);
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
        if (_projectImages.any((image) => !image.isComplete)) {
          _projectImagesError = _isArabic
              ? 'أكمل اسم المنتج ووصفه لكل صورة مشروع قبل الإرسال.'
              : 'Complete the product name and description for every project image before sending.';
        }
        _validationMessage = _isArabic
            ? 'راجع البيانات المطلوبة قبل الإرسال.'
            : 'Please review the required fields before submitting.';
      });
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final whatsapp = _normalizePhone(_whatsApp.text);
      final phoneKeys = {
        for (final question in _selectedService.questions)
          if (question.type == _QuestionType.tel) question.key,
      };
      final answers = <String, String>{
        for (final entry in _answers.entries)
          entry.key: phoneKeys.contains(entry.key)
              ? _normalizePhone(entry.value.text)
              : entry.value.text.trim(),
      };
      // The Rebrand brief has no social section.
      final socials = <String, String>{
        for (final entry in _socials.entries)
          entry.key: _isRebrand ? '' : entry.value.text.trim(),
      };

      final dataMap = <String, dynamic>{
        'service_type': _selectedServiceId.name,
        'contact_name': _contactName.text.trim(),
        'whatsapp': whatsapp,
        if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
        if (_company.text.trim().isNotEmpty) 'company': _company.text.trim(),
        'answers': jsonEncode(answers),
        'identity_mode': _identityMode,
        if (_brandColors.text.trim().isNotEmpty)
          'brand_colors': _brandColors.text.trim(),
        'social_links': jsonEncode(socials),
        'no_social': (_isRebrand || _noSocialPages) ? '1' : '0',
      };

      // Add logo (compressed bytes preferred, fall back to file path)
      if (_logoBytes != null && _logoFile != null) {
        dataMap['logo'] = MultipartFile.fromBytes(
          _logoBytes!,
          filename: _logoFile!.name,
        );
      } else if (_logoFile?.path != null) {
        dataMap['logo'] = await MultipartFile.fromFile(
          _logoFile!.path!,
          filename: _logoFile!.name,
        );
      }

      final data = FormData.fromMap(dataMap);

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

      // Extract request ID for project images upload
      final requestId = body is Map ? (body['id'] as num?)?.toInt() : null;

      // Upload project images
      var projectImagesUploaded = true;
      if (_projectImages.isNotEmpty) {
        if (requestId == null) {
          projectImagesUploaded = false;
        } else {
          try {
            await _uploadProjectImages(requestId, whatsapp);
          } catch (_) {
            projectImagesUploaded = false;
          }
        }
      }

      await _resetForm();
      if (!mounted) return;
      setState(() {
        _successMessage = projectImagesUploaded
            ? (_isArabic
                ? 'تم إرسال الطلب بنجاح. فريقنا هيتواصل معاك قريبا.'
                : 'Your request was sent successfully. Our team will contact you soon.')
            : (_isArabic
                ? 'تم حفظ الطلب، لكن تعذر رفع بعض صور المشاريع. يمكنك إرسالها لفريقنا عبر واتساب.'
                : 'Your request was saved, but some project images could not be uploaded. You can send them to our team via WhatsApp.');
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

  Future<void> _uploadProjectImages(int requestId, String whatsapp) async {
    const batchSize = 8;
    for (var i = 0; i < _projectImages.length; i += batchSize) {
      final batch = _projectImages.sublist(
        i,
        (i + batchSize).clamp(0, _projectImages.length),
      );
      final formData = FormData.fromMap({
        'request_id': requestId.toString(),
        'whatsapp': whatsapp,
        'project_images_meta': jsonEncode([
          for (final image in batch)
            {
              'productName': image.productName.text.trim(),
              'description': image.description.text.trim(),
            },
        ]),
      });
      for (final image in batch) {
        formData.files.add(MapEntry(
          'project_images[]',
          MultipartFile.fromBytes(image.bytes, filename: image.name),
        ));
      }
      final response = await _dio.post<dynamic>(
        _projectImagesEndpoint,
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      final body = response.data;
      final failed = response.statusCode == null ||
          response.statusCode! >= 400 ||
          (body is Map && body['success'] == false);
      if (failed) throw Exception('project_images_upload_failed');
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
    final hasCompleteProjectImages =
        _projectImages.every((image) => image.isComplete);

    return hasContact &&
        hasRequiredQuestions &&
        hasLogo &&
        _logoError.isEmpty &&
        !_logoProcessing &&
        !_projectImagesProcessing &&
        hasCompleteProjectImages &&
        _projectImages.length <= _maxProjectImages &&
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

      final savedService = (draft['selectedServiceId'] ?? '').toString();

      setState(() {
        for (final service in _services) {
          if (service.id.name == savedService) _selectedServiceId = service.id;
        }
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
    final removedImages = List.of(_projectImages);
    setState(() {
      _noSocialPages = false;
      _identityMode = 'from-logo';
      _logoFile = null;
      _logoBytes = null;
      _logoSizeMb = '';
      _logoError = '';
      _logoProcessing = false;
      _projectImages.clear();
      _projectImagesError = '';
      _formTouched = false;
    });
    _disposeLater(removedImages);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(_whatsAppUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ─── Hero Header ────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Container(
      padding: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.borderColor)),
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
                    context,
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
                ? 'خلينا نفهم مشروعك صح ونطلع نتيجة تليق بيك'
                : 'Let us understand your project properly and deliver results that fit your brand',
            style: _mainStyle(context,
                fontSize: 30.sp, fontWeight: FontWeight.w900, height: 1.12),
          ),
          SizedBox(height: 14.h),
          Text(
            isArabic
                ? 'اختار نوع الخدمة، املأ البيانات المهمة، وارفع اللوجو لو موجود. الفورم مصمم عشان يختصر وقت التواصل ويخلي فريقنا يبدأ بصورة واضحة.'
                : 'Choose a service, add the important details, and upload your logo if available. This form helps our team start with a clear picture.',
            style: _mutedStyle(context,
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
    final c = context.etbalyColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: c.bgSubtle,
        border: Border.all(color: c.borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 17.sp),
          SizedBox(width: 8.w),
          Text(label,
              style: _mainStyle(context,
                  fontSize: 12.sp, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

// ─── Service Tab ─────────────────────────────────────────────────────────────

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
    final c = context.etbalyColors;
    // The glow lives on a DecoratedBox outside the Material: `Ink` paints
    // inside the Material's bounds and would clip it into a rectangle.
    return DecoratedBox(
      decoration: BoxDecoration(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Ink(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color:
                  isActive ? service.accent.withValues(alpha: 0.10) : c.bgCard,
              border: Border.all(
                color: isActive
                    ? service.accent.withValues(alpha: 0.60)
                    : c.borderColor,
              ),
              borderRadius: BorderRadius.circular(10.r),
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
                        style: _mainStyle(context,
                            fontSize: 13.sp, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        service.title.text(isArabic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _mutedStyle(context,
                            fontSize: 11.sp, fontWeight: FontWeight.w700),
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

// ─── Summary Card ────────────────────────────────────────────────────────────

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
    final c = context.etbalyColors;
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: _panelDecoration(context, radius: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceIcon(service: service),
          SizedBox(height: 12.h),
          Text(
            service.title.text(isArabic),
            style: _mainStyle(context,
                fontSize: 16.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 7.h),
          Text(
            service.description.text(isArabic),
            style: _mutedStyle(context,
                fontSize: 12.sp, height: 1.6, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  isArabic ? 'تقدم البيانات' : 'Brief progress',
                  style: _mutedStyle(context,
                      fontSize: 12.sp, fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '$completed/$total',
                style: _mainStyle(
                  context,
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
                backgroundColor: c.bgSubtle,
                valueColor: const AlwaysStoppedAnimation(Color(0xFFD4AF37)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── WhatsApp Button ─────────────────────────────────────────────────────────

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
          child: Builder(builder: (context) {
            final isDark = context.isDarkMode;
            final textColor = isDark ? const Color(0xFF25D366) : Colors.white;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, color: textColor, size: 19.sp),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    isArabic
                        ? 'محتاج مساعدة؟ كلمنا واتساب'
                        : 'Need help? WhatsApp us',
                    textAlign: TextAlign.center,
                    style: _mainStyle(
                      context,
                      color: textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ─── Form Block ──────────────────────────────────────────────────────────────

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
      decoration: _panelDecoration(context, radius: 14.r),
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
                    context,
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
                        style: _mainStyle(context,
                            fontSize: 16.sp, fontWeight: FontWeight.w900)),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: _mutedStyle(context,
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

// ─── Text Field ──────────────────────────────────────────────────────────────

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.label,
    required this.controller,
    this.required = false,
    this.hint = '',
    this.error,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.forceLtr = false,
    this.invalid = false,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final bool required;
  final String hint;
  final String? error;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  /// Phone numbers and links read left-to-right even on the Arabic screen.
  final bool forceLtr;

  /// Red field without an inline message (the caller shows one for the group).
  final bool invalid;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null || invalid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, required: required, hasError: hasError),
        SizedBox(height: 7.h),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: maxLines > 1 ? maxLines : 1,
          maxLength: maxLength,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          textDirection: forceLtr ? TextDirection.ltr : null,
          textAlign: forceLtr ? TextAlign.left : TextAlign.start,
          style:
              _mainStyle(context, fontSize: 13.sp, fontWeight: FontWeight.w600),
          decoration: _inputDecoration(context, hint, hasError: hasError),
        ),
        if (error != null) _InlineError(error!),
      ],
    );
  }
}

// ─── Select Box ──────────────────────────────────────────────────────────────

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
    final c = context.etbalyColors;
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
          dropdownColor: c.bgCard,
          style:
              _mainStyle(context, fontSize: 13.sp, fontWeight: FontWeight.w700),
          decoration: _inputDecoration(context, hint, hasError: error != null),
        ),
        if (error != null) _InlineError(error!),
      ],
    );
  }
}

// ─── Field Label ─────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(
      {required this.label, required this.required, required this.hasError});

  final String label;
  final bool required;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Text.rich(
      TextSpan(
        text: label,
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
        ],
      ),
      style: _mainStyle(
        context,
        color: hasError ? const Color(0xFFEF4444) : c.textMain,
        fontSize: 12.sp,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

// ─── Choice Pill ─────────────────────────────────────────────────────────────

class _ChoicePill extends StatelessWidget {
  const _ChoicePill(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: selected ? const Color(0x126F3FF5) : c.bgSubtle,
            border: Border.all(
              color: selected ? const Color(0x886F3FF5) : c.borderColor,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? const Color(0xFFB9A3FF) : c.textLight,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(label,
                    style: _mainStyle(context,
                        fontSize: 12.sp, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Upload Box (Logo) ───────────────────────────────────────────────────────

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.isArabic,
    required this.title,
    required this.fileName,
    required this.hasError,
    required this.onPick,
    required this.onClear,
    this.isProcessing = false,
    this.sizeMb,
  });

  final bool isArabic;

  /// What the box says before a file is chosen ("Upload logo", ...).
  final String title;
  final String? fileName;
  final bool hasError;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final bool isProcessing;
  final String? sizeMb;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isProcessing ? null : onPick,
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
                      child: isProcessing
                          ? Padding(
                              padding: EdgeInsets.all(11.r),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFB9A3FF),
                              ),
                            )
                          : Icon(Icons.cloud_upload_outlined,
                              color: const Color(0xFFB9A3FF), size: 23.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isProcessing
                                ? (isArabic
                                    ? 'جاري تحسين اللوجو...'
                                    : 'Optimizing logo...')
                                : (fileName ?? title),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _mainStyle(context,
                                fontSize: 13.sp, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            sizeMb != null
                                ? (isArabic
                                    ? 'الحجم بعد التجهيز: $sizeMb'
                                    : 'Processed size: $sizeMb')
                                : (isArabic
                                    ? 'PNG, JPG, WEBP, SVG أو PDF - أي أبعاد، والصور الكبيرة تُحسّن تلقائياً'
                                    : 'PNG, JPG, WEBP, SVG or PDF - any dimensions, optimized automatically'),
                            maxLines: 2,
                            style: _mutedStyle(context,
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

// ─── Project Images Section ──────────────────────────────────────────────────

class _ProjectImagesSection extends StatelessWidget {
  const _ProjectImagesSection({
    required this.isArabic,
    required this.images,
    required this.isProcessing,
    required this.error,
    required this.formTouched,
    required this.onPick,
    required this.onRemove,
    required this.onClearAll,
    required this.onDetailsChanged,
    this.maxImages = 10,
  });

  final bool isArabic;
  final List<_ProjectImageEntry> images;
  final bool isProcessing;
  final String error;
  final bool formTouched;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;
  final VoidCallback onClearAll;
  final VoidCallback onDetailsChanged;
  final int maxImages;

  @override
  Widget build(BuildContext context) {
    final full = images.length >= maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'صور مشاريع سابقة' : 'Previous project images',
                    style: _mainStyle(context,
                        fontSize: 13.sp, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    isArabic
                        ? 'اختياري - وإذا أضفت صورًا، اكتب اسم المنتج ووصفه لكل صورة'
                        : 'Optional - up to $maxImages images. If you add images, enter a product name and description for each one',
                    style: _mutedStyle(context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.5),
                  ),
                ],
              ),
            ),
            if (images.isNotEmpty) ...[
              SizedBox(width: 6.w),
              TextButton.icon(
                onPressed: onClearAll,
                icon: Icon(Icons.delete_outline_rounded,
                    size: 16.sp, color: const Color(0xFFEF4444)),
                label: Text(
                  isArabic ? 'حذف الكل' : 'Clear all',
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFFEF4444)),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 10.h),
        Opacity(
          opacity: full ? 0.5 : 1,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (isProcessing || full) ? null : onPick,
              borderRadius: BorderRadius.circular(10.r),
              child: Ink(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                decoration: BoxDecoration(
                  color: const Color(0x0A6F3FF5),
                  border: Border.all(
                    color: const Color(0x4A6F3FF5),
                    width: 1.4.w,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isProcessing)
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFB9A3FF),
                        ),
                      )
                    else
                      Icon(Icons.collections_outlined,
                          color: const Color(0xFFB9A3FF), size: 20.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        isProcessing
                            ? (isArabic
                                ? 'جاري تجهيز الصور...'
                                : 'Preparing images...')
                            : (isArabic
                                ? 'إضافة صور المشاريع'
                                : 'Add project images'),
                        style: _mainStyle(context,
                            fontSize: 13.sp, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      'PNG, JPG, WEBP · ${images.length}/$maxImages',
                      textDirection: TextDirection.ltr,
                      style: _mutedStyle(context,
                          fontSize: 11.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          isArabic
              ? 'يمكنك رفع $maxImages صور كحد أقصى للمشاريع السابقة.'
              : 'You can upload up to $maxImages previous project images.',
          style: _mutedStyle(context,
              fontSize: 11.sp, fontWeight: FontWeight.w600),
        ),
        if (images.isNotEmpty) ...[
          SizedBox(height: 12.h),
          for (var i = 0; i < images.length; i++) ...[
            _ProjectImageCard(
              key: ObjectKey(images[i]),
              entry: images[i],
              index: i,
              isArabic: isArabic,
              formTouched: formTouched,
              onRemove: () => onRemove(i),
              onChanged: onDetailsChanged,
            ),
            if (i < images.length - 1) SizedBox(height: 12.h),
          ],
        ],
        if (error.isNotEmpty) _InlineError(error),
      ],
    );
  }
}

/// A picked project picture with its product name and description fields.
class _ProjectImageCard extends StatelessWidget {
  const _ProjectImageCard({
    super.key,
    required this.entry,
    required this.index,
    required this.isArabic,
    required this.formTouched,
    required this.onRemove,
    required this.onChanged,
  });

  final _ProjectImageEntry entry;
  final int index;
  final bool isArabic;
  final bool formTouched;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final nameInvalid = formTouched && entry.productName.text.trim().isEmpty;
    final descriptionInvalid =
        formTouched && entry.description.text.trim().isEmpty;

    return Container(
      decoration: BoxDecoration(
        color: c.bgSubtle,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(entry.bytes, fit: BoxFit.cover),
                PositionedDirectional(
                  top: 8.h,
                  start: 8.w,
                  child: Container(
                    width: 26.w,
                    height: 26.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xCC6F3FF5),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 8.h,
                  end: 8.w,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(Icons.close, color: Colors.white, size: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextFieldBox(
                  label: isArabic ? 'اسم المنتج' : 'Product name',
                  required: true,
                  controller: entry.productName,
                  hint: isArabic
                      ? 'مثال: منتج عناية بالشعر'
                      : 'Example: Hair care product',
                  maxLength: 160,
                  invalid: nameInvalid,
                  onChanged: (_) => onChanged(),
                ),
                SizedBox(height: 12.h),
                _TextFieldBox(
                  label: isArabic ? 'وصف المنتج' : 'Product description',
                  required: true,
                  controller: entry.description,
                  hint: isArabic
                      ? 'اكتب وصفًا مختصرًا للمنتج والعمل الذي تم تنفيذه'
                      : 'Briefly describe the product and the work completed',
                  maxLines: 3,
                  maxLength: 1200,
                  invalid: descriptionInvalid,
                  onChanged: (_) => onChanged(),
                ),
                if (nameInvalid || descriptionInvalid)
                  _InlineError(
                    isArabic
                        ? 'اسم المنتج ووصفه مطلوبان لهذه الصورة'
                        : 'Product name and description are required for this image',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Multi-select ────────────────────────────────────────────────────────────

/// A checklist question ("what should people feel about the brand?"). Shows
/// how many picks are allowed when the question has a limit.
class _MultiSelectBox extends StatelessWidget {
  const _MultiSelectBox({
    required this.label,
    required this.options,
    required this.selected,
    required this.isArabic,
    required this.onToggle,
    this.required = false,
    this.maxSelections,
    this.error,
  });

  final String label;
  final bool required;
  final List<_StartOption> options;
  final List<String> selected;
  final int? maxSelections;
  final bool isArabic;
  final String? error;
  final void Function(String value, bool checked) onToggle;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final limitReached =
        maxSelections != null && selected.length >= maxSelections!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, required: required, hasError: error != null),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: c.bgSubtle,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: error != null ? const Color(0xB3EF4444) : c.borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  for (final option in options)
                    _MultiOptionTile(
                      label: option.label.text(isArabic),
                      checked: selected.contains(option.value),
                      disabled:
                          limitReached && !selected.contains(option.value),
                      onTap: () => onToggle(
                          option.value, !selected.contains(option.value)),
                    ),
                ],
              ),
              if (maxSelections != null) ...[
                SizedBox(height: 8.h),
                Text(
                  isArabic
                      ? 'اختر حتى $maxSelections فقط'
                      : 'Choose up to $maxSelections',
                  style: _mutedStyle(context,
                      fontSize: 11.sp, fontWeight: FontWeight.w700),
                ),
              ],
            ],
          ),
        ),
        if (error != null) _InlineError(error!),
      ],
    );
  }
}

class _MultiOptionTile extends StatelessWidget {
  const _MultiOptionTile({
    required this.label,
    required this.checked,
    required this.disabled,
    required this.onTap,
  });

  final String label;
  final bool checked;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(999.r),
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: checked ? const Color(0x1F6F3FF5) : c.bgCard,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: checked ? const Color(0x886F3FF5) : c.borderColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  checked
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 17.sp,
                  color: checked ? const Color(0xFFB9A3FF) : c.textLight,
                ),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: _mainStyle(context,
                      fontSize: 12.sp, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Check Row ───────────────────────────────────────────────────────────────

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
                style: _mainStyle(context,
                    fontSize: 12.sp, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

// ─── Alert Box ───────────────────────────────────────────────────────────────

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
              style: _mainStyle(context,
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

// ─── Submit Button ───────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isArabic,
    required this.isSubmitting,
    required this.onPressed,
    this.isDisabled = false,
  });

  final bool isArabic;
  final bool isSubmitting;
  final VoidCallback onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: (isSubmitting || isDisabled) ? null : onPressed,
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
                  Text(isArabic ? 'جاري الإرسال...' : 'Sending...',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isArabic ? 'إرسال الطلب' : 'Send request',
                    style: _mainStyle(context,
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 10.w),
                  Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back,
                      size: 19.sp, color: Colors.white),
                ],
              ),
      ),
    );
  }
}

// ─── Inline Error ────────────────────────────────────────────────────────────

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
                context,
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

// ─── Shared Helpers ──────────────────────────────────────────────────────────

InputDecoration _inputDecoration(BuildContext context, String hint,
    {required bool hasError}) {
  final c = context.etbalyColors;
  return InputDecoration(
    hintText: hint,
    hintStyle:
        _mutedStyle(context, fontSize: 12.sp, fontWeight: FontWeight.w500),
    filled: true,
    fillColor: hasError ? const Color(0x0CEF4444) : c.bgSubtle,
    contentPadding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
    border: _fieldBorder(c.borderColor),
    enabledBorder:
        _fieldBorder(hasError ? const Color(0xB3EF4444) : c.borderColor),
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

BoxDecoration _panelDecoration(BuildContext context, {required double radius}) {
  final c = context.etbalyColors;
  return BoxDecoration(
    color: c.bgCard,
    border: Border.all(color: c.borderColor),
    borderRadius: BorderRadius.circular(radius),
  );
}

TextStyle _mainStyle(
  BuildContext context, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
}) {
  return TextStyle(
    color: color ?? context.etbalyColors.textMain,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: 0,
  );
}

TextStyle _mutedStyle(
  BuildContext context, {
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
}) {
  return _mainStyle(
    context,
    color: context.etbalyColors.textMuted,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
  );
}

// ─── Data Models ─────────────────────────────────────────────────────────────

/// One "previous project" picture with the product name and description the
/// team asks for alongside it.
class _ProjectImageEntry {
  _ProjectImageEntry({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
  final productName = TextEditingController();
  final description = TextEditingController();

  bool get isComplete =>
      productName.text.trim().isNotEmpty && description.text.trim().isNotEmpty;

  void dispose() {
    productName.dispose();
    description.dispose();
  }
}

enum _StartServiceId { mobile, web, content, rebrand }

enum _QuestionType { text, tel, textarea, select, multiselect }

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
    this.maxSelections,
    this.options = const [],
  });

  final String key;
  final _LangText label;
  final _QuestionType type;
  final _LangText? placeholder;
  final bool required;
  final int rows;

  /// For multi-select questions: how many options may be ticked (null = any).
  final int? maxSelections;
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

// ─── Identity Options ────────────────────────────────────────────────────────

/// The three colour-source choices; the Rebrand form words them differently.
List<_StartOption> _identityOptionsFor({required bool rebrand}) => [
      _StartOption(
        'from-logo',
        rebrand
            ? const _LangText('من اللوجو القديم', 'From the old logo')
            : const _LangText(
                'هوية بصرية من اللوجو', 'Visual identity from logo'),
      ),
      _StartOption(
        'need-help',
        rebrand
            ? const _LangText(
                'ألوان مفضلة أكتبها بنفسي', 'I will write preferred colors')
            : const _LangText(
                'احتاج الى هوية بصرية', 'I need a visual identity'),
      ),
      _StartOption(
        'studio-style',
        rebrand
            ? const _LangText(
                'الاستوديو يحلل الاتجاه المناسب',
                'Studio analyzes the best direction',
              )
            : const _LangText(
                'احتاج مراجعة من الاستوديو', 'I need studio review'),
      ),
    ];

// ─── Services Data ───────────────────────────────────────────────────────────

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
        rows: 3,
        label: _LangText('مين المستخدم المستهدف؟', 'Who are the target users?'),
        placeholder: _LangText(
          'مثال: عملاء المطاعم، طلاب جامعات، أصحاب شركات صغيرة...',
          'Example: restaurant customers, university students, small business owners...',
        ),
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
        rows: 3,
        label: _LangText(
            'تطبيقات مرجعية أو منافسين', 'Reference apps or competitors'),
        placeholder: _LangText(
          'اكتب أسماء تطبيقات قريبة من فكرتك أو روابطها لو متاحة',
          'Add similar app names or links if available.',
        ),
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
        rows: 3,
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
        rows: 3,
        label: _LangText('تكاملات مطلوبة', 'Required integrations'),
        placeholder: _LangText(
          'دفع إلكتروني، واتساب، CRM، Analytics، شحن...',
          'Payments, WhatsApp, CRM, Analytics, shipping...',
        ),
      ),
      _StartQuestion(
        key: 'deadline',
        type: _QuestionType.text,
        label: _LangText('ملاحظات إضافية', 'Additional notes'),
        placeholder: _LangText(
          'اكتب أي تفاصيل مهمة عن الميعاد، الأولويات، أو طريقة التنفيذ',
          'Add timing, priorities, or any important implementation notes.',
        ),
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
        placeholder: _LangText(
          'مثال: اطبعلي ديجيتال ماركتنج',
          'Example: Etbaly Digital Marketing',
        ),
      ),
      _StartQuestion(
        key: 'companyOverview',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label: _LangText('نبذة سريعة عن الشركة', 'Short company overview'),
        placeholder: _LangText(
          'عرّفنا بالنشاط، خبرتكم، وأهم ما تقدموه للعملاء',
          'Tell us what you do, your experience, and what you offer customers.',
        ),
      ),
      _StartQuestion(
        key: 'mainProducts',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label: _LangText(
            'الخدمات أو المنتجات الأساسية', 'Core services or products'),
        placeholder: _LangText(
          'اكتب أهم الخدمات أو المنتجات اللي بتقدمها لعملائك',
          'Write the main services or products you offer to your customers',
        ),
      ),
      _StartQuestion(
        key: 'targetCustomer',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label:
            _LangText('مين العميل المستهدف؟', 'Who is your target customer?'),
        placeholder: _LangText(
          'حدد السن، المكان، الاهتمامات، أو نوع الشركات المستهدفة',
          'Describe age, location, interests, or target business types.',
        ),
      ),
      _StartQuestion(
        key: 'differentiator',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label: _LangText(
          'إيه أكتر حاجة بتميزكم عن المنافسين؟',
          'What makes you different from competitors?',
        ),
        placeholder: _LangText(
          'مثال: سرعة التنفيذ، جودة أعلى، سعر مناسب، خبرة متخصصة...',
          'Example: faster delivery, higher quality, better pricing, specialist experience...',
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
          'رقم التواصل الذي يظهر في التصميم',
          'Contact number for designs',
        ),
        placeholder: _LangText('مثال: 01010285020', 'Example: 01010285020'),
      ),
      _StartQuestion(
        key: 'contactNumberAlt1',
        type: _QuestionType.tel,
        label: _LangText(
          'رقم تواصل إضافي 1 (اختياري)',
          'Additional contact number 1 (optional)',
        ),
        placeholder: _LangText(
          'رقم بديل لو حابب يظهر مع التصميم',
          'Alternative number to show on designs if needed.',
        ),
      ),
      _StartQuestion(
        key: 'contactNumberAlt2',
        type: _QuestionType.tel,
        label: _LangText(
          'رقم تواصل إضافي 2 (اختياري)',
          'Additional contact number 2 (optional)',
        ),
        placeholder: _LangText(
          'رقم إضافي آخر أو اتركه فارغًا',
          'Another optional number, or leave it empty.',
        ),
      ),
      _StartQuestion(
        key: 'address',
        type: _QuestionType.text,
        label: _LangText('العنوان', 'Address'),
        placeholder: _LangText(
          'مثال: القاهرة، مدينة نصر، شارع عباس العقاد',
          'Example: Nasr City, Cairo, Abbas El Akkad St.',
        ),
      ),
      _StartQuestion(
        key: 'offerLine',
        type: _QuestionType.textarea,
        rows: 3,
        label:
            _LangText('أي عروض أو جملة تسويقية', 'Offers or marketing slogan'),
        placeholder: _LangText(
          'مثال: خصم 20% لأول طلب أو جملة البراند الأساسية',
          'Example: 20% off first order, or your main brand slogan.',
        ),
      ),
      _StartQuestion(
        key: 'focusFeatures',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label: _LangText(
          'خدمات أو مميزات حابب نركز عليها في المحتوى',
          'Services or benefits you want us to focus on',
        ),
        placeholder: _LangText(
          'اكتب أهم النقاط التي تريد إبرازها في التصميمات والمنشورات',
          'List the key points you want highlighted in designs and posts.',
        ),
      ),
      _StartQuestion(
        key: 'notes',
        type: _QuestionType.textarea,
        rows: 3,
        label: _LangText('ملاحظات إضافية', 'Additional notes'),
        placeholder: _LangText(
          'اكتب أي تفضيلات، ممنوعات، أو تفاصيل تساعدنا نطلع نتيجة أدق',
          'Add preferences, restrictions, or details that help us deliver better work.',
        ),
      ),
    ],
  ),
  _StartServiceConfig(
    id: _StartServiceId.rebrand,
    icon: Icons.auto_fix_high_rounded,
    accent: Color(0xFFA855F7),
    shortTitle: _LangText('Rebrand', 'Rebrand'),
    title: _LangText('طلب Rebrand', 'Rebrand Request'),
    description: _LangText(
      'فورم تفصيلي لتجديد هوية البراند وفهم وضعه الحالي، الجمهور، المنافسين، والاتجاه البصري المطلوب.',
      'A detailed brief for refreshing your brand identity, including current positioning, audience, competitors, and desired visual direction.',
    ),
    questions: [
      _StartQuestion(
        key: 'brandName',
        type: _QuestionType.textarea,
        required: true,
        rows: 2,
        label: _LangText(
          'اسم البراند بالعربي والإنجليزي',
          'Brand name in Arabic and English',
        ),
        placeholder: _LangText(
          'اكتب الاسم بالعربي والإنجليزي في نص قصير',
          'Write the Arabic and English brand name in a short text.',
        ),
      ),
      _StartQuestion(
        key: 'currentBrandFacebook',
        type: _QuestionType.text,
        label: _LangText('رابط فيسبوك الحالي', 'Current Facebook link'),
        placeholder:
            _LangText('https://facebook.com/...', 'https://facebook.com/...'),
      ),
      _StartQuestion(
        key: 'currentBrandInstagram',
        type: _QuestionType.text,
        label: _LangText('رابط إنستجرام الحالي', 'Current Instagram link'),
        placeholder:
            _LangText('https://instagram.com/...', 'https://instagram.com/...'),
      ),
      _StartQuestion(
        key: 'currentBrandTikTok',
        type: _QuestionType.text,
        label: _LangText('رابط تيك توك الحالي', 'Current TikTok link'),
        placeholder:
            _LangText('https://tiktok.com/@...', 'https://tiktok.com/@...'),
      ),
      _StartQuestion(
        key: 'brandOffer',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label: _LangText(
          'بتقدموا إيه بالضبط؟ وإيه أهم منتج أو خدمة عندكم؟',
          'What do you offer, and what is your most important product or service?',
        ),
        placeholder: _LangText(
          'اكتب فقرة قصيرة عن نشاط البراند وأهم منتج أو خدمة',
          'Write a short paragraph about your business and key product or service.',
        ),
      ),
      _StartQuestion(
        key: 'rebrandReason',
        type: _QuestionType.textarea,
        required: true,
        rows: 4,
        label: _LangText(
          'إيه المشكلة في البراند الحالي؟ وليه قررت تعمل Rebrand دلوقتي؟',
          'What is the issue with the current brand, and why rebrand now?',
        ),
        placeholder: _LangText(
          'مثال: الهوية قديمة، الجمهور اتغير، دخلنا سوق جديد، اللوجو ضعيف أو شبه منافسين',
          'Example: outdated identity, changed audience, new market, weak logo, or too similar to competitors.',
        ),
      ),
      _StartQuestion(
        key: 'desiredPerception',
        type: _QuestionType.multiselect,
        required: true,
        label: _LangText(
          'بعد الـ Rebrand عاوز الناس تفهم أو تحس بإيه عن البراند؟',
          'After the rebrand, what should people understand or feel about the brand?',
        ),
        options: [
          _StartOption('trust', _LangText('ثقة', 'Trust')),
          _StartOption('luxury', _LangText('فخامة', 'Luxury')),
          _StartOption('quality', _LangText('جودة', 'Quality')),
          _StartOption('affordable', _LangText('سعر مناسب', 'Affordable')),
          _StartOption('speed', _LangText('سرعة', 'Speed')),
          _StartOption(
              'professional', _LangText('احترافية', 'Professionalism')),
          _StartOption('modern', _LangText('حداثة', 'Modernity')),
          _StartOption('unique', _LangText('تميز', 'Uniqueness')),
          _StartOption(
              'close', _LangText('قرب من العميل', 'Customer closeness')),
          _StartOption('strength', _LangText('قوة', 'Strength')),
        ],
      ),
      _StartQuestion(
        key: 'targetAudience',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label: _LangText(
          'مين العميل اللي عاوز توصله؟',
          'Who is the customer you want to reach?',
        ),
        placeholder: _LangText(
          'العمر التقريبي، رجال أو سيدات، المدينة أو الدولة، أفراد أو شركات، مستوى الأسعار المناسب',
          'Approximate age, gender, city/country, individuals or companies, and suitable price level.',
        ),
      ),
      _StartQuestion(
        key: 'topReasons',
        type: _QuestionType.textarea,
        required: true,
        rows: 3,
        label: _LangText(
          'إيه أقوى 3 أسباب تخلي العميل يختارك بدل المنافس؟',
          'What are the top 3 reasons customers choose you over competitors?',
        ),
        placeholder: _LangText(
          'مثال: خبرة، سعر، جودة، خامات، سرعة، ضمان، خدمة بعد البيع، تخصص',
          'Example: experience, price, quality, materials, speed, warranty, after-sales service, specialization.',
        ),
      ),
      _StartQuestion(
        key: 'brandTraits',
        type: _QuestionType.multiselect,
        required: true,
        maxSelections: 3,
        label: _LangText(
          'اختار 3 صفات لازم تظهر في البراند',
          'Choose up to 3 traits that must appear in the brand',
        ),
        options: [
          _StartOption('luxury', _LangText('فاخر', 'Luxury')),
          _StartOption('modern', _LangText('مودرن', 'Modern')),
          _StartOption('simple', _LangText('بسيط', 'Simple')),
          _StartOption('bold', _LangText('جريء', 'Bold')),
          _StartOption('formal', _LangText('رسمي', 'Formal')),
          _StartOption('youthful', _LangText('شبابي', 'Youthful')),
          _StartOption('calm', _LangText('هادئ', 'Calm')),
          _StartOption('technical', _LangText('تقني', 'Technical')),
          _StartOption('trusted', _LangText('موثوق', 'Trusted')),
          _StartOption('creative', _LangText('إبداعي', 'Creative')),
          _StartOption('practical', _LangText('عملي', 'Practical')),
          _StartOption('friendly', _LangText('ودود', 'Friendly')),
        ],
      ),
      _StartQuestion(
        key: 'keepFromCurrentIdentity',
        type: _QuestionType.multiselect,
        label: _LangText(
          'إيه الحاجات اللي لازم نحتفظ بيها من الهوية الحالية؟',
          'What should we keep from the current identity?',
        ),
        options: [
          _StartOption('brand-name', _LangText('اسم البراند', 'Brand name')),
          _StartOption('symbol', _LangText('رمز أو أيقونة', 'Symbol or icon')),
          _StartOption(
              'tagline', _LangText('الشعار التسويقي', 'Marketing tagline')),
          _StartOption(
              'nothing',
              _LangText('لا نريد الاحتفاظ بأي شيء',
                  'We do not want to keep anything')),
          _StartOption('other', _LangText('أخرى', 'Other')),
        ],
      ),
      _StartQuestion(
        key: 'directCompetitors',
        type: _QuestionType.text,
        label: _LangText(
          'رابط المنافس الأول (اختياري)',
          'First competitor link (optional)',
        ),
        placeholder: _LangText('https://example.com', 'https://example.com'),
      ),
      _StartQuestion(
        key: 'directCompetitor2',
        type: _QuestionType.text,
        label: _LangText(
          'رابط المنافس الثاني (اختياري)',
          'Second competitor link (optional)',
        ),
        placeholder: _LangText('https://example.com', 'https://example.com'),
      ),
      _StartQuestion(
        key: 'directCompetitor3',
        type: _QuestionType.text,
        label: _LangText(
          'رابط المنافس الثالث (اختياري)',
          'Third competitor link (optional)',
        ),
        placeholder: _LangText('https://example.com', 'https://example.com'),
      ),
      _StartQuestion(
        key: 'avoidIdeas',
        type: _QuestionType.textarea,
        rows: 3,
        label: _LangText(
          'إيه الألوان أو الرموز أو الأفكار اللي لا تريد استخدامها؟',
          'What colors, symbols, or ideas should we avoid?',
        ),
        placeholder: _LangText(
          'اختياري - اكتب أي ممنوعات أو اتجاهات لا تناسب البراند',
          'Optional - add anything to avoid or directions that do not suit the brand.',
        ),
      ),
      _StartQuestion(
        key: 'identityUsage',
        type: _QuestionType.multiselect,
        required: true,
        label: _LangText(
          'أين ستستخدم الهوية الجديدة؟',
          'Where will the new identity be used?',
        ),
        options: [
          _StartOption('social', _LangText('سوشيال ميديا', 'Social media')),
          _StartOption('website', _LangText('موقع إلكتروني', 'Website')),
          _StartOption('packaging', _LangText('تغليف', 'Packaging')),
          _StartOption('prints', _LangText('مطبوعات', 'Prints')),
          _StartOption('signage', _LangText('لافتة', 'Signage')),
          _StartOption(
              'business-cards', _LangText('كروت شخصية', 'Business cards')),
          _StartOption('uniform', _LangText('يونيفورم', 'Uniform')),
          _StartOption('app', _LangText('تطبيق', 'App')),
        ],
      ),
      _StartQuestion(
        key: 'finalNotes',
        type: _QuestionType.textarea,
        rows: 3,
        label: _LangText(
          'أي ملاحظة مهمة لازم نعرفها قبل البدء؟',
          'Any important note before we start?',
        ),
        placeholder: _LangText(
          'اختياري - اكتب أي تفاصيل مهمة قبل بدء الشغل',
          'Optional - add any important details before we start.',
        ),
      ),
    ],
  ),
];

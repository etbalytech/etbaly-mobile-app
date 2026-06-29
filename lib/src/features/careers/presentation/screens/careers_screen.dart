import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const _submitUrl = 'https://etba3ly-dm.com/api-careers/submit-application.php';

// ─── Data models ─────────────────────────────────────────────────────────────

class _Job {
  const _Job({
    required this.title,
    required this.type,
    required this.experience,
    required this.icon,
    required this.color,
    required this.fullAr,
    required this.fullEn,
    required this.responsibilitiesAr,
    required this.responsibilitiesEn,
    required this.requirementsAr,
    required this.requirementsEn,
    required this.skillsAr,
    required this.skillsEn,
  });

  final String title;
  final String type;
  final String experience;
  final IconData icon;
  final Color color;
  final String fullAr;
  final String fullEn;
  final List<String> responsibilitiesAr;
  final List<String> responsibilitiesEn;
  final List<String> requirementsAr;
  final List<String> requirementsEn;
  final List<String> skillsAr;
  final List<String> skillsEn;
}

const _jobs = <_Job>[
  _Job(
    title: 'CEO',
    type: 'دوام كامل',
    experience: 'أكثر من خمس سنين',
    icon: Icons.manage_accounts_rounded,
    color: Color(0xFF6F3FF5),
    fullAr: 'قدّم على دور قيادي يركز على وضع الاستراتيجية، توجيه الفريق، متابعة التشغيل، ودفع نمو الشركة.',
    fullEn: 'Apply for a leadership role focused on strategy, team direction, operations, and business growth.',
    responsibilitiesAr: ['قيادة الفريق وتوجيهه', 'وضع الخطط الاستراتيجية', 'متابعة الأداء والنمو'],
    responsibilitiesEn: ['Team leadership', 'Strategic planning', 'Performance tracking'],
    requirementsAr: ['قدرة عالية على تحمل المسؤولية', 'خبرة في الإدارة وقيادة الفرق'],
    requirementsEn: ['Strong ownership mindset', 'Management experience'],
    skillsAr: ['قيادة', 'استراتيجية', 'تواصل'],
    skillsEn: ['Leadership', 'Strategy', 'Communication'],
  ),
  _Job(
    title: 'Account Manager',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.handshake_rounded,
    color: Color(0xFF22C55E),
    fullAr: 'قدّم على وظيفة إدارة حسابات تركز على التواصل مع العملاء، متابعة الحملات، وضمان تسليم العمل بسلاسة.',
    fullEn: 'Apply for an account management role focused on client communication, campaign follow-up, and smooth delivery.',
    responsibilitiesAr: ['التواصل المستمر مع العملاء', 'متابعة حسابات العملاء', 'تنسيق تنفيذ الحملات'],
    responsibilitiesEn: ['Client communication', 'Account follow-up', 'Campaign coordination'],
    requirementsAr: ['مهارات تواصل قوية', 'قدرة على التنظيم والمتابعة الدقيقة'],
    requirementsEn: ['Good communication skills', 'Organized follow-up mindset'],
    skillsAr: ['إدارة حسابات', 'تواصل', 'متابعة'],
    skillsEn: ['Account management', 'Communication', 'Follow-up'],
  ),
  _Job(
    title: 'Web Developer',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.code_rounded,
    color: Color(0xFF0EA5E9),
    fullAr: 'قدّم على وظيفة تطوير ويب تركز على بناء مواقع متجاوبة، تحسين الأداء، وكتابة كود منظم وسهل الصيانة.',
    fullEn: 'Apply for a web development role focused on responsive websites, performance, and maintainable code.',
    responsibilitiesAr: ['تطوير صفحات ومواقع ويب', 'تنفيذ واجهات أمامية متجاوبة', 'تحسين الأداء'],
    responsibilitiesEn: ['Website development', 'Frontend implementation', 'Performance optimization'],
    requirementsAr: ['معرفة جيدة بـ HTML وCSS وJavaScript', 'خبرة في التصميم المتجاوب'],
    requirementsEn: ['HTML, CSS, JavaScript knowledge', 'Responsive design experience'],
    skillsAr: ['HTML', 'CSS', 'JavaScript'],
    skillsEn: ['HTML', 'CSS', 'JavaScript'],
  ),
  _Job(
    title: 'Mobile App Developer',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.phone_android_rounded,
    color: Color(0xFFF59E0B),
    fullAr: 'قدّم على وظيفة تطوير تطبيقات موبايل تركز على واجهات واضحة، خصائص مستقرة، وتجربة استخدام سلسة.',
    fullEn: 'Apply for a mobile app role focused on clean app interfaces, stable features, and smooth user flows.',
    responsibilitiesAr: ['تطوير تطبيقات موبايل', 'تنفيذ واجهات المستخدم', 'إصلاح الأخطاء وتحسين التجربة'],
    responsibilitiesEn: ['Mobile development', 'UI implementation', 'Bug fixing'],
    requirementsAr: ['خبرة في تطوير تطبيقات الموبايل', 'قدرة جيدة على حل المشاكل'],
    requirementsEn: ['Mobile app development experience', 'Good problem solving'],
    skillsAr: ['تطبيقات موبايل', 'واجهات مستخدم', 'APIs'],
    skillsEn: ['Mobile apps', 'UI', 'APIs'],
  ),
  _Job(
    title: 'Graphic Designer',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.brush_rounded,
    color: Color(0xFFEC4899),
    fullAr: 'قدّم على وظيفة تصميم جرافيك تركز على تصميمات السوشيال ميديا، عناصر الهوية البصرية، ومواد الحملات الإعلانية.',
    fullEn: 'Apply for a graphic design role focused on social media visuals, brand assets, and campaign creatives.',
    responsibilitiesAr: ['تصميم منشورات السوشيال ميديا', 'إعداد عناصر بصرية للبراند', 'تصميم مواد الحملات'],
    responsibilitiesEn: ['Social media designs', 'Brand visuals', 'Campaign creatives'],
    requirementsAr: ['وجود بورتفوليو سابق', 'إجادة أدوات التصميم من Adobe'],
    requirementsEn: ['Design portfolio', 'Adobe design tools knowledge'],
    skillsAr: ['Photoshop', 'Illustrator', 'هوية بصرية'],
    skillsEn: ['Photoshop', 'Illustrator', 'Branding'],
  ),
  _Job(
    title: 'Video Editor',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.videocam_rounded,
    color: Color(0xFFEF4444),
    fullAr: 'قدّم على وظيفة مونتاج فيديو تركز على الريلز، الإعلانات، فيديوهات السوشيال ميديا، وسرد بصري واضح.',
    fullEn: 'Apply for a video editing role focused on reels, ads, social videos, and clean storytelling.',
    responsibilitiesAr: ['مونتاج الفيديوهات', 'إنتاج الريلز والمقاطع القصيرة', 'ضبط الإيقاع والحركة'],
    responsibilitiesEn: ['Video editing', 'Reels production', 'Motion pacing'],
    requirementsAr: ['وجود أعمال مونتاج سابقة', 'إجادة برامج المونتاج'],
    requirementsEn: ['Editing portfolio', 'Video editing tools knowledge'],
    skillsAr: ['Premiere', 'After Effects', 'سرد بصري'],
    skillsEn: ['Premiere', 'After Effects', 'Storytelling'],
  ),
  _Job(
    title: 'Designer & Video Editor',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.photo_camera_rounded,
    color: Color(0xFFD946EF),
    fullAr: 'قدّم على وظيفة إبداعية تجمع بين تصميم الجرافيك، مونتاج الفيديو، وتجهيز محتوى السوشيال ميديا.',
    fullEn: 'Apply for a hybrid creative role covering graphic design, video editing, and social media content.',
    responsibilitiesAr: ['تصميم المواد البصرية', 'مونتاج الفيديوهات', 'تجهيز محتوى الحملات'],
    responsibilitiesEn: ['Design assets', 'Edit videos', 'Prepare campaign visuals'],
    requirementsAr: ['بورتفوليو تصميم ومونتاج', 'خبرة في أدوات Adobe'],
    requirementsEn: ['Design and editing portfolio', 'Adobe tools experience'],
    skillsAr: ['تصميم', 'مونتاج فيديو', 'سوشيال ميديا'],
    skillsEn: ['Design', 'Video editing', 'Social media'],
  ),
  _Job(
    title: 'Sales & Moderator',
    type: 'دوام كامل',
    experience: 'أقل من سنة',
    icon: Icons.chat_rounded,
    color: Color(0xFF14B8A6),
    fullAr: 'قدّم على وظيفة تركز على محادثات البيع، متابعة العملاء، وإدارة التعليقات والرسائل على السوشيال ميديا.',
    fullEn: 'Apply for a role focused on sales conversations, customer follow-up, and social media moderation.',
    responsibilitiesAr: ['الرد على العملاء', 'متابعة فرص البيع', 'إدارة التعليقات والرسائل'],
    responsibilitiesEn: ['Reply to customers', 'Follow sales leads', 'Moderate comments and messages'],
    requirementsAr: ['مهارات تواصل جيدة', 'سرعة في الرد والمتابعة'],
    requirementsEn: ['Good communication', 'Fast response and follow-up'],
    skillsAr: ['مبيعات', 'مودريشن', 'خدمة عملاء'],
    skillsEn: ['Sales', 'Moderation', 'Customer care'],
  ),
  _Job(
    title: 'Social Media Specialist',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.tag_rounded,
    color: Color(0xFF06B6D4),
    fullAr: 'قدّم على وظيفة سوشيال ميديا تركز على تخطيط المحتوى، النشر، التقارير، وتحسين نمو الحسابات.',
    fullEn: 'Apply for a social media role focused on content planning, publishing, reporting, and account growth.',
    responsibilitiesAr: ['تخطيط المحتوى', 'تنظيم النشر', 'إعداد التقارير ومتابعة الأداء'],
    responsibilitiesEn: ['Content planning', 'Publishing', 'Reports & analytics'],
    requirementsAr: ['معرفة جيدة بمنصات السوشيال ميديا', 'حس قوي في صناعة المحتوى'],
    requirementsEn: ['Social media knowledge', 'Content sense'],
    skillsAr: ['محتوى', 'تخطيط', 'تحليل أداء'],
    skillsEn: ['Content', 'Planning', 'Analytics'],
  ),
  _Job(
    title: 'Operations Specialist',
    type: 'دوام كامل',
    experience: 'سنة',
    icon: Icons.settings_rounded,
    color: Color(0xFF64748B),
    fullAr: 'قدّم على وظيفة عمليات تركز على التنسيق، متابعة الإجراءات، دعم التنفيذ، وضمان انتظام سير العمل.',
    fullEn: 'Apply for an operations role focused on coordination, process follow-up, and daily execution.',
    responsibilitiesAr: ['تنسيق سير العمل', 'متابعة المهام اليومية', 'دعم التنفيذ بين الفرق'],
    responsibilitiesEn: ['Workflow coordination', 'Task follow-up', 'Execution support'],
    requirementsAr: ['مهارات تنظيم عالية', 'قدرة قوية على المتابعة والتوثيق'],
    requirementsEn: ['Organization skills', 'Good follow-up'],
    skillsAr: ['عمليات', 'تنسيق', 'تقارير'],
    skillsEn: ['Operations', 'Coordination', 'Reporting'],
  ),
];

class _ExpOption {
  const _ExpOption(this.value, this.ar, this.en);
  final String value;
  final String ar;
  final String en;
}

const _expOptions = <_ExpOption>[
  _ExpOption('less_than_year', 'أقل من سنة', 'Less than a year'),
  _ExpOption('one_year', 'سنة واحدة', 'One year'),
  _ExpOption('two_years', 'سنتان', 'Two years'),
  _ExpOption('three_years', 'ثلاث سنوات', 'Three years'),
  _ExpOption('four_years', 'أربع سنوات', 'Four years'),
  _ExpOption('five_years', 'خمس سنوات', 'Five years'),
  _ExpOption('more_than_five', 'أكثر من خمس سنوات', 'More than five years'),
];

class _Area {
  const _Area(this.value, this.ar, this.en);
  final String value;
  final String ar;
  final String en;
}

const _alexandriaAreas = <_Area>[
  _Area('abu_qir', 'أبو قير', 'Abu Qir'),
  _Area('agami', 'العجمي', 'Agami'),
  _Area('amreya', 'العامرية', 'Amreya'),
  _Area('anfoushi', 'الأنفوشي', 'Anfoushi'),
  _Area('asafra', 'العصافرة', 'Asafra'),
  _Area('attarin', 'العطارين', 'Attarin'),
  _Area('azareeta', 'الأزاريطة', 'Azarita'),
  _Area('bacchus', 'باكوس', 'Bacchus'),
  _Area('bahary', 'بحري', 'Bahary'),
  _Area('borg_el_arab', 'برج العرب', 'Borg El Arab'),
  _Area('camp_caesar', 'كامب شيزار', 'Camp Caesar'),
  _Area('cleopatra', 'كليوباترا', 'Cleopatra'),
  _Area('dekheila', 'الدخيلة', 'Dekheila'),
  _Area('downtown', 'وسط البلد', 'Downtown Alexandria'),
  _Area('fleming', 'فلمنج', 'Fleming'),
  _Area('gleem', 'جليم', 'Gleem'),
  _Area('gomrok', 'الجمرك', 'Gomrok'),
  _Area('hadara', 'الحضرة', 'Hadara'),
  _Area('ibrahimeya', 'الإبراهيمية', 'Ibrahimeya'),
  _Area('kafr_abdo', 'كفر عبده', 'Kafr Abdo'),
  _Area('karmouz', 'كرموز', 'Karmouz'),
  _Area('labban', 'اللبان', 'Labban'),
  _Area('louran', 'لوران', 'Louran'),
  _Area('maamoura', 'المعمورة', 'Maamoura'),
  _Area('mandara', 'المندرة', 'Mandara'),
  _Area('mansheya', 'المنشية', 'Mansheya'),
  _Area('mahatet_el_raml', 'محطة الرمل', 'Raml Station'),
  _Area('max', 'المكس', 'El Max'),
  _Area('miami', 'ميامي', 'Miami'),
  _Area('moharam_bek', 'محرم بك', 'Moharam Bek'),
  _Area('montaza', 'المنتزه', 'Montaza'),
  _Area('nakheel', 'النخيل', 'Nakheel'),
  _Area('ras_el_tin', 'رأس التين', 'Ras El Tin'),
  _Area('roshdy', 'رشدي', 'Roushdy'),
  _Area('saba_pasha', 'سابا باشا', 'Saba Pasha'),
  _Area('san_stefano', 'سان ستيفانو', 'San Stefano'),
  _Area('seyouf', 'السيوف', 'Seyouf'),
  _Area('shatby', 'الشاطبي', 'Shatby'),
  _Area('sidi_beshr', 'سيدي بشر', 'Sidi Beshr'),
  _Area('sidi_gaber', 'سيدي جابر', 'Sidi Gaber'),
  _Area('smouha', 'سموحة', 'Smouha'),
  _Area('sporting', 'سبورتنج', 'Sporting'),
  _Area('stanley', 'ستانلي', 'Stanley'),
  _Area('victoria', 'فيكتوريا', 'Victoria'),
  _Area('wardian', 'الورديان', 'Wardian'),
  _Area('zizinia', 'زيزينيا', 'Zizinia'),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key});

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  final _scrollController = ScrollController();

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _achievementsCtrl = TextEditingController();
  final _coverCtrl = TextEditingController();

  _Job _selectedJob = _jobs.first;
  String _experienceLevel = 'less_than_year';
  String _address = '';
  String _englishLevel = 'pass';
  String _computerSkill = 'pass';
  String _cameraAvailable = 'pass';
  String _videoEditing = 'pass';
  String _ugc = 'pass';
  String _workUnderPressure = 'no';
  String _availability = 'full_time';

  Uint8List? _photoBytes;
  String _photoName = '';
  PlatformFile? _cvFile;

  bool _submitting = false;
  bool _sent = false;
  String _submitError = '';

  bool _nameError = false;
  bool _emailError = false;
  bool _waError = false;
  bool _ageError = false;
  bool _addressError = false;
  bool _educationError = false;
  bool _coverError = false;
  bool _photoError = false;

  bool get _isAr => context.locale.languageCode == 'ar';

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _educationCtrl.dispose();
    _emailCtrl.dispose();
    _whatsappCtrl.dispose();
    _skillsCtrl.dispose();
    _experienceCtrl.dispose();
    _achievementsCtrl.dispose();
    _coverCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _photoBytes = bytes;
      _photoName = picked.name;
      _photoError = false;
    });
  }

  Future<void> _pickCv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) return;
    setState(() => _cvFile = file);
  }

  bool _validate() {
    final age = int.tryParse(_ageCtrl.text.trim()) ?? -1;
    setState(() {
      _nameError = _nameCtrl.text.trim().length < 2;
      _emailError = !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_emailCtrl.text.trim());
      _waError = _whatsappCtrl.text.trim().length < 7;
      _ageError = age < 16 || age > 80;
      _addressError = _address.isEmpty;
      _educationError = _educationCtrl.text.trim().length < 2;
      _coverError = _coverCtrl.text.trim().length < 20;
      _photoError = _photoBytes == null;
    });
    return !_nameError && !_emailError && !_waError && !_ageError && !_addressError && !_educationError && !_coverError && !_photoError;
  }

  Future<void> _submit() async {
    if (!_validate() || _submitting) return;

    final area = _alexandriaAreas.firstWhere(
      (a) => a.value == _address,
      orElse: () => const _Area('', '', ''),
    );

    setState(() {
      _submitting = true;
      _submitError = '';
    });

    try {
      final formData = FormData.fromMap({
        'job_title': _selectedJob.title,
        'name': _nameCtrl.text.trim(),
        'age': _ageCtrl.text.trim(),
        'address': 'الإسكندرية - ${area.ar} / Alexandria - ${area.en}',
        'education': _educationCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'whatsapp': _whatsappCtrl.text.trim(),
        'english_level': _englishLevel,
        'computer_skill': _computerSkill,
        'camera_available': _cameraAvailable,
        'video_editing': _videoEditing,
        'ugc': _ugc,
        'work_under_pressure': _workUnderPressure,
        'experience_level': _experienceLevel,
        'applicant_skills': _skillsCtrl.text.trim(),
        'applicant_experience': _experienceCtrl.text.trim(),
        'achievements': _achievementsCtrl.text.trim(),
        'availability': _availability,
        'cover': _coverCtrl.text.trim(),
        if (_photoBytes != null)
          'photo': MultipartFile.fromBytes(_photoBytes!, filename: _photoName),
        if (_cvFile?.bytes != null)
          'cv': MultipartFile.fromBytes(_cvFile!.bytes!, filename: _cvFile!.name),
      });

      final response = await Dio().post<dynamic>(
        _submitUrl,
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          validateStatus: (s) => s != null && s < 500,
        ),
      );

      final body = response.data;
      if (!(body is Map && body['success'] == true)) {
        final msg = body is Map ? (body['error'] ?? '') : '';
        throw Exception(msg.toString().isNotEmpty ? msg : 'failed');
      }

      if (!mounted) return;
      setState(() {
        _submitting = false;
        _sent = true;
      });
      _scrollController.jumpTo(0);
    } on DioException {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError = _isAr ? 'تأكد من الاتصال بالإنترنت وحاول مجدداً' : 'Check your internet and try again';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError = _isAr ? 'حدث خطأ أثناء الإرسال، حاول مجدداً' : 'Something went wrong, please try again';
      });
    }
  }

  void _reset() {
    for (final c in [_nameCtrl, _ageCtrl, _educationCtrl, _emailCtrl, _whatsappCtrl, _skillsCtrl, _experienceCtrl, _achievementsCtrl, _coverCtrl]) {
      c.clear();
    }
    setState(() {
      _selectedJob = _jobs.first;
      _experienceLevel = 'less_than_year';
      _address = '';
      _englishLevel = 'pass';
      _computerSkill = 'pass';
      _cameraAvailable = 'pass';
      _videoEditing = 'pass';
      _ugc = 'pass';
      _workUnderPressure = 'no';
      _availability = 'full_time';
      _photoBytes = null;
      _photoName = '';
      _cvFile = null;
      _sent = false;
      _submitError = '';
      _nameError = _emailError = _waError = _ageError = _addressError = _educationError = _coverError = _photoError = false;
    });
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = _isAr;
    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.etbalyColors.bgMain,
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero
              SliverToBoxAdapter(child: _CareersHero(isArabic: isAr)),
              // Job selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: _JobSelector(
                    jobs: _jobs,
                    selected: _selectedJob,
                    isArabic: isAr,
                    onSelect: (j) => setState(() => _selectedJob = j),
                  ),
                ),
              ),
              // Body: job detail + form
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 40.h),
                sliver: SliverToBoxAdapter(
                  child: _sent
                      ? _SuccessCard(name: _nameCtrl.text, isArabic: isAr, onReset: _reset)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            // Two-column on tablet (>= 600)
                            if (constraints.maxWidth >= 600) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.42,
                                    child: _JobDetailCard(job: _selectedJob, isArabic: isAr),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(child: _buildForm(isAr)),
                                ],
                              );
                            }
                            // Single column on phone
                            return Column(
                              children: [
                                _JobDetailCard(job: _selectedJob, isArabic: isAr),
                                SizedBox(height: 16.h),
                                _buildForm(isAr),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isAr) {
    final c = context.etbalyColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: c.borderColor),
        boxShadow: [BoxShadow(color: c.cardShadow, blurRadius: 24.r, offset: Offset(0, 8.h))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header
          _FormHeader(isArabic: isAr),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Job + Experience
                _TwoCol(
                  left: _Label(
                    text: isAr ? 'الوظيفة المتقدم إليها' : 'Position',
                    required: true,
                    child: _Dropdown<_Job>(
                      value: _selectedJob,
                      items: _jobs
                          .map((j) => DropdownMenuItem(
                              value: j,
                              child: Row(children: [
                                Icon(j.icon, color: j.color, size: 15.sp),
                                SizedBox(width: 6.w),
                                Expanded(child: Text(j.title, overflow: TextOverflow.ellipsis)),
                              ])))
                          .toList(),
                      onChanged: (j) { if (j != null) setState(() => _selectedJob = j); },
                    ),
                  ),
                  right: _Label(
                    text: isAr ? 'سنوات الخبرة' : 'Experience',
                    required: true,
                    child: _Dropdown<String>(
                      value: _experienceLevel,
                      items: _expOptions
                          .map((e) => DropdownMenuItem(value: e.value, child: Text(isAr ? e.ar : e.en)))
                          .toList(),
                      onChanged: (v) { if (v != null) setState(() => _experienceLevel = v); },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Personal Photo
                _PhotoSection(
                  bytes: _photoBytes,
                  name: _photoName,
                  hasError: _photoError,
                  isArabic: isAr,
                  onPick: _pickPhoto,
                  onRemove: () => setState(() { _photoBytes = null; _photoName = ''; }),
                ),
                SizedBox(height: 16.h),

                // Full name
                _Label(
                  text: isAr ? 'الاسم الكامل' : 'Full name',
                  required: true,
                  hasError: _nameError,
                  errorText: isAr ? 'أدخل اسمك (حرفان على الأقل)' : 'Enter your name (min 2 chars)',
                  child: _Field(
                    controller: _nameCtrl,
                    hint: isAr ? 'مثال: محمد علي' : 'Example: Mohamed Ali',
                    icon: Icons.person_outline_rounded,
                    hasError: _nameError,
                    onChanged: (_) { if (_nameError) setState(() => _nameError = false); },
                  ),
                ),
                SizedBox(height: 12.h),

                // Age + Education
                _TwoCol(
                  left: _Label(
                    text: isAr ? 'السن' : 'Age',
                    required: true,
                    hasError: _ageError,
                    child: _Field(
                      controller: _ageCtrl,
                      hint: isAr ? 'مثال: 24' : 'e.g. 24',
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                      hasError: _ageError,
                      onChanged: (_) { if (_ageError) setState(() => _ageError = false); },
                    ),
                  ),
                  right: _Label(
                    text: isAr ? 'التعليم' : 'Education',
                    required: true,
                    hasError: _educationError,
                    child: _Field(
                      controller: _educationCtrl,
                      hint: isAr ? 'بكالوريوس تجارة' : 'B.Sc. Commerce',
                      icon: Icons.school_outlined,
                      hasError: _educationError,
                      onChanged: (_) { if (_educationError) setState(() => _educationError = false); },
                    ),
                  ),
                ),
                if (_ageError || _educationError) ...[
                  SizedBox(height: 4.h),
                  _ErrorNote(isAr ? 'السن يجب أن يكون بين 16 و80' : 'Age must be between 16 and 80'),
                ],
                SizedBox(height: 12.h),

                // Governorate (readonly) + Area
                _TwoCol(
                  left: _Label(
                    text: isAr ? 'المحافظة' : 'Governorate',
                    child: _Field(
                      controller: TextEditingController(text: isAr ? 'الإسكندرية' : 'Alexandria'),
                      hint: '',
                      icon: Icons.location_city_outlined,
                      readOnly: true,
                    ),
                  ),
                  right: _Label(
                    text: isAr ? 'منطقة السكن داخل الإسكندرية' : 'Area in Alexandria',
                    required: true,
                    hasError: _addressError,
                    child: _Dropdown<String>(
                      value: _address.isEmpty ? null : _address,
                      hint: isAr ? 'اختر منطقتك' : 'Select area',
                      hasError: _addressError,
                      items: _alexandriaAreas
                          .map((a) => DropdownMenuItem(value: a.value, child: Text(isAr ? a.ar : a.en)))
                          .toList(),
                      onChanged: (v) => setState(() { _address = v ?? ''; _addressError = false; }),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Company location info card
                _InfoCard(
                  icon: Icons.location_on_rounded,
                  color: const Color(0xFF6F3FF5),
                  title: isAr ? 'مقر الشركة' : 'Company location',
                  body: isAr ? 'العجمي، أبو يوسف، محافظة الإسكندرية، مصر' : 'El-Agami, Abu Youssef, Alexandria, Egypt',
                ),
                SizedBox(height: 8.h),

                // Office hours info card
                _InfoCard(
                  icon: Icons.access_time_rounded,
                  color: const Color(0xFFD4AF37),
                  title: isAr ? 'ساعات العمل المكتبية' : 'Office hours',
                  body: isAr ? 'من السبت إلى الخميس  |  10 ص – 10 م  |  الجمعة إجازة' : 'Sat – Thu  |  10 AM – 10 PM  |  Friday off',
                ),
                SizedBox(height: 16.h),

                // Email
                _Label(
                  text: isAr ? 'البريد الإلكتروني' : 'Email',
                  required: true,
                  hasError: _emailError,
                  errorText: isAr ? 'البريد غير صحيح' : 'Invalid email',
                  child: _Field(
                    controller: _emailCtrl,
                    hint: 'email@example.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    hasError: _emailError,
                    onChanged: (_) { if (_emailError) setState(() => _emailError = false); },
                  ),
                ),
                SizedBox(height: 12.h),

                // WhatsApp
                _Label(
                  text: 'واتساب',
                  required: true,
                  hasError: _waError,
                  errorText: isAr ? 'رقم الواتساب غير صحيح' : 'Invalid WhatsApp number',
                  child: _Field(
                    controller: _whatsappCtrl,
                    hint: '01xxxxxxxxx',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    hasError: _waError,
                    onChanged: (_) { if (_waError) setState(() => _waError = false); },
                  ),
                ),
                SizedBox(height: 20.h),

                // Qualifications header
                _SectionHeader(
                  icon: Icons.tune_rounded,
                  text: isAr ? 'بيانات المهارات والتوفر' : 'Skills & Availability',
                ),
                SizedBox(height: 12.h),

                _TwoCol(
                  left: _Label(
                    text: isAr ? 'اللغة الإنجليزية' : 'English level',
                    child: _Dropdown<String>(
                      value: _englishLevel,
                      items: _qualItems(isAr),
                      onChanged: (v) { if (v != null) setState(() => _englishLevel = v); },
                    ),
                  ),
                  right: _Label(
                    text: 'Computer',
                    child: _Dropdown<String>(
                      value: _computerSkill,
                      items: _qualItems(isAr),
                      onChanged: (v) { if (v != null) setState(() => _computerSkill = v); },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _TwoCol(
                  left: _Label(
                    text: 'Camera',
                    child: _Dropdown<String>(
                      value: _cameraAvailable,
                      items: _qualItems(isAr),
                      onChanged: (v) { if (v != null) setState(() => _cameraAvailable = v); },
                    ),
                  ),
                  right: _Label(
                    text: 'Video editing',
                    child: _Dropdown<String>(
                      value: _videoEditing,
                      items: _qualItems(isAr),
                      onChanged: (v) { if (v != null) setState(() => _videoEditing = v); },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _TwoCol(
                  left: _Label(
                    text: 'UGC',
                    child: _Dropdown<String>(
                      value: _ugc,
                      items: _qualItems(isAr),
                      onChanged: (v) { if (v != null) setState(() => _ugc = v); },
                    ),
                  ),
                  right: _Label(
                    text: 'Work under pressure',
                    child: _Dropdown<String>(
                      value: _workUnderPressure,
                      items: [
                        DropdownMenuItem(value: 'yes', child: Text(isAr ? 'نعم' : 'Yes')),
                        DropdownMenuItem(value: 'no', child: Text(isAr ? 'لا' : 'No')),
                      ],
                      onChanged: (v) { if (v != null) setState(() => _workUnderPressure = v); },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _Label(
                  text: isAr ? 'متاح للعمل' : 'Availability',
                  required: true,
                  child: _Dropdown<String>(
                    value: _availability,
                    items: [
                      DropdownMenuItem(value: 'full_time', child: Text(isAr ? 'دوام كامل' : 'Full time')),
                      DropdownMenuItem(value: 'part_time', child: Text(isAr ? 'دوام جزئي' : 'Part time')),
                    ],
                    onChanged: (v) { if (v != null) setState(() => _availability = v); },
                  ),
                ),
                SizedBox(height: 20.h),

                // Open fields
                _Label(
                  text: isAr ? 'Skills' : 'Skills',
                  child: _Field(
                    controller: _skillsCtrl,
                    hint: isAr ? 'اكتب أهم مهاراتك العملية والتقنية' : 'List your key technical and professional skills',
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 12.h),
                _Label(
                  text: 'Experience',
                  child: _Field(
                    controller: _experienceCtrl,
                    hint: isAr ? 'اكتب خبراتك السابقة باختصار' : 'Briefly describe your previous experience',
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 12.h),
                _Label(
                  text: 'Achievements',
                  child: _Field(
                    controller: _achievementsCtrl,
                    hint: isAr ? 'اكتب أهم إنجازاتك أو أعمالك السابقة' : 'Describe your key achievements or past work',
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 12.h),
                _Label(
                  text: isAr ? 'رسالة التعريف' : 'Cover letter',
                  required: true,
                  hasError: _coverError,
                  errorText: isAr ? 'الرسالة قصيرة جداً (20 حرفاً على الأقل)' : 'Too short (min 20 chars)',
                  child: _Field(
                    controller: _coverCtrl,
                    hint: isAr
                        ? 'اكتب باختصار عن نفسك، خبراتك، وسبب اهتمامك بهذه الوظيفة...'
                        : 'Tell us about yourself, your experience, and why you are interested...',
                    maxLines: 5,
                    hasError: _coverError,
                    onChanged: (_) { if (_coverError) setState(() => _coverError = false); },
                  ),
                ),
                SizedBox(height: 16.h),

                // CV upload
                _CvSection(
                  file: _cvFile,
                  isArabic: isAr,
                  onPick: _pickCv,
                  onRemove: () => setState(() => _cvFile = null),
                ),
                SizedBox(height: 24.h),

                // Submit
                _GoldButton(
                  label: isAr ? 'إرسال الطلب' : 'Submit application',
                  submitting: _submitting,
                  isArabic: isAr,
                  onTap: _submit,
                ),
                if (_submitError.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  _ErrorNote(_submitError),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _qualItems(bool ar) => [
        DropdownMenuItem(value: 'no', child: Text(ar ? 'لا' : 'No')),
        DropdownMenuItem(value: 'pass', child: Text(ar ? 'مقبول' : 'Average')),
        DropdownMenuItem(value: 'good', child: Text(ar ? 'جيد' : 'Good')),
        DropdownMenuItem(value: 'excellent', child: Text(ar ? 'ممتاز' : 'Excellent')),
      ];
}

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _CareersHero extends StatelessWidget {
  const _CareersHero({required this.isArabic});
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return ClipRect(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 52.h, 20.w, 48.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0a0914), const Color(0xFF0f0e18)]
                : [const Color(0xFFF5F2FF), const Color(0xFFEDE7FF)],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Decorative glow orbs
            Positioned(
              top: -60.h, right: -60.w,
              child: _GlowOrb(
                color: const Color(0xFF6F3FF5),
                size: 200.r,
                opacity: isDark ? 0.22 : 0.14,
              ),
            ),
            Positioned(
              bottom: -40.h, left: -40.w,
              child: _GlowOrb(
                color: const Color(0xFFD4AF37),
                size: 180.r,
                opacity: isDark ? 0.15 : 0.10,
              ),
            ),
            Positioned(
              top: 40.h, left: 30.w,
              child: _GlowOrb(
                color: const Color(0xFF6F3FF5),
                size: 80.r,
                opacity: isDark ? 0.12 : 0.08,
              ),
            ),
            // Dot grid
            Positioned.fill(child: CustomPaint(painter: _DotGridPainter(isDark: isDark))),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0x22D4AF37) : const Color(0x18D4AF37),
                    border: Border.all(
                      color: isDark ? const Color(0x66D4AF37) : const Color(0xAAD4AF37),
                    ),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.work_outline_rounded, color: const Color(0xFFD4AF37), size: 15.sp),
                      SizedBox(width: 6.w),
                      Text(
                        isArabic ? 'انضم لفريقنا' : 'Join our team',
                        style: TextStyle(
                          color: const Color(0xFFD4AF37),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Gold gradient title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFFBBF24), Color(0xFFD4AF37)],
                  ).createShader(bounds),
                  child: Text(
                    isArabic ? 'الوظائف المتاحة' : 'Available Positions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      height: 1.1,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  isArabic
                      ? 'نبحث عن أشخاص شغوفين بالتسويق الرقمي، التصميم، وصناعة التجارب التي تساعد العلامات التجارية تكبر بثقة.'
                      : 'We look for passionate people in digital marketing, design, and crafting experiences that help brands grow with confidence.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xAAEDE8FF)
                        : const Color(0xFF6B5A9E),
                    fontSize: 13.sp,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size, required this.opacity});
  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? const Color(0x14FFFFFF) : const Color(0x226F3FF5)
      ..strokeWidth = 1;
    const gap = 20.0;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter old) => old.isDark != isDark;
}

// ─── Job Selector ─────────────────────────────────────────────────────────────

class _JobSelector extends StatelessWidget {
  const _JobSelector({required this.jobs, required this.selected, required this.isArabic, required this.onSelect});
  final List<_Job> jobs;
  final _Job selected;
  final bool isArabic;
  final ValueChanged<_Job> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'اختر الوظيفة' : 'Select position',
          style: TextStyle(color: c.textMain, fontSize: 14.sp, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 44.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: jobs.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, i) {
              final job = jobs[i];
              final active = job == selected;
              return GestureDetector(
                onTap: () => onSelect(job),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: active ? job.color.withValues(alpha: 0.15) : c.bgCard,
                    border: Border.all(
                      color: active ? job.color.withValues(alpha: 0.7) : c.borderColor,
                      width: active ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: active
                        ? [BoxShadow(color: job.color.withValues(alpha: 0.18), blurRadius: 10.r)]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(job.icon, color: active ? job.color : c.textLight, size: 15.sp),
                      SizedBox(width: 6.w),
                      Text(
                        job.title,
                        style: TextStyle(
                          color: active ? job.color : c.textMuted,
                          fontSize: 12.sp,
                          fontWeight: active ? FontWeight.w900 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Job Detail Card ──────────────────────────────────────────────────────────

class _JobDetailCard extends StatelessWidget {
  const _JobDetailCard({required this.job, required this.isArabic});
  final _Job job;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final respAr = job.responsibilitiesAr;
    final respEn = job.responsibilitiesEn;
    final reqAr = job.requirementsAr;
    final reqEn = job.requirementsEn;
    final skills = isArabic ? job.skillsAr : job.skillsEn;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: job.color.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(color: job.color.withValues(alpha: 0.1), blurRadius: 28.r, offset: Offset(0, 8.h)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section (job icon + title)
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [job.color.withValues(alpha: 0.12), job.color.withValues(alpha: 0.04)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: job.color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: job.color.withValues(alpha: 0.3)),
                  ),
                  child: Icon(job.icon, color: job.color, size: 26.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(color: c.textMain, fontSize: 17.sp, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          _Chip(job.type, Icons.work_outline_rounded, job.color),
                          SizedBox(width: 6.w),
                          _Chip(job.experience, Icons.star_border_rounded, const Color(0xFFD4AF37)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full desc
                Text(
                  isArabic ? job.fullAr : job.fullEn,
                  style: TextStyle(color: c.textMuted, fontSize: 13.sp, height: 1.65),
                ),
                SizedBox(height: 16.h),

                // Responsibilities
                _DetailBlock(
                  icon: Icons.checklist_rounded,
                  title: isArabic ? 'المسؤوليات' : 'Responsibilities',
                  items: isArabic ? respAr : respEn,
                  color: job.color,
                ),
                SizedBox(height: 14.h),

                // Requirements
                _DetailBlock(
                  icon: Icons.star_border_rounded,
                  title: isArabic ? 'المتطلبات والخبرة' : 'Requirements',
                  items: isArabic ? reqAr : reqEn,
                  color: const Color(0xFFD4AF37),
                ),
                SizedBox(height: 14.h),

                // Skills
                Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: job.color, size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      isArabic ? 'المهارات المطلوبة' : 'Required skills',
                      style: TextStyle(color: c.textMain, fontSize: 13.sp, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: skills.map((s) => _SkillPill(s, job.color)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.icon, required this.title, required this.items, required this.color});
  final IconData icon;
  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 6.w),
          Text(title, style: TextStyle(color: c.textMain, fontSize: 13.sp, fontWeight: FontWeight.w900)),
        ]),
        SizedBox(height: 8.h),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(top: 5.h, right: 8.w, left: 8.w),
              child: Container(width: 5.w, height: 5.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            ),
            Expanded(child: Text(item, style: TextStyle(color: c.textMuted, fontSize: 12.sp, height: 1.55))),
          ]),
        )),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 11.sp),
        SizedBox(width: 4.w),
        Text(label, style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _SkillPill extends StatelessWidget {
  const _SkillPill(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.w800)),
    );
  }
}

// ─── Form Header ──────────────────────────────────────────────────────────────

class _FormHeader extends StatelessWidget {
  const _FormHeader({required this.isArabic});
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.primary.withValues(alpha: 0.12), c.primary.withValues(alpha: 0.04)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
        border: Border(bottom: BorderSide(color: c.borderColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.send_rounded, color: c.primary, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'تقديم طلب التوظيف' : 'Submit your application',
                  style: TextStyle(color: c.textMain, fontSize: 15.sp, fontWeight: FontWeight.w900),
                ),
                Text(
                  isArabic ? 'أرسل بياناتك وسيتواصل معك فريقنا خلال 48 ساعة' : 'Send your info and our team will reach out within 48 hours',
                  style: TextStyle(color: c.textMuted, fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Photo Section ────────────────────────────────────────────────────────────

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.bytes,
    required this.name,
    required this.hasError,
    required this.isArabic,
    required this.onPick,
    required this.onRemove,
  });
  final Uint8List? bytes;
  final String name;
  final bool hasError;
  final bool isArabic;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final ar = isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            ar ? 'الصورة الشخصية' : 'Personal photo',
            style: TextStyle(
              color: hasError ? const Color(0xFFEF4444) : c.textMain,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(' *', style: TextStyle(color: const Color(0xFFEF4444), fontSize: 13.sp, fontWeight: FontWeight.w900)),
        ]),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar circle
            GestureDetector(
              onTap: onPick,
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasError ? const Color(0x0CEF4444) : c.bgSubtle,
                  border: Border.all(
                    color: hasError ? const Color(0xFFEF4444) : c.primary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: bytes != null
                    ? Image.memory(bytes!, fit: BoxFit.cover)
                    : Icon(Icons.camera_alt_outlined, color: c.textLight, size: 26.sp),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ar ? 'صورة شخصية حديثة' : 'Recent personal photo',
                    style: TextStyle(color: c.textMain, fontSize: 12.sp, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    ar ? 'صورة واضحة للوجه • مربعة بنسبة 1:1 • PNG أو JPEG أو WEBP • بدون حد حجم داخل النموذج' : 'Clear face photo • 1:1 ratio • PNG, JPEG, or WEBP',
                    style: TextStyle(color: c.textLight, fontSize: 10.sp, height: 1.5),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(spacing: 6.w, children: [
                    _SmallBtn(
                      label: ar ? (bytes != null ? 'تغيير' : 'اضغط لرفع الصورة') : (bytes != null ? 'Change' : 'Upload'),
                      icon: bytes != null ? Icons.refresh_rounded : Icons.upload_rounded,
                      color: c.primary,
                      onTap: onPick,
                    ),
                    if (bytes != null)
                      _SmallBtn(
                        label: ar ? 'حذف' : 'Remove',
                        icon: Icons.delete_outline_rounded,
                        color: const Color(0xFFEF4444),
                        onTap: onRemove,
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
        if (hasError) ...[
          SizedBox(height: 5.h),
          _ErrorNote(ar ? 'الصورة الشخصية مطلوبة' : 'Personal photo is required'),
        ],
      ],
    );
  }
}

// ─── CV Section ───────────────────────────────────────────────────────────────

class _CvSection extends StatelessWidget {
  const _CvSection({required this.file, required this.isArabic, required this.onPick, required this.onRemove});
  final PlatformFile? file;
  final bool isArabic;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final ar = isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ar ? 'السيرة الذاتية (CV)' : 'CV / Resume',
          style: TextStyle(color: c.textMain, fontSize: 12.sp, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: file == null ? onPick : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: c.bgSubtle,
              border: Border.all(
                color: c.primary.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: file == null
                ? Column(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.upload_file_rounded, color: c.primary, size: 26.sp),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        ar ? 'اسحب وأفلت ملف PDF هنا' : 'Drag & drop your PDF here',
                        style: TextStyle(color: c.textMain, fontSize: 13.sp, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        ar ? 'أو اضغط لاختيار الملف' : 'or tap to select a file',
                        style: TextStyle(color: c.textMuted, fontSize: 12.sp),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          color: const Color(0x15EF4444),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(Icons.picture_as_pdf_rounded, color: const Color(0xFFEF4444), size: 22.sp),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: c.textMain, fontSize: 12.sp, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              '${(file!.size / 1024).toStringAsFixed(1)} KB',
                              style: TextStyle(color: c.textMuted, fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: Icon(Icons.close_rounded, color: const Color(0xFFEF4444), size: 20.sp),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

// ─── Gold Submit Button ───────────────────────────────────────────────────────

class _GoldButton extends StatelessWidget {
  const _GoldButton({required this.label, required this.submitting, required this.isArabic, required this.onTap});
  final String label;
  final bool submitting;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: submitting ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: submitting
              ? const LinearGradient(colors: [Color(0x99D4AF37), Color(0x99FBBF24)])
              : const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFFBBF24), Color(0xFFD4AF37)],
                ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: submitting
              ? null
              : [BoxShadow(color: const Color(0x44D4AF37), blurRadius: 16.r, offset: Offset(0, 6.h))],
        ),
        child: Center(
          child: submitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1a0a3a)),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      isArabic ? 'جاري الإرسال...' : 'Sending...',
                      style: TextStyle(color: const Color(0xFF1a0a3a), fontSize: 14.sp, fontWeight: FontWeight.w900),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(color: const Color(0xFF1a0a3a), fontSize: 15.sp, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                      color: const Color(0xFF1a0a3a),
                      size: 18.sp,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Success Card ─────────────────────────────────────────────────────────────

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.name, required this.isArabic, required this.onReset});
  final String name;
  final bool isArabic;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final ar = isArabic;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0x4422C55E)),
        boxShadow: [BoxShadow(color: const Color(0x1122C55E), blurRadius: 24.r)],
      ),
      child: Column(
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              color: const Color(0x1422C55E),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x5522C55E), width: 2),
            ),
            child: Icon(Icons.check_circle_rounded, color: const Color(0xFF22C55E), size: 40.sp),
          ),
          SizedBox(height: 20.h),
          Text(
            ar ? 'تم إرسال طلبك بنجاح!' : 'Application Submitted!',
            style: TextStyle(color: c.textMain, fontSize: 22.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10.h),
          Text(
            ar
                ? 'شكراً ${name.isNotEmpty ? name : "لك"}، استلمنا طلبك وهنتواصل معاك قريباً.'
                : 'Thank you${name.isNotEmpty ? " $name" : ""}, we received your application and will reach out soon.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textMuted, fontSize: 14.sp, height: 1.65),
          ),
          SizedBox(height: 28.h),
          OutlinedButton.icon(
            onPressed: onReset,
            icon: Icon(Icons.refresh_rounded, size: 18.sp),
            label: Text(ar ? 'تقديم طلب جديد' : 'Submit another application'),
            style: OutlinedButton.styleFrom(
              foregroundColor: c.primary,
              side: BorderSide(color: c.primary.withValues(alpha: 0.5)),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  const _Label({required this.text, required this.child, this.required = false, this.hasError = false, this.errorText});
  final String text;
  final Widget child;
  final bool required;
  final bool hasError;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: hasError ? const Color(0xFFEF4444) : c.textMain,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (required)
            Text(' *', style: TextStyle(color: const Color(0xFFEF4444), fontSize: 13.sp, fontWeight: FontWeight.w900)),
        ]),
        SizedBox(height: 5.h),
        child,
        if (hasError && errorText != null) ...[
          SizedBox(height: 4.h),
          _ErrorNote(errorText!),
        ],
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.icon,
    this.hasError = false,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool hasError;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: maxLines > 1 ? maxLines : 1,
      readOnly: readOnly,
      onChanged: onChanged,
      style: TextStyle(color: c.textMain, fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.textLight, fontSize: 12.sp),
        prefixIcon: icon != null
            ? Icon(icon, size: 17.sp, color: hasError ? const Color(0xFFEF4444) : c.textLight)
            : null,
        filled: true,
        fillColor: hasError ? const Color(0x0CEF4444) : c.bgSubtle,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: c.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: hasError ? const Color(0xFFEF4444) : c.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: hasError ? const Color(0xFFEF4444) : c.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({required this.value, required this.items, required this.onChanged, this.hint, this.hasError = false});
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      hint: hint != null ? Text(hint!, style: TextStyle(color: c.textLight, fontSize: 12.sp)) : null,
      dropdownColor: c.bgCard,
      style: TextStyle(color: c.textMain, fontSize: 13.sp, fontFamily: 'Tajawal'),
      decoration: InputDecoration(
        filled: true,
        fillColor: hasError ? const Color(0x0CEF4444) : c.bgSubtle,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: c.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: hasError ? const Color(0xFFEF4444) : c.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: hasError ? const Color(0xFFEF4444) : c.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _TwoCol extends StatelessWidget {
  const _TwoCol({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: 12.w),
        Expanded(child: right),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.color, required this.title, required this.body});
  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: c.textMain, fontSize: 11.sp, fontWeight: FontWeight.w900)),
                SizedBox(height: 2.h),
                Text(body, style: TextStyle(color: c.textMuted, fontSize: 11.sp, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Row(
      children: [
        Icon(icon, color: c.primary, size: 16.sp),
        SizedBox(width: 7.w),
        Text(text, style: TextStyle(color: c.textMain, fontSize: 14.sp, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _ErrorNote extends StatelessWidget {
  const _ErrorNote(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.error_outline_rounded, color: const Color(0xFFEF4444), size: 13.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: const Color(0xFFEF4444), fontSize: 11.sp, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _SmallBtn extends StatelessWidget {
  const _SmallBtn({required this.label, required this.icon, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13.sp),
            SizedBox(width: 4.w),
            Text(label, style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

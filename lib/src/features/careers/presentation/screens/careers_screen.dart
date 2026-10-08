import 'dart:convert';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/birthday_field.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const _submitUrl = 'https://etba3ly-dm.com/api-careers/submit-application.php';
const _companyMapUrl = 'https://maps.app.goo.gl/kHdWiv47KVqSdRgd8';
const _submissionTimeout = Duration(seconds: 180);
const _statusTimeout = Duration(seconds: 12);

// ─── Data models ─────────────────────────────────────────────────────────────

class _Job {
  const _Job({
    required this.title,
    required this.location,
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
  final String type = 'دوام كامل';
  final String location;
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

/// Arabic value → English label, for the job chips (type / location / experience).
const _valuesEn = <String, String>{
  'دوام كامل': 'Full time',
  'ريموت': 'Remote',
  'الإسكندرية': 'Alexandria',
  'أقل من سنة': 'Less than a year',
  'سنة': '1 year',
  'أكثر من خمس سنين': 'More than 5 years',
};

String _valueLabel(String ar, bool isAr) => isAr ? ar : (_valuesEn[ar] ?? ar);

// The titles must match the list the careers API accepts (`$allowedJobTitles`).
const _jobs = <_Job>[
  _Job(
    title: 'CEO',
    location: 'ريموت',
    experience: 'أكثر من خمس سنين',
    icon: Icons.manage_accounts_rounded,
    color: Color(0xFF6F3FF5),
    fullAr: 'قدّم على دور قيادي يركز على وضع الاستراتيجية، توجيه الفريق، متابعة التشغيل، ودفع نمو الشركة.',
    fullEn: 'Apply for a leadership role focused on strategy, team direction, operations, and business growth.',
    responsibilitiesAr: ['قيادة الفريق وتوجيهه', 'وضع الخطط الاستراتيجية', 'متابعة الأداء والنمو'],
    responsibilitiesEn: ['Leadership', 'Strategic planning', 'Team management'],
    requirementsAr: ['قدرة عالية على تحمل المسؤولية', 'خبرة في الإدارة وقيادة الفرق'],
    requirementsEn: ['Strong ownership mindset', 'Management experience'],
    skillsAr: ['قيادة', 'استراتيجية', 'تواصل'],
    skillsEn: ['Leadership', 'Strategy', 'Communication'],
  ),
  _Job(
    title: 'Account Manager',
    location: 'ريموت',
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
    title: 'Assistant Account Manager',
    location: 'ريموت',
    experience: 'سنة',
    icon: Icons.group_rounded,
    color: Color(0xFF14B8A6),
    fullAr: 'ساعد الأكونت مانيجر في تنظيم طلبات العملاء، متابعة الحملات، وتنسيق التسليم مع الفريق.',
    fullEn: 'Support the account manager by organizing client requests, following up on campaigns, and coordinating delivery with the team.',
    responsibilitiesAr: ['متابعة العملاء', 'تنظيم بيانات وطلبات الحسابات', 'التنسيق مع فريق التنفيذ'],
    responsibilitiesEn: ['Client follow-up', 'Organizing account details', 'Team coordination'],
    requirementsAr: ['مهارات تواصل جيدة', 'الدقة والتنظيم في المتابعة'],
    requirementsEn: ['Good communication skills', 'Attention to detail and organized follow-up'],
    skillsAr: ['تواصل', 'تنظيم', 'متابعة'],
    skillsEn: ['Communication', 'Organization', 'Follow-up'],
  ),
  _Job(
    title: 'Web Developer',
    location: 'ريموت',
    experience: 'سنة',
    icon: Icons.code_rounded,
    color: Color(0xFF0EA5E9),
    fullAr: 'قدّم على وظيفة تطوير ويب تركز على بناء مواقع متجاوبة، تحسين الأداء، وكتابة كود منظم وسهل الصيانة.',
    fullEn: 'Apply for a web development role focused on responsive websites, performance, and maintainable code.',
    responsibilitiesAr: ['تطوير صفحات ومواقع ويب', 'تنفيذ واجهات أمامية متجاوبة', 'تحسين الأداء وإصلاح المشاكل'],
    responsibilitiesEn: ['Website development', 'Frontend implementation', 'Performance fixes'],
    requirementsAr: ['معرفة جيدة بـ HTML وCSS وJavaScript', 'خبرة في التصميم المتجاوب'],
    requirementsEn: ['HTML, CSS, JavaScript knowledge', 'Responsive design experience'],
    skillsAr: ['HTML', 'CSS', 'JavaScript'],
    skillsEn: ['HTML', 'CSS', 'JavaScript'],
  ),
  _Job(
    title: 'Sales',
    location: 'الإسكندرية',
    experience: 'أقل من سنة',
    icon: Icons.trending_up_rounded,
    color: Color(0xFF22C55E),
    fullAr: 'تأهيل العملاء وشرح الخدمات ومتابعة العروض والاعتراضات حتى إتمام التعاقد.',
    fullEn: 'Own lead qualification, service presentation, follow-up, objections, and closing.',
    responsibilitiesAr: ['تأهيل العملاء المحتملين', 'شرح الخدمات والأسعار', 'المتابعة وإتمام التعاقد'],
    responsibilitiesEn: ['Qualify leads', 'Present services', 'Follow up and close'],
    requirementsAr: ['مهارات تواصل قوية', 'التزام بالمتابعة', 'القدرة على تحقيق الأهداف'],
    requirementsEn: ['Strong communication', 'Consistent follow-up', 'Target ownership'],
    skillsAr: ['مبيعات', 'تفاوض', 'إغلاق الصفقات'],
    skillsEn: ['Sales', 'Negotiation', 'Closing'],
  ),
  _Job(
    title: 'Moderator',
    location: 'ريموت',
    experience: 'أقل من سنة',
    icon: Icons.forum_rounded,
    color: Color(0xFF8B5CF6),
    fullAr: 'متابعة الرسائل والتعليقات وتأهيل العملاء وتسجيل الفرص وتصعيد الشكاوى المهمة.',
    fullEn: 'Handle brand inboxes, qualify conversations, track leads, and escalate complaints.',
    responsibilitiesAr: ['الرد على الرسائل والتعليقات', 'تأهيل المحادثات', 'تسجيل المشكلات وتصعيدها'],
    responsibilitiesEn: ['Reply to messages', 'Qualify conversations', 'Track and escalate issues'],
    requirementsAr: ['كتابة سليمة', 'سرعة في الرد', 'الالتزام بالشفتات'],
    requirementsEn: ['Accurate writing', 'Fast response', 'Shift commitment'],
    skillsAr: ['مودريشن', 'خدمة عملاء', 'متابعة'],
    skillsEn: ['Moderation', 'Customer service', 'Follow-up'],
  ),
  _Job(
    title: 'Mobile App Developer',
    location: 'ريموت',
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
    title: 'Graphic Designer & Video Editor',
    location: 'ريموت',
    experience: 'سنة',
    icon: Icons.movie_creation_rounded,
    color: Color(0xFFD946EF),
    fullAr: 'قدّم على وظيفة إبداعية تجمع بين تصميم الجرافيك، مونتاج الفيديو، وتجهيز محتوى السوشيال ميديا.',
    fullEn: 'Apply for a hybrid creative role covering graphic design, video editing, and social media content.',
    responsibilitiesAr: ['تصميم المواد البصرية', 'مونتاج الفيديوهات', 'تجهيز محتوى الحملات'],
    responsibilitiesEn: ['Design assets', 'Edit videos', 'Prepare campaign visuals'],
    requirementsAr: ['بورتفوليو تصميم ومونتاج', 'خبرة في أدوات Adobe للتصميم والمونتاج'],
    requirementsEn: ['Design and editing portfolio', 'Adobe tools experience'],
    skillsAr: ['تصميم', 'مونتاج فيديو', 'سوشيال ميديا'],
    skillsEn: ['Design', 'Video editing', 'Social media'],
  ),
  _Job(
    title: 'Sales & Moderator',
    location: 'ريموت',
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
    title: 'Videographer & Content Creator',
    location: 'الإسكندرية',
    experience: 'سنة',
    icon: Icons.videocam_rounded,
    color: Color(0xFFF97316),
    fullAr: 'تطوير الأفكار والهوكات والسكريبتات وتجهيز التصوير وتنفيذ الريلز والإعلانات ومحتوى UGC.',
    fullEn: 'Develop ideas, hooks, and scripts, prepare shoots, and capture reels, ads, and UGC content.',
    responsibilitiesAr: ['ابتكار أفكار الفيديو', 'تنفيذ جلسات التصوير', 'تنظيم وتسليم الخامات'],
    responsibilitiesEn: ['Develop video concepts', 'Execute shoots', 'Organize and deliver footage'],
    requirementsAr: ['خبرة في تصوير الفيديو', 'فهم المحتوى القصير', 'حس بصري قوي'],
    requirementsEn: ['Videography experience', 'Short-form content knowledge', 'Strong visual sense'],
    skillsAr: ['تصوير فيديو', 'صناعة محتوى', 'كتابة سكريبت'],
    skillsEn: ['Videography', 'Content creation', 'Scriptwriting'],
  ),
  _Job(
    title: 'Social Media Specialist',
    location: 'ريموت',
    experience: 'سنة',
    icon: Icons.tag_rounded,
    color: Color(0xFF06B6D4),
    fullAr: 'قدّم على وظيفة سوشيال ميديا تركز على تخطيط المحتوى، النشر، التقارير، وتحسين نمو الحسابات.',
    fullEn: 'Apply for a social media role focused on content planning, publishing, reporting, and account growth.',
    responsibilitiesAr: ['تخطيط المحتوى', 'تنظيم النشر', 'إعداد التقارير ومتابعة الأداء'],
    responsibilitiesEn: ['Content planning', 'Publishing', 'Reports'],
    requirementsAr: ['معرفة جيدة بمنصات السوشيال ميديا', 'حس قوي في صناعة المحتوى'],
    requirementsEn: ['Social media knowledge', 'Content sense'],
    skillsAr: ['محتوى', 'تخطيط', 'تحليل أداء'],
    skillsEn: ['Content', 'Planning', 'Analytics'],
  ),
  _Job(
    title: 'Media Buyer',
    location: 'ريموت',
    experience: 'سنة',
    icon: Icons.gps_fixed_rounded,
    color: Color(0xFFF97316),
    fullAr: 'قدّم على وظيفة ميديا باير تركز على دراسة السوق، إعداد الاستراتيجية، اختبار الحملات وتحسينها وتوسيعها، وقياس النتائج عبر Meta وTikTok وGoogle.',
    fullEn: 'Apply for a media buying role focused on research, campaign strategy, testing, optimization, scaling, and measurable performance across Meta, TikTok, and Google.',
    responsibilitiesAr: ['إعداد استراتيجيات شراء إعلاني متكاملة', 'إطلاق الحملات المدفوعة وتحسينها وتوسيعها', 'تحليل الأداء وإعداد تقارير واضحة'],
    responsibilitiesEn: ['Build media buying strategies', 'Launch and optimize paid campaigns', 'Analyze performance and prepare reports'],
    requirementsAr: ['خبرة عملية في إدارة الإعلانات المدفوعة', 'فهم قوي لمؤشرات CTR وCPC وCPA وROAS', 'القدرة على دراسة الجمهور والمنافسين'],
    requirementsEn: ['Hands-on paid ads experience', 'Strong understanding of CTR, CPC, CPA, and ROAS', 'Ability to research audiences and competitors'],
    skillsAr: ['إعلانات Meta', 'إعلانات TikTok', 'إعلانات Google', 'تحليل البيانات'],
    skillsEn: ['Meta Ads', 'TikTok Ads', 'Google Ads', 'Analytics'],
  ),
  _Job(
    title: 'PR - Public Relations',
    location: 'ريموت',
    experience: 'سنة',
    icon: Icons.campaign_rounded,
    color: Color(0xFFA855F7),
    fullAr: 'قدّم على وظيفة علاقات عامة تركز على التواصل الاحترافي، متابعة فرص التعاون، وتمثيل الشركة بصورة قوية أمام الجهات الخارجية.',
    fullEn: 'Apply for a public relations role focused on professional outreach, partnership follow-up, and clear communication with external contacts.',
    responsibilitiesAr: ['التواصل مع جهات خارجية باحتراف', 'متابعة فرص التعاون', 'تنسيق الاجتماعات والردود الرسمية'],
    responsibilitiesEn: ['Professional outreach', 'Partnership follow-up', 'Meeting coordination'],
    requirementsAr: ['مهارات تواصل ممتازة', 'قدرة قوية على المتابعة', 'كتابة رسائل رسمية باحتراف'],
    requirementsEn: ['Excellent communication', 'Strong follow-up', 'Professional writing'],
    skillsAr: ['علاقات عامة', 'تواصل', 'متابعة'],
    skillsEn: ['Public relations', 'Communication', 'Follow-up'],
  ),
  _Job(
    title: 'Hospitality & Services Officer',
    location: 'الإسكندرية',
    experience: 'أقل من سنة',
    icon: Icons.room_service_rounded,
    color: Color(0xFFD4AF37),
    fullAr: 'وظيفة خدمات وضيافة مسؤولة عن تجهيز مقر العمل يوميًا، متابعة النظافة والترتيب، تجهيز المشروبات والضيافة، متابعة المستلزمات، واستقبال الزوار بصورة لائقة.',
    fullEn: 'A workplace services role responsible for daily hospitality, office organization, cleanliness follow-up, supplies, and welcoming visitors professionally.',
    responsibilitiesAr: [
      'تجهيز الضيافة والمشروبات للموظفين والزوار',
      'الحفاظ على نظافة وترتيب أماكن العمل والاجتماعات',
      'متابعة مستلزمات الضيافة والنظافة والإبلاغ عن النواقص',
      'دعم احتياجات الخدمات اليومية داخل مقر العمل',
    ],
    responsibilitiesEn: [
      'Prepare hospitality for employees and visitors',
      'Keep work and meeting areas clean and organized',
      'Monitor hospitality and cleaning supplies',
      'Support daily workplace service needs',
    ],
    requirementsAr: [
      'الأمانة والاهتمام بالنظافة والالتزام بالمواعيد',
      'حسن التعامل والمظهر اللائق',
      'القدرة على العمل بدوام كامل من مقر الشركة في الإسكندرية',
    ],
    requirementsEn: [
      'Reliability, cleanliness, and punctuality',
      'Professional and respectful communication',
      'Ability to work full-time from Alexandria',
    ],
    skillsAr: ['ضيافة', 'تنظيم', 'نظافة', 'التزام'],
    skillsEn: ['Hospitality', 'Organization', 'Cleanliness', 'Commitment'],
  ),
];

class _Opt {
  const _Opt(this.value, this.ar, this.en);
  final String value;
  final String ar;
  final String en;
}

const _expOptions = <_Opt>[
  _Opt('less_than_year', 'أقل من سنة', 'Less than 1 year'),
  _Opt('one_year', 'سنة', '1 year'),
  _Opt('two_years', 'سنتين', '2 years'),
  _Opt('three_years', 'ثلاث سنين', '3 years'),
  _Opt('four_years', 'أربع سنين', '4 years'),
  _Opt('five_years', 'خمس سنين', '5 years'),
  _Opt('more_than_five', 'أكثر من خمس سنين', 'More than 5 years'),
];

const _genderOptions = <_Opt>[
  _Opt('male', 'ذكر', 'Male'),
  _Opt('female', 'أنثى', 'Female'),
];

/// Marital status labels follow the applicant's gender (the API only stores [value]).
class _MaritalOpt {
  const _MaritalOpt(this.value, this.neutralAr, this.maleAr, this.femaleAr, this.en);
  final String value;
  final String neutralAr;
  final String maleAr;
  final String femaleAr;
  final String en;

  String label(bool isAr, String gender) {
    if (!isAr) return en;
    if (gender == 'male') return maleAr;
    if (gender == 'female') return femaleAr;
    return neutralAr;
  }
}

const _maritalOptions = <_MaritalOpt>[
  _MaritalOpt('single', 'أعزب / آنسة', 'أعزب', 'آنسة', 'Single'),
  _MaritalOpt('married', 'متزوج / متزوجة', 'متزوج', 'متزوجة', 'Married'),
  _MaritalOpt('divorced', 'مطلق / مطلقة', 'مطلق', 'مطلقة', 'Divorced'),
  _MaritalOpt('widowed', 'أرمل / أرملة', 'أرمل', 'أرملة', 'Widowed'),
];

const _employmentOptions = <_Opt>[
  _Opt('employed', 'أعمل حالياً', 'Currently employed'),
  _Opt('not_employed', 'لا أعمل حالياً', 'Not currently employed'),
];

const _skillLevels = <_Opt>[
  _Opt('no', 'لا', 'No'),
  _Opt('pass', 'مقبول', 'Pass'),
  _Opt('good', 'جيد', 'Good'),
  _Opt('excellent', 'ممتاز', 'Excellent'),
];

const _yesNoOptions = <_Opt>[
  _Opt('yes', 'نعم', 'Yes'),
  _Opt('no', 'لا', 'No'),
];

const _availabilityOptions = <_Opt>[
  _Opt('full_time', 'دوام كامل', 'Full time'),
  _Opt('part_time', 'دوام جزئي', 'Part time'),
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
  _Area('awayed', 'العوايد', 'Awayed'),
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
  _Area('king_mariout', 'كينج مريوط', 'King Mariout'),
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

// ─── Interview scheduling ────────────────────────────────────────────────────
//
// Interviews run on Tuesdays (4 PM – 8 PM) and Thursdays (2 PM – 6 PM) in
// 20-minute slots. Booking opens from tomorrow (Cairo time) up to 31 days ahead,
// which is exactly what the careers API accepts.

class _InterviewSlot {
  const _InterviewSlot(this.startMinutes);
  final int startMinutes;

  static const _length = 20;

  String get value => '${_hhmm(startMinutes)}-${_hhmm(startMinutes + _length)}';

  String label(bool isAr) =>
      '${_clock(startMinutes, isAr)} – ${_clock(startMinutes + _length, isAr)}';

  static String _hhmm(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

  static String _clock(int minutes, bool isAr) {
    final hour = minutes ~/ 60;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final suffix = hour >= 12 ? (isAr ? 'م' : 'PM') : (isAr ? 'ص' : 'AM');
    return '$hour12:${(minutes % 60).toString().padLeft(2, '0')} $suffix';
  }
}

List<_InterviewSlot> _slotsBetween(int fromMinutes, int toMinutes) => [
      for (var m = fromMinutes; m < toMinutes; m += _InterviewSlot._length)
        _InterviewSlot(m),
    ];

final _tuesdaySlots = _slotsBetween(16 * 60, 20 * 60);
final _thursdaySlots = _slotsBetween(14 * 60, 18 * 60);

class _InterviewDay {
  const _InterviewDay(this.date);
  final DateTime date;

  bool get isThursday => date.weekday == DateTime.thursday;
  List<_InterviewSlot> get slots => isThursday ? _thursdaySlots : _tuesdaySlots;

  String get value =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static const _weekdaysAr = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
  static const _weekdaysEn = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const _monthsAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];
  static const _monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String label(bool isAr) => isAr
      ? '${_weekdaysAr[date.weekday - 1]}، ${date.day} ${_monthsAr[date.month - 1]} ${date.year}'
      : '${_weekdaysEn[date.weekday - 1]} ${date.day} ${_monthsEn[date.month - 1]} ${date.year}';
}

DateTime _lastWeekdayOf(int year, int month, int weekday) {
  var day = DateTime.utc(year, month + 1, 0);
  while (day.weekday != weekday) {
    day = day.subtract(const Duration(days: 1));
  }
  return day;
}

/// Egypt observes DST from the last Friday of April to the last Thursday of October.
bool _isEgyptDst(DateTime utc) {
  final start = DateTime.utc(utc.year, 4, _lastWeekdayOf(utc.year, 4, DateTime.friday).day)
      .subtract(const Duration(hours: 2));
  final end = DateTime.utc(utc.year, 10, _lastWeekdayOf(utc.year, 10, DateTime.thursday).day, 21);
  return !utc.isBefore(start) && utc.isBefore(end);
}

/// Wall-clock time in Cairo, independent of the phone's own time zone.
DateTime _cairoNow() {
  final utc = DateTime.now().toUtc();
  final cairo = utc.add(Duration(hours: _isEgyptDst(utc) ? 3 : 2));
  return DateTime(cairo.year, cairo.month, cairo.day, cairo.hour, cairo.minute, cairo.second);
}

List<_InterviewDay> _buildInterviewDays() {
  final now = _cairoNow();
  final days = <_InterviewDay>[];
  for (var offset = 1; offset <= 31; offset++) {
    final date = DateTime(now.year, now.month, now.day + offset, 12);
    if (date.weekday == DateTime.tuesday || date.weekday == DateTime.thursday) {
      days.add(_InterviewDay(date));
    }
  }
  return days;
}

// ─── Input helpers ───────────────────────────────────────────────────────────

/// Keeps only digits, converting Arabic-Indic / Persian digits to Latin ones.
String _latinDigits(String value) => latinDigitsOnly(value);

class _DigitsFormatter extends TextInputFormatter {
  const _DigitsFormatter(this.maxLength);
  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = _latinDigits(newValue.text);
    if (digits.length > maxLength) digits = digits.substring(0, maxLength);
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

/// The API takes the age from the date of birth; applicants must be 18-40.
bool _validBirthDate(String iso) => validApplicantBirthDate(iso, _cairoNow());

bool _validMobile(String digits) => RegExp(r'^01[0125]\d{8}$').hasMatch(digits);

bool _validEmail(String value) => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);

String _normalizeUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || RegExp(r'^[a-z][a-z0-9+.-]*://', caseSensitive: false).hasMatch(trimmed)) {
    return trimmed;
  }
  final looksLikeDomain =
      RegExp(r'^([\p{L}\p{N}-]+\.)+[\p{L}]{2,}(?:[/:?#]|$)', unicode: true).hasMatch(trimmed);
  return looksLikeDomain ? 'https://$trimmed' : trimmed;
}

bool _validHttpUrl(String value) {
  final url = _normalizeUrl(value);
  if (url.isEmpty) return true;
  if (url.length > 2048) return false;
  final uri = Uri.tryParse(url);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
}

bool _validLinkedIn(String value) {
  final url = _normalizeUrl(value);
  if (url.isEmpty) return true;
  if (!_validHttpUrl(url)) return false;
  final host = Uri.parse(url).host.toLowerCase();
  return host == 'linkedin.com' || host.endsWith('.linkedin.com');
}

bool _isAllowedImage(String fileName) =>
    const {'jpg', 'jpeg', 'png', 'webp'}.contains(fileName.split('.').last.toLowerCase());

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

String _newSubmissionToken() {
  final random = math.Random.secure();
  return List.generate(32, (_) => random.nextInt(16).toRadixString(16)).join();
}

Map<String, dynamic>? _asMap(dynamic data) {
  if (data is Map) return Map<String, dynamic>.from(data);
  if (data is String) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return null;
}

class _PickedImage {
  const _PickedImage(this.bytes, this.name);
  final Uint8List bytes;
  final String name;
}

class _UploadFile {
  const _UploadFile(this.name, this.bytes);
  final String name;
  final Uint8List bytes;
}

enum _SubmitPhase { idle, uploading, verifying, retrying }

// ─── Screen ───────────────────────────────────────────────────────────────────

class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key});

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  final _scrollController = ScrollController();
  final _keys = <String, GlobalKey>{};
  final _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 30)));

  final _nameCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _portfolioCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _achievementsCtrl = TextEditingController();
  final _coverCtrl = TextEditingController();

  /// `YYYY-MM-DD`; empty until the three boxes make a real date.
  String _birthDate = '';

  _Job? _selectedJob;
  String _experienceLevel = '';
  String _gender = '';
  String _maritalStatus = '';
  String _employmentStatus = '';
  String _address = '';
  String _englishLevel = '';
  String _computerSkill = '';
  String _cameraAvailable = '';
  String _videoEditing = '';
  String _ugc = '';
  String _workUnderPressure = '';
  String _availability = '';

  late List<_InterviewDay> _interviewDays;
  String _interviewDate = '';
  String _interviewTime = '';

  _PickedImage? _photo;
  _PickedImage? _idFront;
  _PickedImage? _idBack;
  PlatformFile? _cvFile;

  String _submissionToken = '';
  _SubmitPhase _phase = _SubmitPhase.idle;
  bool _sent = false;
  String _submitError = '';

  bool _jobError = false;
  bool _expError = false;
  bool _photoError = false;
  bool _nameError = false;
  bool _ageError = false;
  bool _educationError = false;
  bool _genderError = false;
  bool _maritalError = false;
  bool _addressError = false;
  bool _emailError = false;
  bool _waError = false;
  bool _portfolioError = false;
  bool _linkedinError = false;
  bool _skillsError = false;
  bool _employmentError = false;
  bool _interviewError = false;
  bool _idFrontError = false;
  bool _idBackError = false;
  bool _coverError = false;

  bool get _isAr => context.locale.languageCode == 'ar';
  bool get _submitting => _phase != _SubmitPhase.idle;

  GlobalKey _k(String name) => _keys.putIfAbsent(name, GlobalKey.new);

  Widget _keyed(String name, Widget child) => KeyedSubtree(key: _k(name), child: child);

  @override
  void initState() {
    super.initState();
    _interviewDays = _buildInterviewDays();
    _selectFirstInterviewSlot();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dio.close();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _controllers => [
        _nameCtrl,
        _educationCtrl,
        _emailCtrl,
        _whatsappCtrl,
        _portfolioCtrl,
        _linkedinCtrl,
        _skillsCtrl,
        _experienceCtrl,
        _achievementsCtrl,
        _coverCtrl,
      ];

  // ── Interview ──────────────────────────────────────────────────────────────

  void _selectFirstInterviewSlot() {
    final first = _interviewDays.isEmpty ? null : _interviewDays.first;
    _interviewDate = first?.value ?? '';
    _interviewTime = first?.slots.first.value ?? '';
  }

  _InterviewDay? get _selectedDay {
    for (final day in _interviewDays) {
      if (day.value == _interviewDate) return day;
    }
    return null;
  }

  _InterviewSlot? get _selectedSlot {
    for (final slot in _selectedDay?.slots ?? const <_InterviewSlot>[]) {
      if (slot.value == _interviewTime) return slot;
    }
    return null;
  }

  bool get _validInterview => _selectedDay != null && _selectedSlot != null;

  String _interviewSummary(bool isAr) {
    final day = _selectedDay;
    final slot = _selectedSlot;
    if (day == null || slot == null) return '';
    return '${day.label(isAr)} · ${slot.label(isAr)}';
  }

  void _onInterviewDayChanged(String? value) {
    if (value == null) return;
    setState(() {
      _interviewDate = value;
      final slots = _selectedDay?.slots ?? const <_InterviewSlot>[];
      if (slots.isNotEmpty && !slots.any((s) => s.value == _interviewTime)) {
        _interviewTime = slots.first.value;
      }
      _interviewError = false;
    });
  }

  // ── Attachments ────────────────────────────────────────────────────────────

  /// Returns the picked image, or `null` when cancelled. [onInvalid] runs when
  /// the file type is not one the careers API accepts (JPEG / PNG / WEBP).
  Future<_PickedImage?> _pickImage({
    required double maxSize,
    required int quality,
    required VoidCallback onInvalid,
  }) async {
    // Downscaling here keeps phone-camera files small, like the website does.
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: maxSize,
      maxHeight: maxSize,
      imageQuality: quality,
    );
    if (picked == null) return null;
    if (!_isAllowedImage(picked.name)) {
      if (mounted) onInvalid();
      return null;
    }
    return _PickedImage(await picked.readAsBytes(), picked.name);
  }

  Future<void> _pickPhoto() async {
    final image = await _pickImage(
      maxSize: 1400,
      quality: 82,
      onInvalid: () => setState(() => _photoError = true),
    );
    if (image == null || !mounted) return;
    setState(() {
      _photo = image;
      _photoError = false;
    });
  }

  Future<void> _pickIdCard({required bool front}) async {
    final image = await _pickImage(
      maxSize: 1800,
      quality: 86,
      onInvalid: () => setState(() {
        if (front) {
          _idFrontError = true;
        } else {
          _idBackError = true;
        }
      }),
    );
    if (image == null || !mounted) return;
    setState(() {
      if (front) {
        _idFront = image;
        _idFrontError = false;
      } else {
        _idBack = image;
        _idBackError = false;
      }
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

  // ── Validation ─────────────────────────────────────────────────────────────

  /// Validates the whole form, flags every invalid field and scrolls to the
  /// first one (in page order). The rules mirror the careers API.
  bool _validate() {
    final email = _emailCtrl.text.trim();
    final skills = [
      _englishLevel,
      _computerSkill,
      _cameraAvailable,
      _videoEditing,
      _ugc,
      _workUnderPressure,
      _availability,
    ];

    setState(() {
      _jobError = _selectedJob == null;
      _expError = _experienceLevel.isEmpty;
      _photoError = _photo == null;
      _nameError = _nameCtrl.text.trim().length < 2;
      _ageError = !_validBirthDate(_birthDate);
      _educationError = _educationCtrl.text.trim().length < 2;
      _genderError = _gender.isEmpty;
      _maritalError = _maritalStatus.isEmpty;
      _addressError = _address.isEmpty;
      _emailError = email.isNotEmpty && !_validEmail(email);
      _waError = !_validMobile(_latinDigits(_whatsappCtrl.text));
      _portfolioError = !_validHttpUrl(_portfolioCtrl.text);
      _linkedinError = !_validLinkedIn(_linkedinCtrl.text);
      _skillsError = skills.any((v) => v.isEmpty);
      _employmentError = _employmentStatus.isEmpty;
      _interviewError = !_validInterview;
      _idFrontError = _idFront == null;
      _idBackError = _idBack == null;
      _coverError = _coverCtrl.text.trim().length < 20;
    });

    // Page order, so the first entry is the field the applicant sees first.
    final pageOrder = <String, bool>{
      'job': _jobError,
      'exp': _expError,
      'photo': _photoError,
      'name': _nameError,
      'age': _ageError,
      'education': _educationError,
      'gender': _genderError,
      'marital': _maritalError,
      'address': _addressError,
      'email': _emailError,
      'whatsapp': _waError,
      'portfolio': _portfolioError,
      'linkedin': _linkedinError,
      'skills': _skillsError,
      'employment': _employmentError,
      'interview': _interviewError,
      'idFront': _idFrontError,
      'idBack': _idBackError,
      'cover': _coverError,
    };
    final firstInvalid = pageOrder.entries.where((e) => e.value).map((e) => e.key).firstOrNull;
    if (firstInvalid == null) return true;
    _scrollTo(firstInvalid);
    return false;
  }

  void _scrollTo(String key) {
    // Error messages are inserted above the fields, so wait for the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _keys[key]?.currentContext;
      if (target == null || !target.mounted) return;
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        alignment: 0.1,
      );
    });
  }

  // ── Submission ─────────────────────────────────────────────────────────────

  Map<String, String> _applicationFields(_Job job) {
    final area = _alexandriaAreas.firstWhere((a) => a.value == _address);
    return {
      'submission_token': _submissionToken,
      'job_id': '0',
      'job_title': job.title,
      'name': _nameCtrl.text.trim(),
      'birth_date': _birthDate,
      // Older servers only read the age, so it travels with the date it comes from.
      'age': '${birthdayAge(_birthDate, _cairoNow()) ?? ''}',
      'gender': _gender,
      'marital_status': _maritalStatus,
      'employment_status': _employmentStatus,
      'address': 'الإسكندرية - ${area.ar} / Alexandria - ${area.en}',
      'education': _educationCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'whatsapp': _latinDigits(_whatsappCtrl.text),
      'portfolio_url': _normalizeUrl(_portfolioCtrl.text),
      'linkedin_url': _normalizeUrl(_linkedinCtrl.text),
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
      'interview_date': _interviewDate,
      'interview_time_slot': _interviewTime,
      'cover': _coverCtrl.text.trim(),
    };
  }

  Map<String, _UploadFile> _applicationFiles() {
    final cv = _cvFile;
    return {
      'photo': _UploadFile(_photo!.name, _photo!.bytes),
      'id_card_front': _UploadFile(_idFront!.name, _idFront!.bytes),
      'id_card_back': _UploadFile(_idBack!.name, _idBack!.bytes),
      if (cv != null && cv.bytes != null) 'cv': _UploadFile(cv.name, cv.bytes!),
    };
  }

  Future<void> _submit() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    if (!_validate()) return;

    // One token per application: the server uses it to ignore a duplicate send
    // and to tell us whether an interrupted upload actually arrived.
    if (_submissionToken.isEmpty) _submissionToken = _newSubmissionToken();
    setState(() {
      _phase = _SubmitPhase.uploading;
      _submitError = '';
    });
    await _sendApplication(attempt: 0, recovery: false);
  }

  Future<void> _sendApplication({required int attempt, required bool recovery}) async {
    final fields = _applicationFields(_selectedJob!);
    final files = _applicationFiles();
    if (attempt > 0 && mounted) setState(() => _phase = _SubmitPhase.retrying);

    try {
      // If the server could not read the multipart body, the second attempt
      // sends the same data as base64 JSON instead of repeating the same upload.
      final Object payload = recovery
          ? {
              'transport': 'career-json-v1',
              'fields': fields,
              'files': {
                for (final e in files.entries)
                  e.key: {
                    'name': e.value.name,
                    'size': e.value.bytes.length,
                    'base64': base64Encode(e.value.bytes),
                  },
              },
            }
          : FormData.fromMap({
              ...fields,
              for (final e in files.entries)
                e.key: MultipartFile.fromBytes(e.value.bytes, filename: e.value.name),
            });

      final response = await _dio.post<dynamic>(
        _submitUrl,
        data: payload,
        options: Options(
          sendTimeout: _submissionTimeout,
          receiveTimeout: _submissionTimeout,
          validateStatus: (_) => true,
        ),
      );
      if (!mounted) return;

      final status = response.statusCode ?? 0;
      final body = _asMap(response.data);
      if (body != null && body['success'] == true) {
        _completeSubmission();
        return;
      }

      final reason = '${body?['reason'] ?? ''}';
      final partialUpload = reason == 'body_incomplete' || reason == 'upload_partial';
      final transient = partialUpload ||
          (status != 413 &&
              (status == 408 ||
                  status == 429 ||
                  status >= 500 ||
                  (status >= 200 && status < 300 && body == null)));
      if (transient) {
        await _verifyThenRetry(attempt, partialUpload, _apiMessage(body, status, partialUpload));
        return;
      }
      _failSubmission(_apiMessage(body, status, false));
    } on DioException {
      if (!mounted) return;
      await _verifyThenRetry(attempt, false, _connectionMessage);
    } catch (_) {
      if (!mounted) return;
      _failSubmission(_genericMessage);
    }
  }

  /// After an interrupted send, ask the server whether the application was
  /// saved before repeating it — so a slow connection never creates a duplicate.
  Future<void> _verifyThenRetry(int attempt, bool partialUpload, String message) async {
    setState(() => _phase = _SubmitPhase.verifying);
    try {
      final response = await _dio.get<dynamic>(
        _submitUrl,
        queryParameters: {'status_token': _submissionToken},
        options: Options(
          sendTimeout: _statusTimeout,
          receiveTimeout: _statusTimeout,
          validateStatus: (_) => true,
        ),
      );
      final body = _asMap(response.data);
      if (body != null && body['success'] == true && body['saved'] == true) {
        if (mounted) _completeSubmission();
        return;
      }
    } catch (_) {
      // Could not verify; fall through to a single retry.
    }
    if (!mounted) return;
    if (attempt == 0) {
      await _sendApplication(attempt: 1, recovery: partialUpload);
      return;
    }
    _failSubmission(message);
  }

  void _completeSubmission() {
    setState(() {
      _phase = _SubmitPhase.idle;
      _sent = true;
      _submitError = '';
      _submissionToken = '';
    });
    _scrollTo('success');
  }

  void _failSubmission(String message) {
    setState(() {
      _phase = _SubmitPhase.idle;
      _submitError = message;
    });
  }

  String get _genericMessage =>
      _isAr ? 'حدث خطأ، حاول مجدداً' : 'Something went wrong. Please try again.';

  String get _connectionMessage => _isAr
      ? 'تعذر الوصول إلى خادم التوظيف بعد التحقق التلقائي. بياناتك ما زالت محفوظة؛ انتظر لحظات ثم اضغط إرسال مرة أخرى.'
      : 'The careers server could not be reached after automatic verification. Your details are still saved; wait a moment, then press Send again.';

  /// Prefers the API's own validation message, then falls back by status code.
  String _apiMessage(Map<String, dynamic>? body, int status, bool partialUpload) {
    final reference = '${body?['reference'] ?? ''}'.trim();
    final referenceSuffix =
        reference.isEmpty ? '' : ' (${_isAr ? 'رقم المتابعة' : 'Reference'}: $reference)';

    if (partialUpload) {
      return (_isAr
              ? 'لم نتمكن من تأكيد استلام الطلب كاملًا بعد إعادة المحاولة. احتفظ بالصفحة مفتوحة ثم اضغط إرسال مرة أخرى؛ لن يتكرر الطلب إذا كان قد وصل.'
              : 'We could not confirm receipt of the complete application after retrying. Keep this page open and press Send again. An application already received will not be duplicated.') +
          referenceSuffix;
    }
    final apiError = '${body?['error'] ?? ''}'.trim();
    if (apiError.isNotEmpty) return apiError + referenceSuffix;
    if (status == 413) {
      return _isAr
          ? 'حجم الملفات المرفوعة أكبر من المسموح على السيرفر. صغّر الصور أو ملف PDF ثم أعد الإرسال.'
          : 'The attached files exceed the server upload limit. Reduce the image or PDF sizes and try again.';
    }
    if (status == 0 || status == 408 || status == 429 || status == 504 || (status >= 200 && status < 300)) {
      return _connectionMessage;
    }
    if (status >= 500) {
      return _isAr
          ? 'تعذر حفظ الطلب على السيرفر حاليًا. حاول مرة أخرى بعد قليل.'
          : 'The server could not save the application right now. Please try again shortly.';
    }
    return _genericMessage;
  }

  void _reset() {
    for (final c in _controllers) {
      c.clear();
    }
    _interviewDays = _buildInterviewDays();
    setState(() {
      _birthDate = '';
      _selectedJob = null;
      _experienceLevel = '';
      _gender = '';
      _maritalStatus = '';
      _employmentStatus = '';
      _address = '';
      _englishLevel = '';
      _computerSkill = '';
      _cameraAvailable = '';
      _videoEditing = '';
      _ugc = '';
      _workUnderPressure = '';
      _availability = '';
      _selectFirstInterviewSlot();
      _photo = null;
      _idFront = null;
      _idBack = null;
      _cvFile = null;
      _submissionToken = '';
      _phase = _SubmitPhase.idle;
      _sent = false;
      _submitError = '';
      _jobError = _expError = _photoError = _nameError = _ageError = _educationError = false;
      _genderError = _maritalError = _addressError = _emailError = _waError = false;
      _portfolioError = _linkedinError = _skillsError = _employmentError = false;
      _interviewError = _idFrontError = _idBackError = _coverError = false;
    });
    _scrollController.jumpTo(0);
  }

  void _scrollToForm() => _scrollTo('form');

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isAr = _isAr;
    final job = _selectedJob;
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
              // Intro banner (jumps to the form)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  child: _CareersIntroBanner(isArabic: isAr, onTap: _scrollToForm),
                ),
              ),
              // Job selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: _JobSelector(
                    jobs: _jobs,
                    selected: job,
                    isArabic: isAr,
                    onSelect: (j) => setState(() {
                      _selectedJob = j;
                      _jobError = false;
                    }),
                  ),
                ),
              ),
              // Body: job detail + form
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 40.h),
                sliver: SliverToBoxAdapter(
                  child: _sent
                      ? _keyed(
                          'success',
                          _SuccessCard(
                            name: _nameCtrl.text.trim(),
                            isArabic: isAr,
                            interview: _interviewSummary(isAr),
                            onReset: _reset,
                          ),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final form = _keyed('form', _buildForm(isAr));
                            if (job == null) return form;
                            // Two-column on tablet (>= 600)
                            if (constraints.maxWidth >= 600) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.42,
                                    child: _JobDetailCard(job: job, isArabic: isAr),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(child: form),
                                ],
                              );
                            }
                            // Single column on phone
                            return Column(
                              children: [
                                _JobDetailCard(job: job, isArabic: isAr),
                                SizedBox(height: 16.h),
                                form,
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

  List<DropdownMenuItem<String>> _optItems(List<_Opt> options, bool isAr) => [
        for (final o in options) DropdownMenuItem(value: o.value, child: Text(isAr ? o.ar : o.en)),
      ];

  Widget _skillDropdown({
    required bool isAr,
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    final error = _skillsError && value.isEmpty;
    return _Label(
      text: label,
      required: true,
      hasError: error,
      errorText: isAr ? 'يرجى اختيار المستوى' : 'Select a level',
      child: _Dropdown<String>(
        value: value.isEmpty ? null : value,
        hint: isAr ? 'اختر المستوى' : 'Select a level',
        hasError: error,
        items: _optItems(_skillLevels, isAr),
        onChanged: (v) {
          if (v != null) setState(() => onChanged(v));
        },
      ),
    );
  }

  Widget _buildForm(bool isAr) {
    final c = context.etbalyColors;
    final optional = isAr ? 'اختياري' : 'Optional';
    final job = _selectedJob;

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
                // Job
                _keyed(
                  'job',
                  _Label(
                    text: isAr ? 'الوظيفة المتقدم إليها' : 'Position applied for',
                    required: true,
                    hasError: _jobError,
                    errorText: isAr ? 'يرجى اختيار الوظيفة المتقدم إليها' : 'Please select the position you are applying for',
                    child: _Dropdown<_Job>(
                      value: job,
                      hint: isAr ? 'اختر الوظيفة المتقدم إليها' : 'Select the position you are applying for',
                      hasError: _jobError,
                      items: _jobs
                          .map((j) => DropdownMenuItem(
                              value: j,
                              child: Row(children: [
                                Icon(j.icon, color: j.color, size: 15.sp),
                                SizedBox(width: 6.w),
                                Expanded(child: Text(j.title, overflow: TextOverflow.ellipsis)),
                              ])))
                          .toList(),
                      onChanged: (j) => setState(() {
                        _selectedJob = j;
                        _jobError = false;
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Years of experience
                _keyed(
                  'exp',
                  _Label(
                    text: isAr ? 'سنوات الخبرة' : 'Years of experience',
                    required: true,
                    hasError: _expError,
                    errorText: isAr ? 'يرجى اختيار سنوات الخبرة' : 'Please select your years of experience',
                    child: _Dropdown<String>(
                      value: _experienceLevel.isEmpty ? null : _experienceLevel,
                      hint: isAr ? 'اختر سنوات الخبرة' : 'Select your years of experience',
                      hasError: _expError,
                      items: _optItems(_expOptions, isAr),
                      onChanged: (v) => setState(() {
                        _experienceLevel = v ?? '';
                        _expError = false;
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Personal Photo
                _keyed(
                  'photo',
                  _PhotoSection(
                    photo: _photo,
                    hasError: _photoError,
                    isArabic: isAr,
                    onPick: _pickPhoto,
                    onRemove: () => setState(() => _photo = null),
                  ),
                ),
                SizedBox(height: 16.h),

                // Full name
                _keyed(
                  'name',
                  _Label(
                    text: isAr ? 'الاسم الكامل' : 'Full name',
                    required: true,
                    hasError: _nameError,
                    errorText: isAr ? 'الاسم مطلوب (حرفين على الأقل)' : 'Name is required (at least 2 characters)',
                    child: _Field(
                      controller: _nameCtrl,
                      hint: isAr ? 'اكتب اسمك الكامل' : 'Enter your full name',
                      icon: Icons.person_outline_rounded,
                      hasError: _nameError,
                      onChanged: (_) {
                        if (_nameError) setState(() => _nameError = false);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Date of birth (the age is worked out from it)
                _keyed(
                  'age',
                  BirthdayField(
                    value: _birthDate,
                    today: _cairoNow(),
                    isArabic: isAr,
                    label: isAr ? 'تاريخ الميلاد' : 'Date of birth',
                    hint: isAr
                        ? 'اكتب اليوم والشهر والسنة — يجب أن يكون السن من 18 إلى 40 سنة.'
                        : 'Type the day, month and year — applicants must be 18 to 40 years old.',
                    invalid: _ageError,
                    errorText: _birthDate.isEmpty
                        ? (isAr
                            ? 'اكتب تاريخ ميلادك كاملًا (يوم وشهر وسنة).'
                            : 'Enter your full date of birth (day, month and year).')
                        : (isAr
                            ? 'يجب أن يكون السن من 18 إلى 40 سنة'
                            : 'Age must be between 18 and 40 years'),
                    onChanged: (iso) => setState(() {
                      _birthDate = iso;
                      // Half-typed is just unfinished; only a complete date can be out of range.
                      _ageError = iso.isNotEmpty && !_validBirthDate(iso);
                    }),
                  ),
                ),
                SizedBox(height: 12.h),

                // Education
                _keyed(
                  'education',
                  _Label(
                    text: isAr ? 'التعليم' : 'Education',
                    required: true,
                    hasError: _educationError,
                    errorText: isAr ? 'يرجى إدخال المؤهل التعليمي (حرفين على الأقل)' : 'Enter your education (at least 2 characters)',
                    child: _Field(
                      controller: _educationCtrl,
                      hint: isAr ? 'مثال: بكالوريوس تجارة' : "Example: Bachelor's degree",
                      icon: Icons.school_outlined,
                      hasError: _educationError,
                      onChanged: (_) {
                        if (_educationError) setState(() => _educationError = false);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Gender + Marital status
                _TwoCol(
                  left: _keyed(
                    'gender',
                    _Label(
                      text: isAr ? 'النوع' : 'Gender',
                      required: true,
                      hasError: _genderError,
                      errorText: isAr ? 'يرجى اختيار النوع' : 'Select your gender',
                      child: _Dropdown<String>(
                        value: _gender.isEmpty ? null : _gender,
                        hint: isAr ? 'اختر النوع' : 'Select gender',
                        hasError: _genderError,
                        items: _optItems(_genderOptions, isAr),
                        onChanged: (v) => setState(() {
                          _gender = v ?? '';
                          _genderError = false;
                        }),
                      ),
                    ),
                  ),
                  right: _keyed(
                    'marital',
                    _Label(
                      text: isAr ? 'الحالة الاجتماعية' : 'Marital status',
                      required: true,
                      hasError: _maritalError,
                      errorText: isAr ? 'يرجى اختيار الحالة الاجتماعية' : 'Select your marital status',
                      child: _Dropdown<String>(
                        value: _maritalStatus.isEmpty ? null : _maritalStatus,
                        hint: _gender.isEmpty
                            ? (isAr ? 'اختر النوع أولاً' : 'Select gender first')
                            : (isAr ? 'اختر الحالة' : 'Select status'),
                        hasError: _maritalError,
                        items: [
                          for (final m in _maritalOptions)
                            DropdownMenuItem(value: m.value, child: Text(m.label(isAr, _gender))),
                        ],
                        onChanged: (v) => setState(() {
                          _maritalStatus = v ?? '';
                          _maritalError = false;
                        }),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Governorate (readonly) + Area
                _TwoCol(
                  left: _Label(
                    text: isAr ? 'المحافظة' : 'Governorate',
                    child: _ReadOnlyField(
                      text: isAr ? 'الإسكندرية' : 'Alexandria',
                      icon: Icons.location_city_outlined,
                    ),
                  ),
                  right: _keyed(
                    'address',
                    _Label(
                      text: isAr ? 'منطقة السكن داخل الإسكندرية' : 'Residential area in Alexandria',
                      required: true,
                      hasError: _addressError,
                      errorText: isAr ? 'يرجى اختيار منطقة السكن داخل الإسكندرية' : 'Select your residential area in Alexandria',
                      child: _Dropdown<String>(
                        value: _address.isEmpty ? null : _address,
                        hint: isAr ? 'اختر منطقتك' : 'Select area',
                        hasError: _addressError,
                        items: _alexandriaAreas
                            .map((a) => DropdownMenuItem(value: a.value, child: Text(isAr ? a.ar : a.en)))
                            .toList(),
                        onChanged: (v) => setState(() {
                          _address = v ?? '';
                          _addressError = false;
                        }),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Company location info card
                _InfoCard(
                  icon: Icons.location_on_rounded,
                  color: const Color(0xFF6F3FF5),
                  title: isAr ? 'مقر الشركة' : 'Company location',
                  body: isAr ? 'العجمي، أبو يوسف، الإسكندرية، مصر' : 'Abu Yusuf, Al Agamy, Alexandria, Egypt',
                  actionLabel: isAr ? 'عرض على الخريطة' : 'View on Google Maps',
                  onAction: () => UrlLauncherService.instance.launch(_companyMapUrl),
                ),
                SizedBox(height: 8.h),

                // Office hours info card
                _InfoCard(
                  icon: Icons.access_time_rounded,
                  color: const Color(0xFFD4AF37),
                  title: isAr ? 'ساعات العمل المكتبية' : 'Office working hours',
                  body: isAr
                      ? 'من السبت إلى الخميس  |  12 م - 9 م  |  الجمعة إجازة'
                      : 'Saturday to Thursday  |  12 PM - 9 PM  |  Friday is off',
                ),
                SizedBox(height: 16.h),

                // Email (optional)
                _keyed(
                  'email',
                  _Label(
                    text: isAr ? 'البريد الإلكتروني' : 'Email address',
                    optionalLabel: optional,
                    hasError: _emailError,
                    errorText: isAr ? 'بريد إلكتروني غير صحيح' : 'Enter a valid email address',
                    child: _Field(
                      controller: _emailCtrl,
                      hint: 'email@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      hasError: _emailError,
                      onChanged: (_) {
                        if (_emailError) setState(() => _emailError = false);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // WhatsApp
                _keyed(
                  'whatsapp',
                  _Label(
                    text: isAr ? 'واتساب' : 'WhatsApp',
                    required: true,
                    hasError: _waError,
                    errorText: isAr
                        ? 'رقم واتساب يجب أن يتكون من 11 رقمًا فقط ويبدأ بـ 010 أو 011 أو 012 أو 015'
                        : 'WhatsApp number must contain exactly 11 digits and start with 010, 011, 012, or 015',
                    child: _Field(
                      controller: _whatsappCtrl,
                      hint: '01xxxxxxxxx',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: const [_DigitsFormatter(11)],
                      hasError: _waError,
                      onChanged: (v) => setState(() {
                        final digits = _latinDigits(v);
                        _waError = digits.isNotEmpty && !_validMobile(digits);
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Portfolio (optional)
                _keyed(
                  'portfolio',
                  _Label(
                    text: isAr ? 'رابط البورتفوليو' : 'Portfolio link',
                    optionalLabel: optional,
                    hasError: _portfolioError,
                    errorText: isAr ? 'أدخل رابطًا صحيحًا يبدأ بـ http:// أو https://' : 'Enter a valid link starting with http:// or https://',
                    child: _Field(
                      controller: _portfolioCtrl,
                      hint: 'https://your-portfolio.com',
                      icon: Icons.link_rounded,
                      keyboardType: TextInputType.url,
                      hasError: _portfolioError,
                      onChanged: (_) {
                        if (_portfolioError) setState(() => _portfolioError = false);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // LinkedIn (optional)
                _keyed(
                  'linkedin',
                  _Label(
                    text: isAr ? 'رابط لينكد إن' : 'LinkedIn link',
                    optionalLabel: optional,
                    hasError: _linkedinError,
                    errorText: isAr ? 'أدخل رابطًا صحيحًا من موقع linkedin.com فقط' : 'Enter a valid linkedin.com link only',
                    child: _Field(
                      controller: _linkedinCtrl,
                      hint: 'https://linkedin.com/in/username',
                      icon: Icons.business_center_outlined,
                      keyboardType: TextInputType.url,
                      hasError: _linkedinError,
                      onChanged: (_) {
                        if (_linkedinError) setState(() => _linkedinError = false);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Qualifications header
                _keyed(
                  'skills',
                  _SectionHeader(
                    icon: Icons.tune_rounded,
                    text: isAr ? 'بيانات المهارات والتوفر' : 'Skills and availability',
                  ),
                ),
                SizedBox(height: 12.h),

                _TwoCol(
                  left: _skillDropdown(
                    isAr: isAr,
                    label: isAr ? 'اللغة الإنجليزية' : 'English language',
                    value: _englishLevel,
                    onChanged: (v) => _englishLevel = v,
                  ),
                  right: _skillDropdown(
                    isAr: isAr,
                    label: 'Computer',
                    value: _computerSkill,
                    onChanged: (v) => _computerSkill = v,
                  ),
                ),
                SizedBox(height: 10.h),
                _TwoCol(
                  left: _skillDropdown(
                    isAr: isAr,
                    label: 'Camera',
                    value: _cameraAvailable,
                    onChanged: (v) => _cameraAvailable = v,
                  ),
                  right: _skillDropdown(
                    isAr: isAr,
                    label: 'Video editing',
                    value: _videoEditing,
                    onChanged: (v) => _videoEditing = v,
                  ),
                ),
                SizedBox(height: 10.h),
                _TwoCol(
                  left: _skillDropdown(
                    isAr: isAr,
                    label: 'UGC',
                    value: _ugc,
                    onChanged: (v) => _ugc = v,
                  ),
                  right: _Label(
                    text: 'Work under pressure',
                    required: true,
                    hasError: _skillsError && _workUnderPressure.isEmpty,
                    errorText: isAr ? 'يرجى اختيار الإجابة' : 'Select an answer',
                    child: _Dropdown<String>(
                      value: _workUnderPressure.isEmpty ? null : _workUnderPressure,
                      hint: isAr ? 'اختر الإجابة' : 'Select an answer',
                      hasError: _skillsError && _workUnderPressure.isEmpty,
                      items: _optItems(_yesNoOptions, isAr),
                      onChanged: (v) => setState(() => _workUnderPressure = v ?? ''),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _Label(
                  text: isAr ? 'متاح للعمل' : 'Available for',
                  required: true,
                  hasError: _skillsError && _availability.isEmpty,
                  errorText: isAr ? 'يرجى اختيار نوع التوفر للعمل' : 'Select your work availability',
                  child: _Dropdown<String>(
                    value: _availability.isEmpty ? null : _availability,
                    hint: isAr ? 'اختر نوع التوفر للعمل' : 'Select your work availability',
                    hasError: _skillsError && _availability.isEmpty,
                    items: _optItems(_availabilityOptions, isAr),
                    onChanged: (v) => setState(() => _availability = v ?? ''),
                  ),
                ),
                SizedBox(height: 10.h),
                _keyed(
                  'employment',
                  _Label(
                    text: isAr ? 'حالة الوظيفة' : 'Employment status',
                    required: true,
                    hasError: _employmentError,
                    errorText: isAr ? 'يرجى اختيار حالتك الوظيفية' : 'Select your employment status',
                    child: _Dropdown<String>(
                      value: _employmentStatus.isEmpty ? null : _employmentStatus,
                      hint: isAr ? 'اختر حالتك الوظيفية' : 'Select your employment status',
                      hasError: _employmentError,
                      items: _optItems(_employmentOptions, isAr),
                      onChanged: (v) => setState(() {
                        _employmentStatus = v ?? '';
                        _employmentError = false;
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Interview appointment
                _buildInterview(isAr),
                SizedBox(height: 20.h),

                // Identity documents
                _SectionHeader(
                  icon: Icons.verified_user_outlined,
                  text: isAr ? 'مرفق إثبات الهوية' : 'Identity attachment',
                ),
                SizedBox(height: 10.h),
                _InfoCard(
                  icon: Icons.shield_outlined,
                  color: const Color(0xFF22C55E),
                  title: isAr ? 'ساعدنا نتحقق منك بشكل أفضل' : 'Help us verify you properly',
                  body: isAr
                      ? 'إرسال صورة بطاقة الهوية بوجهيها بيساعدنا نتأكد من بياناتك ونخلص طلبك أسرع، وبتتحفظ عندنا بسرية تامة.'
                      : 'Sending both sides of your ID card helps us confirm your details and process your application faster. It is stored in strict confidence.',
                ),
                SizedBox(height: 8.h),
                _InfoCard(
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFF59E0B),
                  title: isAr ? 'برجاء وللأهمية القصوى' : 'Extremely important',
                  body: isAr
                      ? 'عند حضورك الإنترفيو لازم يكون معاك مستندات مثبتة للشخصية: البطاقة الشخصية، وشهادة المؤهل الدراسي، وللذكور شهادة الجيش.'
                      : 'You must bring your identification documents to the interview: the national ID card, your education certificate, and for male applicants the military service certificate.',
                ),
                SizedBox(height: 12.h),
                _keyed(
                  'idFront',
                  _DocUpload(
                    label: isAr ? 'صورة البطاقة الشخصية - الوجه' : 'National ID card image - front side',
                    hint: isAr ? 'ارفع وجه البطاقة الشخصية' : 'Upload the ID front side',
                    formats: 'JPEG / PNG / WEBP',
                    image: _idFront,
                    hasError: _idFrontError,
                    errorText: isAr
                        ? 'صورة وجه البطاقة مطلوبة بصيغة JPEG أو PNG أو WEBP'
                        : 'The ID front-side image is required in JPEG, PNG, or WEBP format.',
                    icon: Icons.badge_outlined,
                    onPick: () => _pickIdCard(front: true),
                    onRemove: () => setState(() => _idFront = null),
                  ),
                ),
                SizedBox(height: 12.h),
                _keyed(
                  'idBack',
                  _DocUpload(
                    label: isAr ? 'صورة البطاقة الشخصية - الظهر' : 'National ID card image - back side',
                    hint: isAr ? 'ارفع ظهر البطاقة الشخصية' : 'Upload the ID back side',
                    formats: 'JPEG / PNG / WEBP',
                    image: _idBack,
                    hasError: _idBackError,
                    errorText: isAr
                        ? 'صورة ظهر البطاقة مطلوبة بصيغة JPEG أو PNG أو WEBP'
                        : 'The ID back-side image is required in JPEG, PNG, or WEBP format.',
                    icon: Icons.credit_card_outlined,
                    onPick: () => _pickIdCard(front: false),
                    onRemove: () => setState(() => _idBack = null),
                  ),
                ),
                SizedBox(height: 20.h),

                // Open fields
                _Label(
                  text: 'Skills',
                  child: _Field(
                    controller: _skillsCtrl,
                    hint: isAr ? 'اكتب أهم مهاراتك العملية والتقنية' : 'Write your key practical and technical skills',
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 12.h),
                _Label(
                  text: 'Experience',
                  child: _Field(
                    controller: _experienceCtrl,
                    hint: isAr ? 'اكتب خبراتك السابقة باختصار' : 'Briefly write your previous experience',
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 12.h),
                _Label(
                  text: 'Achievements',
                  child: _Field(
                    controller: _achievementsCtrl,
                    hint: isAr ? 'اكتب أهم إنجازاتك أو أعمالك السابقة' : 'Write your key achievements or previous work',
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 12.h),
                _keyed(
                  'cover',
                  _Label(
                    text: isAr ? 'رسالة التعريف' : 'Cover letter',
                    required: true,
                    hasError: _coverError,
                    errorText: isAr ? 'رسالة التعريف مطلوبة (20 حرف على الأقل)' : 'Cover letter is required (at least 20 characters)',
                    child: _Field(
                      controller: _coverCtrl,
                      hint: isAr
                          ? 'اكتب باختصار عن نفسك، خبراتك، وسبب اهتمامك بهذه الوظيفة...'
                          : 'Briefly tell us about yourself, your experience, and why this role interests you...',
                      maxLines: 5,
                      hasError: _coverError,
                      onChanged: (_) {
                        if (_coverError) setState(() => _coverError = false);
                      },
                    ),
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
                  label: isAr ? 'إرسال الطلب' : 'Send application',
                  submitting: _submitting,
                  submittingLabel: switch (_phase) {
                    _SubmitPhase.verifying => isAr ? 'جاري تأكيد وصول طلبك...' : 'Confirming that your application arrived...',
                    _SubmitPhase.retrying => isAr ? 'جاري استكمال الإرسال بأمان...' : 'Completing the submission securely...',
                    _ => isAr ? 'جاري الإرسال...' : 'Sending...',
                  },
                  isArabic: isAr,
                  onTap: _submit,
                ),
                if (_submitError.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  _ErrorNote(_submitError),
                ],
                SizedBox(height: 6.h),
                const EtbalyPrivacyLink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterview(bool isAr) {
    final c = context.etbalyColors;
    final accent = c.primary;
    final slots = _selectedDay?.slots ?? const <_InterviewSlot>[];
    const red = Color(0xFFEF4444);
    final summary = _interviewSummary(isAr);

    return _keyed(
      'interview',
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.06),
          border: Border.all(color: _interviewError ? red : accent.withValues(alpha: 0.28)),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Center(child: Icon(Icons.event_available_rounded, color: accent, size: 20.sp)),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'اختيار موعد المقابلة' : 'Interview scheduling',
                        style: TextStyle(color: c.textMuted, fontSize: 10.sp, fontWeight: FontWeight.w700),
                      ),
                      Row(children: [
                        Text(
                          isAr ? 'موعد الانترفيو' : 'Interview appointment',
                          style: TextStyle(color: c.textMain, fontSize: 14.sp, fontWeight: FontWeight.w900),
                        ),
                        Text(' *', style: TextStyle(color: red, fontSize: 13.sp, fontWeight: FontWeight.w900)),
                      ]),
                      SizedBox(height: 3.h),
                      Text(
                        isAr
                            ? 'اختر موعدك المتاح؛ مواعيد الثلاثاء من 4 إلى 8 مساءً، والخميس من 2 إلى 6 مساءً.'
                            : 'Choose an available appointment: Tuesday from 4 to 8 PM and Thursday from 2 to 6 PM.',
                        style: TextStyle(color: c.textMuted, fontSize: 11.sp, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.groups_rounded, color: accent, size: 15.sp),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    isAr
                        ? 'اختر الموعد الأنسب لك، وسيتم تأكيد تفاصيل المقابلة معك عبر واتساب.'
                        : 'Choose the appointment that suits you best; the interview details will be confirmed with you via WhatsApp.',
                    style: TextStyle(color: c.textMuted, fontSize: 11.sp, height: 1.5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _Label(
              text: isAr ? 'يوم المقابلة' : 'Interview day',
              required: true,
              child: _Dropdown<String>(
                value: _interviewDate.isEmpty ? null : _interviewDate,
                hasError: _interviewError,
                items: [
                  for (final day in _interviewDays)
                    DropdownMenuItem(
                      value: day.value,
                      child: Text(day.label(isAr), overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: _onInterviewDayChanged,
              ),
            ),
            SizedBox(height: 10.h),
            _Label(
              text: isAr ? 'فترة المقابلة' : 'Interview time',
              required: true,
              child: _Dropdown<String>(
                value: _interviewTime.isEmpty ? null : _interviewTime,
                hasError: _interviewError,
                items: [
                  for (final slot in slots)
                    DropdownMenuItem(value: slot.value, child: Text(slot.label(isAr))),
                ],
                onChanged: (v) => setState(() {
                  _interviewTime = v ?? '';
                  _interviewError = false;
                }),
              ),
            ),
            if (summary.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, color: const Color(0xFF22C55E), size: 16.sp),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: isAr ? 'موعدك المختار: ' : 'Selected appointment: ',
                          style: TextStyle(color: c.textMuted, fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: summary,
                          style: TextStyle(color: c.textMain, fontWeight: FontWeight.w900),
                        ),
                      ]),
                      style: TextStyle(fontSize: 11.sp, height: 1.5),
                    ),
                  ),
                ],
              ),
            ],
            if (_interviewError) ...[
              SizedBox(height: 8.h),
              _ErrorNote(isAr
                  ? 'اختيار يوم وموعد صحيح للمقابلة مطلوب لإرسال الطلب'
                  : 'A valid interview day and time are required to submit your application.'),
            ],
          ],
        ),
      ),
    );
  }
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
                    isArabic ? 'الوظائف المتاحة' : 'Open Roles',
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
                      : 'We are looking for people who care about digital marketing, design, and building experiences that help brands grow with confidence.',
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

// ─── Intro banner ─────────────────────────────────────────────────────────────

/// The banner artwork from the website; tapping it jumps to the application form.
class _CareersIntroBanner extends StatelessWidget {
  const _CareersIntroBanner({required this.isArabic, required this.onTap});
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final label = isArabic ? 'انضم إلى فريق اطبعلي والوظائف المتاحة' : 'Join the Etbaly team and explore available jobs';

    return Semantics(
      button: true,
      label: isArabic ? 'انتقل إلى نموذج التقديم للوظائف' : 'Go to the careers application form',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: c.bgCard,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: c.gold.withValues(alpha: 0.35)),
            boxShadow: [BoxShadow(color: c.primary.withValues(alpha: 0.16), blurRadius: 22.r, offset: Offset(0, 8.h))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1917 / 821,
                child: Image.asset(
                  AppAssets.careersIntro(isArabic: isArabic, isDark: context.isDarkMode),
                  fit: BoxFit.cover,
                  semanticLabel: label,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: c.borderColor))),
                child: Row(
                  children: [
                    Icon(Icons.send_rounded, color: c.gold, size: 17.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        isArabic ? 'اضغط هنا وانتقل مباشرة إلى نموذج التقديم' : 'Click here to go directly to the application form',
                        style: TextStyle(color: c.textMain, fontSize: 12.sp, fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward_rounded, color: c.gold, size: 18.sp),
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

// ─── Job Selector ─────────────────────────────────────────────────────────────

class _JobSelector extends StatelessWidget {
  const _JobSelector({required this.jobs, required this.selected, required this.isArabic, required this.onSelect});
  final List<_Job> jobs;
  final _Job? selected;
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
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: [
                          _Chip(_valueLabel(job.type, isArabic), Icons.work_outline_rounded, job.color),
                          _Chip(_valueLabel(job.location, isArabic), Icons.place_outlined, job.color),
                          _Chip(_valueLabel(job.experience, isArabic), Icons.star_border_rounded, const Color(0xFFD4AF37)),
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
                  isArabic ? 'أرسل بياناتك وسيتواصل معك فريقنا خلال 48 ساعة' : 'Send your details and our team will contact you within 48 hours.',
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
    required this.photo,
    required this.hasError,
    required this.isArabic,
    required this.onPick,
    required this.onRemove,
  });
  final _PickedImage? photo;
  final bool hasError;
  final bool isArabic;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final ar = isArabic;
    final bytes = photo?.bytes;
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
                    ? Image.memory(bytes, fit: BoxFit.cover)
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
                    ar
                        ? 'صورة واضحة للوجه • مربعة بنسبة 1:1 • JPEG أو PNG أو WEBP • يتم تحسين حجمها تلقائيًا لتسريع الإرسال'
                        : 'Clear face photo • Square 1:1 ratio • JPEG, PNG, or WEBP • Automatically optimized for a faster upload',
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
          _ErrorNote(ar
              ? 'الصورة الشخصية مطلوبة بصيغة JPEG أو PNG أو WEBP'
              : 'A personal photo is required in JPEG, PNG, or WEBP format.'),
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
  const _GoldButton({
    required this.label,
    required this.submitting,
    required this.submittingLabel,
    required this.isArabic,
    required this.onTap,
  });
  final String label;
  final bool submitting;
  final String submittingLabel;
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
                    Flexible(
                      child: Text(
                        submittingLabel,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: const Color(0xFF1a0a3a), fontSize: 14.sp, fontWeight: FontWeight.w900),
                      ),
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
  const _SuccessCard({required this.name, required this.isArabic, required this.interview, required this.onReset});
  final String name;
  final bool isArabic;
  final String interview;
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
            ar ? 'تم إرسال طلبك بنجاح' : 'Your application was sent successfully',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textMain, fontSize: 22.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10.h),
          Text(
            ar
                ? 'شكراً ${name.isNotEmpty ? name : ""} على تقديمك. فريقنا سيراجع طلبك ويتواصل معك خلال 48 ساعة عبر واتساب أو البريد الإلكتروني.'
                : 'Thank you${name.isNotEmpty ? " $name" : ""} for applying. Our team will review your application and contact you within 48 hours via WhatsApp or email.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textMuted, fontSize: 14.sp, height: 1.65),
          ),
          if (interview.isNotEmpty) ...[
            SizedBox(height: 18.h),
            _InfoCard(
              icon: Icons.event_available_rounded,
              color: const Color(0xFF22C55E),
              title: ar ? 'موعدك المختار:' : 'Selected appointment:',
              body: interview,
            ),
          ],
          SizedBox(height: 10.h),
          _InfoCard(
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFFF59E0B),
            title: ar ? 'برجاء وللأهمية القصوى' : 'Extremely important',
            body: ar
                ? 'عند حضورك الإنترفيو لازم يكون معاك مستندات مثبتة للشخصية: البطاقة الشخصية، وشهادة المؤهل الدراسي، وللذكور شهادة الجيش.'
                : 'You must bring your identification documents to the interview: the national ID card, your education certificate, and for male applicants the military service certificate.',
          ),
          SizedBox(height: 28.h),
          OutlinedButton.icon(
            onPressed: onReset,
            icon: Icon(Icons.refresh_rounded, size: 18.sp),
            label: Text(ar ? 'العودة للوظائف' : 'Back to jobs'),
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
  const _Label({
    required this.text,
    required this.child,
    this.required = false,
    this.optionalLabel,
    this.hasError = false,
    this.errorText,
  });
  final String text;
  final Widget child;
  final bool required;
  final String? optionalLabel;
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
          if (optionalLabel != null)
            Text(
              optionalLabel!,
              style: TextStyle(color: c.textLight, fontSize: 10.sp, fontWeight: FontWeight.w700),
            ),
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
    this.inputFormatters,
    this.maxLines = 1,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool hasError;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: maxLines > 1 ? maxLines : 1,
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
      // The field only reads `initialValue` once, so re-create it whenever the
      // value changes from outside (chips, form reset, interview day switch).
      key: ValueKey(value),
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
  const _InfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

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
                if (actionLabel != null) ...[
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: onAction,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined, color: color, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          actionLabel!,
                          style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.open_in_new_rounded, color: color, size: 12.sp),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: c.bgSubtle,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: c.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17.sp, color: c.textLight),
          SizedBox(width: 10.w),
          Expanded(child: Text(text, style: TextStyle(color: c.textMain, fontSize: 13.sp))),
        ],
      ),
    );
  }
}

/// Upload box for an image attachment (ID card side) with a thumbnail preview.
class _DocUpload extends StatelessWidget {
  const _DocUpload({
    required this.label,
    required this.hint,
    required this.formats,
    required this.image,
    required this.hasError,
    required this.errorText,
    required this.icon,
    required this.onPick,
    required this.onRemove,
  });
  final String label;
  final String hint;
  final String formats;
  final _PickedImage? image;
  final bool hasError;
  final String errorText;
  final IconData icon;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    const red = Color(0xFFEF4444);
    final picked = image;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: hasError ? red : c.textMain, fontSize: 11.sp, fontWeight: FontWeight.w900),
            ),
          ),
          Text(' *', style: TextStyle(color: red, fontSize: 13.sp, fontWeight: FontWeight.w900)),
        ]),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: picked == null ? onPick : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: hasError ? const Color(0x0CEF4444) : c.bgSubtle,
              border: Border.all(color: hasError ? red : c.primary.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: picked == null
                ? Column(
                    children: [
                      Icon(icon, color: hasError ? red : c.primary, size: 28.sp),
                      SizedBox(height: 6.h),
                      Text(
                        hint,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: c.textMain, fontSize: 12.sp, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 2.h),
                      Text(formats, style: TextStyle(color: c.textMuted, fontSize: 11.sp)),
                    ],
                  )
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.memory(picked.bytes, width: 48.w, height: 48.w, fit: BoxFit.cover),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              picked.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: c.textMain, fontSize: 12.sp, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              _formatBytes(picked.bytes.length),
                              style: TextStyle(color: c.textMuted, fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: Icon(Icons.close_rounded, color: red, size: 20.sp),
                      ),
                    ],
                  ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: 4.h),
          _ErrorNote(errorText),
        ],
      ],
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

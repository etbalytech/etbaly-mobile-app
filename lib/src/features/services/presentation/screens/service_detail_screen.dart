import 'package:etbaly/src/imports/core_imports.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final service = _details[slug] ?? _details['design']!;

    return Scaffold(
      backgroundColor: colors.bgMain,
      appBar: AppBar(
        backgroundColor: colors.bgCard,
        foregroundColor: colors.textMain,
        elevation: 0,
        title: Text(service.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            EtbalyHero(
              badge: 'تفاصيل الخدمة',
              title: service.title,
              description: service.description,
              icon: service.icon,
              actions: [
                EtbalyActionButton(
                  label: 'اطلب هذه الخدمة',
                  icon: Icons.send,
                  onTap: () => context.go(AppRoutes.contact),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const EtbalyPageSectionHeader(
              badge: 'المحتوى',
              title: 'ماذا تشمل الخدمة؟',
              description:
                  'بدلا من صفحة مؤقتة، كل خدمة لديها تفاصيل عملية مأخوذة من تجربة الموقع ومناسبة للموبايل.',
            ),
            const SizedBox(height: 18),
            ...service.points.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EtbalyInfoCard(
                  title: point.title,
                  description: point.description,
                  icon: point.icon,
                  accent: point.accentGold ? colors.gold : colors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _details = {
  'design': _ServiceDetail(
    title: 'التصميم الإبداعي',
    description:
        'أنظمة بصرية وتصميمات حملات تجعل العلامة تبدو احترافية وواضحة وجاهزة لكل منصة.',
    icon: Icons.brush,
    points: [
      _DetailPoint(
        title: 'هوية بصرية',
        description:
            'اتجاه الشعار، الألوان، الخطوط، قواعد الاستخدام، ومواد الإطلاق.',
        icon: Icons.palette,
      ),
      _DetailPoint(
        title: 'تصميمات السوشيال',
        description: 'قوالب منشورات، ستوري، إعلانات، وتصميمات موجهة للمنتج.',
        icon: Icons.auto_awesome,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'حِزم حملات',
        description: 'باقة تصميم موحدة للعروض الموسمية والإطلاقات.',
        icon: Icons.inventory_2,
      ),
    ],
  ),
  'social': _ServiceDetail(
    title: 'إدارة السوشيال ميديا',
    description:
        'حضور يومي على المنصات من خلال تخطيط محتوى، نشر، متابعة مجتمع، وثبات في هوية العلامة.',
    icon: Icons.groups,
    points: [
      _DetailPoint(
        title: 'جدول محتوى',
        description:
            'تخطيط شهري مبني على الأهداف والجمهور والعروض وصوت العلامة.',
        icon: Icons.calendar_month,
      ),
      _DetailPoint(
        title: 'إدارة المجتمع',
        description: 'توجيه الردود، المتابعة، وتنظيم التصعيد عند الحاجة.',
        icon: Icons.forum,
      ),
      _DetailPoint(
        title: 'تقارير نمو',
        description: 'ملخصات أداء واضحة وتوصيات للخطوات التالية.',
        icon: Icons.insights,
        accentGold: true,
      ),
    ],
  ),
  'ads': _ServiceDetail(
    title: 'الإعلانات المدفوعة',
    description:
        'حملات للوصول والعملاء والمبيعات وإعادة الاستهداف مع اختبار تصميمات ووضوح في الميزانية.',
    icon: Icons.campaign,
    points: [
      _DetailPoint(
        title: 'إعداد الحملة',
        description: 'هيكلة الجمهور، الأهداف، أساسيات التتبع، وفحوصات الإطلاق.',
        icon: Icons.tune,
      ),
      _DetailPoint(
        title: 'اختبار التصميمات',
        description: 'زوايا وأشكال متعددة لمعرفة ما يحقق أفضل تحويل.',
        icon: Icons.science,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'تحسين مستمر',
        description: 'قراءة الأداء، تحريك الميزانية، وإعداد التقارير.',
        icon: Icons.trending_up,
      ),
    ],
  ),
  'web': _ServiceDetail(
    title: 'تطوير المواقع',
    description:
        'مواقع وصفحات هبوط سريعة ومتجاوبة مصممة للتواصل بوضوح وتحويل الزائر إلى عميل.',
    icon: Icons.language,
    points: [
      _DetailPoint(
        title: 'صفحات هبوط',
        description: 'صفحات مركزة للحملات والعروض وجمع العملاء والإطلاقات.',
        icon: Icons.web,
      ),
      _DetailPoint(
        title: 'مواقع شركات',
        description: 'صفحات خدمات، بورتفوليو، تواصل، وهيكلة محتوى.',
        icon: Icons.business_center,
      ),
      _DetailPoint(
        title: 'تجربة موبايل أولا',
        description:
            'واجهات تبدأ من الهاتف وتظهر باحترافية على الشاشات الأكبر.',
        icon: Icons.phone_iphone,
        accentGold: true,
      ),
    ],
  ),
  'mobile-app': _ServiceDetail(
    title: 'تصميم وتطوير تطبيقات موبايل',
    description:
        'نطور تطبيقات موبايل عالية الجودة لأندرويد وiOS بتقنيات حديثة وتجربة مستخدم استثنائية.',
    icon: Icons.phone_iphone,
    points: [
      _DetailPoint(
        title: 'واجهة سهلة وجذابة',
        description:
            'تصميم تجربة استخدام واضحة وسلسة تناسب جمهورك وتدعم أهداف التطبيق.',
        icon: Icons.dashboard_customize,
      ),
      _DetailPoint(
        title: 'تطبيقات أندرويد وiOS',
        description:
            'تطوير تطبيقات متكاملة تعمل باحترافية على المنصات الأساسية للموبايل.',
        icon: Icons.devices,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'دعم وصيانة',
        description:
            'متابعة وتحسينات مستمرة بعد الإطلاق للحفاظ على استقرار التطبيق وتطوره.',
        icon: Icons.support_agent,
      ),
    ],
  ),
  'video': _ServiceDetail(
    title: 'إنتاج الفيديو',
    description:
        'فيديوهات قصيرة، ريلز، إعلانات، ومحتوى موشن للعلامات التي تحتاج لفت الانتباه بسرعة.',
    icon: Icons.play_circle,
    points: [
      _DetailPoint(
        title: 'ريلز وفيديوهات قصيرة',
        description: 'مونتاج مناسب للمنصات مع بداية قوية وإيقاع وترجمة.',
        icon: Icons.movie,
      ),
      _DetailPoint(
        title: 'إعلانات فيديو',
        description: 'نسخ متعددة لاختبار الاستجابة حسب هدف الحملة.',
        icon: Icons.smart_display,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'موشن وأصول متحركة',
        description: 'نصوص متحركة، ظهور شعار، إبراز منتجات، وتسلسلات ستوري.',
        icon: Icons.animation,
      ),
    ],
  ),
  'seo': _ServiceDetail(
    title: 'تحسين محركات البحث',
    description:
        'عمل على الظهور في البحث من خلال الهيكلة والمحتوى والبيانات والتحسينات التقنية العملية.',
    icon: Icons.manage_search,
    points: [
      _DetailPoint(
        title: 'خريطة كلمات مفتاحية',
        description: 'فهم نية البحث وتخطيط الصفحات للجمهور المناسب.',
        icon: Icons.key,
      ),
      _DetailPoint(
        title: 'تحسين داخل الصفحة',
        description: 'العناوين والوصف والروابط والمحتوى والبنية.',
        icon: Icons.article,
      ),
      _DetailPoint(
        title: 'فحوصات تقنية',
        description: 'السرعة، قابلية الفهرسة، الأساسيات المنظمة، وصحة الزحف.',
        icon: Icons.speed,
        accentGold: true,
      ),
    ],
  ),
  'boost': _ServiceDetail(
    title: 'تعزيز السوشيال',
    description:
        'دعم للحسابات والمحتوى الذي يحتاج دفعة ظهور وتفاعل بتوقعات واضحة وباقات منظمة.',
    icon: Icons.bolt,
    points: [
      _DetailPoint(
        title: 'زخم الجمهور',
        description: 'مسارات دعم للوعي والتفاعل وبناء الحضور.',
        icon: Icons.person_add,
      ),
      _DetailPoint(
        title: 'منصات متعددة',
        description: 'إنستجرام، تيك توك، تيليجرام، ومسارات نمو اجتماعي أخرى.',
        icon: Icons.public,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'توجيه الباقة',
        description: 'اختيار المسار المناسب لهدفك وميزانيتك.',
        icon: Icons.view_list,
      ),
    ],
  ),
  'moderator': _ServiceDetail(
    title: 'إدارة التعليقات والرسائل',
    description:
        'متابعة يومية للمحادثات والرسائل والتعليقات للحفاظ على سرعة الرد وجودة تجربة العملاء.',
    icon: Icons.support_agent,
    points: [
      _DetailPoint(
        title: 'ردود منظمة',
        description:
            'صياغة ردود مناسبة لصوت العلامة وتوجيه الأسئلة المتكررة بشكل واضح.',
        icon: Icons.mark_chat_read,
      ),
      _DetailPoint(
        title: 'متابعة العملاء',
        description:
            'فرز المحادثات المهمة وتحويل المهتمين إلى خطوة البيع أو التواصل.',
        icon: Icons.people_alt,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'تقارير تفاعل',
        description:
            'ملخصات لما يتكرر من أسئلة واعتراضات وفرص لتحسين المحتوى والعروض.',
        icon: Icons.fact_check,
      ),
    ],
  ),
  'brand-plan': _ServiceDetail(
    title: 'استراتيجية العلامة',
    description:
        'خطة واضحة للتموضع والرسائل وهيكلة العروض والخطوات التسويقية التالية.',
    icon: Icons.diamond,
    points: [
      _DetailPoint(
        title: 'التموضع',
        description:
            'تحديد من تخدم، لماذا يختارك العميل، وكيف يجب أن تشعر العلامة.',
        icon: Icons.explore,
      ),
      _DetailPoint(
        title: 'الرسائل',
        description: 'لغة العروض، صوت العلامة، وزوايا الحملات.',
        icon: Icons.record_voice_over,
      ),
      _DetailPoint(
        title: 'خريطة النمو',
        description: 'تسلسل عملي للمحتوى والإعلانات والتصميم والويب.',
        icon: Icons.map,
        accentGold: true,
      ),
    ],
  ),
};

class _ServiceDetail {
  const _ServiceDetail({
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<_DetailPoint> points;
}

class _DetailPoint {
  const _DetailPoint({
    required this.title,
    required this.description,
    required this.icon,
    this.accentGold = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool accentGold;
}

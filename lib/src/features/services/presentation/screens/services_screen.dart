import 'package:etbaly/src/imports/core_imports.dart';
import 'package:go_router/go_router.dart';

const etbalyServices = [
  _ServiceItem(
    slug: 'design',
    title: 'التصميم الإبداعي',
    subtitle:
        'هويات بصرية، منشورات سوشيال، تصميمات حملات، وأنظمة هوية احترافية.',
    icon: Icons.brush,
  ),
  _ServiceItem(
    slug: 'social',
    title: 'إدارة السوشيال ميديا',
    subtitle:
        'خطط محتوى، نشر، متابعة، أفكار نمو، وتوجيه كامل لحضورك على المنصات.',
    icon: Icons.groups,
  ),
  _ServiceItem(
    slug: 'ads',
    title: 'الإعلانات المدفوعة',
    subtitle: 'حملات ميتا وجوجل وتيك توك وتحويلات بتقارير واضحة.',
    icon: Icons.campaign,
  ),
  _ServiceItem(
    slug: 'web',
    title: 'تطوير المواقع',
    subtitle:
        'صفحات هبوط، مواقع شركات، مسارات بيع إلكتروني، وتجارب سريعة ومتجاوبة.',
    icon: Icons.language,
  ),
  _ServiceItem(
    slug: 'video',
    title: 'إنتاج الفيديو',
    subtitle: 'ريلز، إعلانات، مونتاج، موشن، ومحتوى قصير مناسب للمنصات الحديثة.',
    icon: Icons.play_circle,
  ),
  _ServiceItem(
    slug: 'seo',
    title: 'تحسين محركات البحث',
    subtitle:
        'إصلاحات تقنية، هيكلة كلمات مفتاحية، توجيه محتوى، وظهور أفضل في البحث.',
    icon: Icons.manage_search,
  ),
  _ServiceItem(
    slug: 'boost',
    title: 'تعزيز السوشيال',
    subtitle: 'باقات دعم للظهور والتفاعل وبناء الجمهور.',
    icon: Icons.bolt,
  ),
  _ServiceItem(
    slug: 'brand-plan',
    title: 'استراتيجية العلامة',
    subtitle: 'تموضع، صوت العلامة، تخطيط إطلاق، وخريطة نمو عملية.',
    icon: Icons.diamond,
  ),
];

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return EtbalyPage(
      children: [
        const EtbalyHero(
          badge: 'الخدمات',
          title: 'خدمات تسويقية تعمل كنظام واحد',
          description:
              'من الهوية إلى الإعلانات والموقع، كل خدمة مصممة لتخدم الخطوة التالية حتى تظهر علامتك بقوة وتنمو بوضوح.',
          icon: Icons.grid_view,
          stats: [
            EtbalyStat(value: '8+', label: 'خدمات أساسية'),
            EtbalyStat(value: '24/7', label: 'دعم أونلاين'),
            EtbalyStat(value: 'A+', label: 'جودة تنفيذ'),
          ],
        ),
        const EtbalyPageSectionHeader(
          badge: 'استكشف',
          title: 'اختر الخدمة',
          description: 'اضغط على أي خدمة لعرض تفاصيلها داخل التطبيق.',
        ),
        ...etbalyServices.map(
          (service) => EtbalyInfoCard(
            title: service.title,
            description: service.subtitle,
            icon: service.icon,
            accent: service.slug == 'ads' || service.slug == 'brand-plan'
                ? colors.gold
                : colors.primary,
            trailing:
                Icon(Icons.arrow_forward_ios, color: colors.gold, size: 16),
            onTap: () => context.push('/services/${service.slug}'),
          ),
        ),
        const EtbalyPageSectionHeader(
          badge: 'الباقات',
          title: 'مسارات البداية والنمو والأداء',
          description:
              'باقات الموقع مترجمة هنا لمسارات مناسبة للموبايل: ابدأ بخفة، طوّر المحتوى، ثم وسّع الأداء بالتقارير والتحسين.',
        ),
      ],
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String slug;
  final String title;
  final String subtitle;
  final IconData icon;
}

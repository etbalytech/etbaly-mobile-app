import 'package:etbaly/src/imports/core_imports.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return EtbalyPage(
      children: [
        EtbalyHero(
          badge: 'وكالة تسويق رقمي',
          title: 'نمو رقمي يتحول إلى نتائج حقيقية',
          description:
              'اطبعلي تجمع بين الاستراتيجية والمحتوى والإعلانات والتصميم وتجارب الويب لمساعدة العلامات على النمو بعمل قابل للقياس، وليس وعودا فارغة.',
          icon: Icons.auto_awesome,
          actions: [
            EtbalyActionButton(
              label: 'ابدأ مشروعك',
              icon: Icons.rocket_launch,
              onTap: () => context.go(AppRoutes.contact),
            ),
            EtbalyActionButton(
              label: 'عرض الخدمات',
              icon: Icons.grid_view,
              outlined: true,
              onTap: () => context.go(AppRoutes.services),
            ),
          ],
          stats: const [
            EtbalyStat(value: '+400K', label: 'وصول للمستخدمين'),
            EtbalyStat(value: '+5K', label: 'تصميم ومحتوى'),
            EtbalyStat(value: '12+', label: 'سنة خبرة'),
          ],
        ),
        const EtbalyPageSectionHeader(
          badge: 'ماذا نفعل',
          title: 'فريق واحد للرحلة الرقمية بالكامل',
          description:
              'نفس عمق نسخة الويب موجود الآن داخل التطبيق بدلا من صفحات مؤقتة.',
        ),
        _HomeFeature(
          title: 'استراتيجية قبل التنفيذ',
          description:
              'خطط علامة تجارية، بناء حملات، تفكير في مسار العميل، وجداول محتوى مبنية حول أهداف العمل.',
          icon: Icons.route,
          color: colors.gold,
        ),
        _HomeFeature(
          title: 'محتوى إبداعي يبيع',
          description:
              'تصميمات، ريلز، صور منتجات، كتابة إعلانية، ومواد إطلاق بهوية بصرية احترافية.',
          icon: Icons.movie_creation,
          color: colors.primaryLight,
        ),
        _HomeFeature(
          title: 'أداء يمكن قياسه',
          description:
              'إعلانات، SEO، تقارير، وتحسين مستمر يركز على الوصول والعملاء والتحويل والاحتفاظ.',
          icon: Icons.trending_up,
          color: colors.success,
        ),
        EtbalyInfoCard(
          title: 'أعمال مختارة وباقات خدمات',
          description:
              'تصفح نماذج الأعمال، أقسام الخدمات، والباقات بصياغة مناسبة لتجربة الموبايل.',
          icon: Icons.collections,
          accent: colors.gold,
          trailing: Icon(Icons.arrow_forward_ios, color: colors.gold, size: 16),
          onTap: () => context.go(AppRoutes.portfolio),
        ),
      ],
    );
  }
}

class _HomeFeature extends StatelessWidget {
  const _HomeFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return EtbalyInfoCard(
      title: title,
      description: description,
      icon: icon,
      accent: color,
    );
  }
}

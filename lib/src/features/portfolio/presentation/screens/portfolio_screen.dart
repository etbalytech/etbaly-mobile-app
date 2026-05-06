import 'package:etbaly/src/imports/core_imports.dart';
import 'package:go_router/go_router.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return EtbalyPage(
      children: [
        EtbalyHero(
          badge: 'أعمالنا',
          title: 'نماذج أعمال عبر مجالات مختلفة',
          description:
              'البورتفوليو في الموقع منظم إلى ملفات PDF، مجالات، تخصصات، صور، وريلز. هذه الصفحة تعرض نفس الهيكل بشكل مناسب لتجربة التطبيق.',
          icon: Icons.photo_library,
          actions: [
            EtbalyActionButton(
              label: 'ابدأ عملا مشابها',
              icon: Icons.chat,
              onTap: () => context.go(AppRoutes.contact),
            ),
          ],
          stats: const [
            EtbalyStat(value: '49', label: 'صفحة أعمال'),
            EtbalyStat(value: '12+', label: 'مجال'),
            EtbalyStat(value: '+400K', label: 'أثر محقق'),
          ],
        ),
        const EtbalyPageSectionHeader(
          badge: 'نماذج',
          title: 'تصنيفات البورتفوليو',
          description:
              'ترجمة موبايل لقسم Class A و Class B الموجود في نسخة الويب.',
        ),
        EtbalyInfoCard(
          title: 'الفئة الأولى - نماذج مميزة',
          description:
              'هويات بصرية، حملات، ومشاريع مصقولة مختارة لترك انطباع قوي.',
          icon: Icons.workspace_premium,
          accent: colors.gold,
        ),
        EtbalyInfoCard(
          title: 'الفئة الثانية - تنوع إبداعي وتسويقي',
          description:
              'أمثلة إضافية عبر التصميم والمحتوى والأداء والسوشيال ميديا.',
          icon: Icons.diamond,
          accent: colors.info,
        ),
        const EtbalyPageSectionHeader(
          badge: 'المجالات',
          title: 'مجالات نخدمها',
          description:
              'مطاعم، أزياء، تجميل، تعليم، عقارات، طب، تجارة إلكترونية، خدمات، وأكثر.',
        ),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _IndustryChip(label: 'مطاعم', icon: Icons.restaurant),
            _IndustryChip(label: 'أزياء', icon: Icons.checkroom),
            _IndustryChip(label: 'تجميل', icon: Icons.spa),
            _IndustryChip(label: 'عقارات', icon: Icons.apartment),
            _IndustryChip(label: 'طبي', icon: Icons.local_hospital),
            _IndustryChip(label: 'تجارة إلكترونية', icon: Icons.shopping_bag),
          ],
        ),
        EtbalyInfoCard(
          title: 'عارض الصور والريلز',
          description:
              'المرحلة التالية يمكن أن تربط ملفات الميديا الحقيقية والـ popups. الآن اختفت الصفحة المؤقتة وأصبح الهيكل مطابقا لفكرة الموقع.',
          icon: Icons.play_circle,
          accent: colors.primaryLight,
        ),
      ],
    );
  }
}

class _IndustryChip extends StatelessWidget {
  const _IndustryChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.gold),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: colors.textMain,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

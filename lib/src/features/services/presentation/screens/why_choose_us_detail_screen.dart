import 'package:etbaly/src/features/services/data/models/why_choose_us_item.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:go_router/go_router.dart';

class WhyChooseUsDetailScreen extends StatelessWidget {
  const WhyChooseUsDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final item = WhyChooseUsItem.items.firstWhere(
      (i) => i.slug == slug,
      orElse: () => WhyChooseUsItem.items.first,
    );

    return Scaffold(
      backgroundColor: colors.bgMain,
      appBar: AppBar(
        backgroundColor: colors.bgCard,
        foregroundColor: colors.textMain,
        elevation: 0,
        title: Text(item.titleAr),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            // Hero Image from GitHub
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: 280,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(item.color.replaceFirst('#', '0xff'))),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 60,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(item.color.replaceFirst('#', '0xff'))),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            EtbalyHero(
              badge: 'لماذا نختار',
              title: item.titleAr,
              description: item.descriptionAr,
              icon: Icons.info_outline,
              actions: [
                EtbalyActionButton(
                  label: 'اتصل بنا',
                  icon: Icons.phone,
                  onTap: () => context.go(AppRoutes.contact),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const EtbalyPageSectionHeader(
              badge: 'الفوائد',
              title: 'ماذا تحصل عليه؟',
              description:
                  'اكتشف كل المميزات والفوائد التي تحصل عليها عند اختيارك لنا.',
            ),
            const SizedBox(height: 18),
            ...item.detailedPointsAr.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EtbalyInfoCard(
                  icon: Icons.check_circle,
                  title: point,
                  description: '',
                  accent: Color(
                      int.parse(item.color.replaceFirst('#', '0xff'))),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // CTA Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(
                    int.parse(item.color.replaceFirst('#', '0xff'))),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هل تريد الاستفادة من هذه المميزات؟',
                    textAlign: TextAlign.right,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تواصل معنا الآن واحصل على استشارة مجانية من فريقنا المختص.',
                    textAlign: TextAlign.right,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go(AppRoutes.contact),
                        icon: const Icon(Icons.send),
                        label: const Text('تواصل معنا'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(int.parse(
                              item.color.replaceFirst('#', '0xff'))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Back to services
            Center(
              child: TextButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('العودة إلى الخدمات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

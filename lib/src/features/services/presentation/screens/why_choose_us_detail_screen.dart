import 'package:etbaly/src/features/services/data/models/why_choose_us_item.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
          children: [
            // Hero Image from GitHub
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                width: double.infinity,
                height: 280.h,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 280.h,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(item.color.replaceFirst('#', '0xff'))),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 60.sp,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 280.h,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(item.color.replaceFirst('#', '0xff'))),
                        borderRadius: BorderRadius.circular(16.r),
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
            SizedBox(height: 28.h),
            EtbalyHero(
              badge: 'auto.t_d8e4322252'.tr(),
              title: item.titleAr,
              description: item.descriptionAr,
              icon: Icons.info_outline,
              actions: [
                EtbalyActionButton(
                  label: 'auto.t_c3721b0a95'.tr(),
                  icon: Icons.phone,
                  onTap: () => context.go(AppRoutes.contact),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            EtbalyPageSectionHeader(
              badge: 'auto.t_f38cf27a37'.tr(),
              title: 'auto.t_99299bd523'.tr(),
              description: 'auto.t_04245363d3'.tr(),
            ),
            SizedBox(height: 18.h),
            ...item.detailedPointsAr.map(
              (point) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: EtbalyInfoCard(
                  icon: Icons.check_circle,
                  title: point,
                  description: '',
                  accent:
                      Color(int.parse(item.color.replaceFirst('#', '0xff'))),
                ),
              ),
            ),
            SizedBox(height: 28.h),
            // CTA Section
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Color(int.parse(item.color.replaceFirst('#', '0xff'))),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'auto.t_bb5b9987c3'.tr(),
                    textAlign: TextAlign.right,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'auto.t_3e4332f528'.tr(),
                    textAlign: TextAlign.right,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go(AppRoutes.contact),
                        icon: const Icon(Icons.send),
                        label: Text('auto.t_9886382321'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(
                              int.parse(item.color.replaceFirst('#', '0xff'))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            // Back to services
            Center(
              child: TextButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: Text('auto.t_616b2e879c'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

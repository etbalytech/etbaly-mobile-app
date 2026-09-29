part of '../screens/home_page.dart';

class _CareersBannerSection extends StatelessWidget {
  const _CareersBannerSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final isAr = context.locale.languageCode == 'ar';
    final isDark = context.isDarkMode;
    final label = isAr
        ? 'عرض الوظائف المتاحة والتقديم للانضمام إلى فريق اطبعلي'
        : 'View available jobs and apply to join the Etbaly team';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          onTap: () => context.go(AppRoutes.careers),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.bgCard,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.18),
                  blurRadius: 24.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1917 / 821,
                  child: Image.asset(
                    AppAssets.careersIntro(isArabic: isAr, isDark: isDark),
                    fit: BoxFit.cover,
                    semanticLabel: isAr
                        ? 'انضم إلى فريق اطبعلي والوظائف المتاحة'
                        : 'Join the Etbaly team and explore available jobs',
                    frameBuilder: (context, child, frame, wasSync) {
                      if (wasSync) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: child,
                      );
                    },
                  ),
                ),
                _CareersBannerAction(isArabic: isAr),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 450)).slideY(begin: 0.06);
  }
}

class _CareersBannerAction extends StatelessWidget {
  const _CareersBannerAction({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: colors.gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(Icons.work_rounded, color: colors.gold, size: 18.sp),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              isArabic
                  ? 'شاهد الوظائف المتاحة وقدّم الآن'
                  : 'Explore available jobs and apply now',
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.textMain,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.arrow_forward_rounded, color: colors.gold, size: 20.sp),
        ],
      ),
    );
  }
}

part of '../screens/home_page.dart';

class _HeroBrandBadge extends StatelessWidget {
  const _HeroBrandBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        gradient: LinearGradient(
          colors: [colors.primaryLight, colors.primary, colors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primaryGlowStrong,
            blurRadius: 18.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              colors.bgCard.withValues(alpha: context.isDarkMode ? 0.92 : 0.96),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'auto.t_135dd3f6f1'.tr(),
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.textMain,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 52.w,
              height: 36.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xEEFFFFFF),
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(color: colors.gold, width: 1.2.w),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppAssets.logo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Digital\nMarketing',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF7B5B12),
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w900,
                      height: 0.95,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

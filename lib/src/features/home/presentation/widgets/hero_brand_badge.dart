part of '../screens/home_page.dart';

class _HeroBrandBadge extends StatelessWidget {
  const _HeroBrandBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF8D63FF), Color(0xFF5B27D9), Color(0xFF1A123D)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x776F3FF5),
            blurRadius: 18.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xDDEDEAF8),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: const Color(0x55FFFFFF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'auto.t_135dd3f6f1'.tr(),
              style: context.textTheme.titleSmall?.copyWith(
                color: const Color(0xFF19102F),
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
                border:
                    Border.all(color: const Color(0xFFD4AF37), width: 1.2.w),
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

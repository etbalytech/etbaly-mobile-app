part of '../screens/home_page.dart';

class _AirplaneBadge extends StatelessWidget {
  const _AirplaneBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.badgeBg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: colors.primary.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
              boxShadow: [
                BoxShadow(color: colors.primaryGlowStrong, blurRadius: 10.r),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'auto.t_2d41d70d13'.tr(),
            style: context.textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

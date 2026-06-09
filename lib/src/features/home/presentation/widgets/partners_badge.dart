part of '../screens/home_page.dart';

class _PartnersBadge extends StatelessWidget {
  const _PartnersBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: colors.badgeBg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9.w,
            height: 9.h,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: colors.primaryGlowStrong, blurRadius: 12.r),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'auto.t_1092848358'.tr(),
            style: context.textTheme.labelLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

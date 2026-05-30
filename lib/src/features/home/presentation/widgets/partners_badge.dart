part of '../screens/home_page.dart';

class _PartnersBadge extends StatelessWidget {
  const _PartnersBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color(0x226F3FF5),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: const Color(0x663D236C)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9.w,
            height: 9.h,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: const Color(0x887C3AED), blurRadius: 12.r),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'auto.t_1092848358'.tr(),
            style: context.textTheme.labelLarge?.copyWith(
              color: const Color(0xFFA78BFA),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

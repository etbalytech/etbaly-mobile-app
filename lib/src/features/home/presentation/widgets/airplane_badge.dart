part of '../screens/home_page.dart';

class _AirplaneBadge extends StatelessWidget {
  const _AirplaneBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0x226F3FF5),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: const Color(0x665F37C7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF9B5CF6),
              boxShadow: [
                BoxShadow(color: const Color(0x889B5CF6), blurRadius: 10.r),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'auto.t_2d41d70d13'.tr(),
            style: context.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFC084FC),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

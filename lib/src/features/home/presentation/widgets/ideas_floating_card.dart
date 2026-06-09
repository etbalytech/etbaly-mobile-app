part of '../screens/home_page.dart';

class _IdeasFloatingCard extends StatelessWidget {
  const _IdeasFloatingCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: 124.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color:
            colors.bgCard.withValues(alpha: context.isDarkMode ? 0.86 : 0.94),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 20.r),
        ],
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Icon(icon, color: colors.gold, size: 30.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(
          begin: -3,
          end: 5,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
  }
}

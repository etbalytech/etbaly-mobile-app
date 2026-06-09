part of '../screens/home_page.dart';

class _IdeasActionButton extends StatelessWidget {
  const _IdeasActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.filled = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final radius = BorderRadius.circular(999.r);
    final isAr = context.locale.languageCode == 'ar';

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          height: 44.h,
          decoration: BoxDecoration(
            color: filled ? colors.goldLight : Colors.transparent,
            borderRadius: radius,
            border: Border.all(color: colors.gold, width: 1.5.w),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.30),
                      blurRadius: 24.r,
                      offset: Offset(0.w, 12.h),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: filled ? Colors.black : colors.gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (icon != null) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    isAr ? Icons.arrow_forward : Icons.arrow_back,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

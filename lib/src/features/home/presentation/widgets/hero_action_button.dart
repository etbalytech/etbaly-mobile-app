part of '../screens/home_page.dart';

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final borderRadius = BorderRadius.circular(999.r);

    // The decoration (and its shadow) lives on a Container outside the Material:
    // `Ink` paints inside the Material's bounds, which clipped the glow into a
    // hard-edged rectangle behind the pill.
    return Container(
      width: 136.w,
      height: 58.h,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: outlined
            ? null
            : LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  colors.primaryLight,
                  colors.primary,
                  colors.primaryDark,
                ],
              ),
        color: outlined ? colors.badgeBg : null,
        border: outlined
            ? Border.all(
                color: colors.primary.withValues(alpha: 0.36), width: 1.2.w)
            : null,
        boxShadow: outlined
            ? null
            : [
                BoxShadow(
                  color: colors.primaryGlowStrong,
                  blurRadius: 26.r,
                  offset: Offset(0.w, 14.h),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                label,
                style: context.textTheme.titleMedium?.copyWith(
                  color: outlined ? colors.primary : Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 8.w),
                Icon(
                  icon,
                  color: outlined ? colors.primary : Colors.white,
                  size: 18.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

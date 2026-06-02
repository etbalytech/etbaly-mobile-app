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
    final radius = BorderRadius.circular(999.r);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          width: 128.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: filled ? const Color(0xFFE5C352) : Colors.transparent,
            borderRadius: radius,
            border: Border.all(color: const Color(0xFFD4AF37), width: 1.5.w),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: const Color(0x55D4AF37),
                      blurRadius: 24.r,
                      offset: Offset(0.w, 12.h),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: filled
                      ? const Color(0xFF1A102C)
                      : const Color(0xFFD4AF37),
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 8.w),
                Icon(icon, color: const Color(0xFF1A102C), size: 20.sp),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

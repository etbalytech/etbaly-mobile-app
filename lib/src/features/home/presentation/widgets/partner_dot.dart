part of '../screens/home_page.dart';

class _PartnerDot extends StatelessWidget {
  const _PartnerDot({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        width: active ? 30 : 9,
        height: 9.h,
        decoration: BoxDecoration(
          color: active
              ? colors.primary
              : colors.borderColor.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(999.r),
        ),
      ),
    );
  }
}

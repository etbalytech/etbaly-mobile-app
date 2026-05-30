part of '../screens/home_page.dart';

class _PartnerDot extends StatelessWidget {
  const _PartnerDot({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        width: active ? 30 : 9,
        height: 9.h,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C3AED) : const Color(0x553D236C),
          borderRadius: BorderRadius.circular(999.r),
        ),
      ),
    );
  }
}

part of '../screens/home_page.dart';

class _StripLightbox extends StatelessWidget {
  const _StripLightbox({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x998B5CF6),
                  blurRadius: 48.r,
                  spreadRadius: 4.r,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19.r),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Positioned(
            top: -18.h,
            right: -18.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B102B),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x88000000),
                      blurRadius: 12.r,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: const Color(0xFFD4AF37),
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 200)).scale(
          begin: Offset(0.92.w, 0.92.h),
          end: Offset(1.w, 1.h),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
        );
  }
}

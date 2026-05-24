part of '../screens/home_page.dart';

class _StripLightbox extends StatelessWidget {
  const _StripLightbox({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x998B5CF6),
                  blurRadius: 48,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
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
            top: -18,
            right: -18,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B102B),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x88000000),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFD4AF37),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 200))
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
        );
  }
}

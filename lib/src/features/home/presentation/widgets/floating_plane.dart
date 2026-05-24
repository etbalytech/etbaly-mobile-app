part of '../screens/home_page.dart';

class _FloatingPlane extends StatelessWidget {
  const _FloatingPlane({
    required this.animation,
    required this.top,
    required this.size,
    this.delay = 0,
    this.reverse = false,
    this.flipHorizontally = false,
  });

  final Animation<double> animation;
  final double top;
  final double size;
  final double delay;
  final bool reverse;
  final bool flipHorizontally;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final progress = (animation.value + delay) % 1;
        final screenWidth = context.width;
        final planeWidth = size * 2.35;
        final travel = screenWidth + planeWidth * 2;
        final x = reverse
            ? screenWidth + planeWidth - (progress * travel)
            : -planeWidth + (progress * travel);
        final bob = math.sin(progress * math.pi * 2) * 8;

        return Positioned(
          top: top + bob,
          left: x,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
              flipHorizontally ? -1 : 1,
              1,
              1,
            ),
            child: SizedBox(
              width: planeWidth,
              height: size,
              child: SvgPicture.asset(
                reverse ? AppAssets.airplaneLeft : AppAssets.airplaneRight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}

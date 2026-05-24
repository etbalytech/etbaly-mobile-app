part of '../screens/home_page.dart';

class _StripImageCard extends StatelessWidget {
  const _StripImageCard({
    required this.image,
    required this.width,
    required this.onTap,
  });

  final String image;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = (width * pixelRatio).round();
    final cacheHeight = (width * 0.92 * pixelRatio).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: width * 0.92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x553D365C)),
          boxShadow: const [
            BoxShadow(color: Color(0x55000000), blurRadius: 16),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

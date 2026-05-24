part of '../screens/home_page.dart';

class _HeroBrandBadge extends StatelessWidget {
  const _HeroBrandBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: [Color(0xFF8D63FF), Color(0xFF5B27D9), Color(0xFF1A123D)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x776F3FF5),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xDDEDEAF8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0x55FFFFFF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اطبعلي',
              style: context.textTheme.titleSmall?.copyWith(
                color: const Color(0xFF19102F),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 52,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xEEFFFFFF),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.2),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppAssets.logo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Digital\nMarketing',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF7B5B12),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      height: 0.95,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

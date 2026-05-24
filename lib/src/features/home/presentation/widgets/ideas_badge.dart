part of '../screens/home_page.dart';

class _IdeasBadge extends StatelessWidget {
  const _IdeasBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xCC241B2E),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x667B6A86)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x5520182C),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF14B867),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xAA14B867),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'وكالة تسويق رقمي احترافية',
            style: context.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFD4AF37),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

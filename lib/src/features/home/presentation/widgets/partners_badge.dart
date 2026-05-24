part of '../screens/home_page.dart';

class _PartnersBadge extends StatelessWidget {
  const _PartnersBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0x226F3FF5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x663D236C)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0x887C3AED), blurRadius: 12),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'شركاء النجاح',
            style: context.textTheme.labelLarge?.copyWith(
              color: const Color(0xFFA78BFA),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

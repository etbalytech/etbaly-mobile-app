part of '../screens/home_page.dart';

class _AirplaneBadge extends StatelessWidget {
  const _AirplaneBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x226F3FF5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x665F37C7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF9B5CF6),
              boxShadow: [
                BoxShadow(color: Color(0x889B5CF6), blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'وكالة إبداعية متكاملة',
            style: context.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFC084FC),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

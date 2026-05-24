part of '../screens/home_page.dart';

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(999);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          width: 136,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: outlined
                ? null
                : const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFB449FF),
                      Color(0xFF7C20E6),
                      Color(0xFF5B00B7),
                    ],
                  ),
            color: outlined ? const Color(0x2418102F) : null,
            border: outlined
                ? Border.all(color: const Color(0x887E5CB8), width: 1.2)
                : null,
            boxShadow: outlined
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x805B00B7),
                      blurRadius: 26,
                      offset: Offset(0, 14),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                label,
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

part of '../screens/home_page.dart';

class _AirplaneFeaturePills extends StatelessWidget {
  const _AirplaneFeaturePills();

  @override
  Widget build(BuildContext context) {
    const features = [
      ('هوية بصرية', Icons.auto_awesome),
      ('تصميم رقمي', Icons.diamond_outlined),
      ('تسويق ذكي', Icons.hexagon_outlined),
      ('استراتيجية نمو', Icons.adjust),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final feature in features)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x4A160B31),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0x663D236C)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(feature.$2, color: const Color(0xFFC084FC), size: 15),
                const SizedBox(width: 8),
                Text(
                  feature.$1,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

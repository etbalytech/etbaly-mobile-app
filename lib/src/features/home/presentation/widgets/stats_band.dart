part of '../screens/home_page.dart';

class _StatsBand extends StatelessWidget {
  const _StatsBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x55D4AF37)),
          bottom: BorderSide(color: Color(0x55D4AF37)),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _StatsBandItem(
              value: '+400,000',
              compactValue: '400K+',
              label: 'مشروع منجز',
              compactLabel: 'مشاريع',
              icon: Icons.rocket_launch,
            ),
          ),
          _StatsBandDivider(),
          Expanded(
            child: _StatsBandItem(
              value: '+5,000',
              compactValue: '5K+',
              label: 'عميل راضي',
              compactLabel: 'عملاء',
              icon: Icons.sentiment_satisfied_alt,
            ),
          ),
          _StatsBandDivider(),
          Expanded(
            child: _StatsBandItem(
              value: '+12',
              compactValue: '12+',
              label: 'سنوات خبرة',
              compactLabel: 'خبرة',
              icon: Icons.star,
            ),
          ),
        ],
      ),
    );
  }
}

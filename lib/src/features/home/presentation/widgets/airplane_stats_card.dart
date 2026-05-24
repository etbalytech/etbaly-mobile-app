part of '../screens/home_page.dart';

class _AirplaneStatsCard extends StatelessWidget {
  const _AirplaneStatsCard({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 10 : 14,
        vertical: isNarrow ? 18 : 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xA0100B1D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x553D236C)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AirplaneStat(
              value: '+5000',
              label: 'علامة تجارية',
              isNarrow: isNarrow,
            ),
          ),
          const _AirplaneStatDivider(),
          Expanded(
            child: _AirplaneStat(
              value: '%93',
              label: 'رضا العملاء',
              isNarrow: isNarrow,
            ),
          ),
          const _AirplaneStatDivider(),
          Expanded(
            child: _AirplaneStat(
              value: '+12 سنوات',
              label: 'خبرة إبداعية',
              isNarrow: isNarrow,
            ),
          ),
        ],
      ),
    );
  }
}

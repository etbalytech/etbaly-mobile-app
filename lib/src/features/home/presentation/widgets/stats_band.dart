part of '../screens/home_page.dart';

class _StatsBand extends StatelessWidget {
  const _StatsBand();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.gold.withValues(alpha: 0.35)),
          bottom: BorderSide(color: colors.gold.withValues(alpha: 0.35)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatsBandItem(
              value: '+400,000',
              compactValue: '400K+',
              label: 'auto.t_12b1d6581c'.tr(),
              compactLabel: 'auto.t_d3b9a9e47b'.tr(),
              icon: Icons.rocket_launch,
            ),
          ),
          const _StatsBandDivider(),
          Expanded(
            child: _StatsBandItem(
              value: '+5,000',
              compactValue: '5K+',
              label: 'auto.t_6a6d13b7c7'.tr(),
              compactLabel: 'auto.t_69bb4d70de'.tr(),
              icon: Icons.sentiment_satisfied_alt,
            ),
          ),
          const _StatsBandDivider(),
          Expanded(
            child: _StatsBandItem(
              value: '+12',
              compactValue: '12+',
              label: 'auto.t_07caf2cbc5'.tr(),
              compactLabel: 'auto.t_9118f5a643'.tr(),
              icon: Icons.star,
            ),
          ),
        ],
      ),
    );
  }
}

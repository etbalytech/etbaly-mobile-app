part of '../screens/home_page.dart';

class _AirplaneStatsCard extends StatelessWidget {
  const _AirplaneStatsCard({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 10 : 14,
        vertical: isNarrow ? 18 : 22,
      ),
      decoration: BoxDecoration(
        color:
            colors.bgCard.withValues(alpha: context.isDarkMode ? 0.74 : 0.88),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 20.r,
            offset: Offset(0.w, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _AirplaneStat(
              value: '+5000',
              label: 'auto.t_8c4b0068fb'.tr(),
              isNarrow: isNarrow,
            ),
          ),
          const _AirplaneStatDivider(),
          Expanded(
            child: _AirplaneStat(
              value: '%93',
              label: 'auto.t_52c33d066b'.tr(),
              isNarrow: isNarrow,
            ),
          ),
          const _AirplaneStatDivider(),
          Expanded(
            child: _AirplaneStat(
              value: 'auto.t_396a22256b'.tr(),
              label: 'auto.t_8da83dfa81'.tr(),
              isNarrow: isNarrow,
            ),
          ),
        ],
      ),
    );
  }
}

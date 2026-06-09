part of '../screens/home_page.dart';

class _HowWeWorkSection extends StatelessWidget {
  const _HowWeWorkSection();

  List<_WorkWaveData> _buildWaves() => [
    _WorkWaveData(
      number: '01',
      title: 'auto.t_589d94f99d'.tr(),
      subtitle: 'auto.t_148f1493bc'.tr(),
      accent: EtbalyWebColors.gold,
      cards: [
        _WorkStepData(
          number: '01',
          title: 'auto.t_75c15e61a6'.tr(),
          description: 'auto.t_0abc574d83'.tr(),
          icon: Icons.forum,
        ),
        _WorkStepData(
          number: '02',
          title: 'auto.t_9e3e055cb5'.tr(),
          description: 'auto.t_c82f9e2c3d'.tr(),
          icon: Icons.saved_search,
        ),
        _WorkStepData(
          number: '03',
          title: 'auto.t_a51ee5ec5c'.tr(),
          description: 'auto.t_e3def7cc9c'.tr(),
          icon: Icons.track_changes,
        ),
      ],
    ),
    _WorkWaveData(
      number: '02',
      title: 'auto.t_daec0ed686'.tr(),
      subtitle: 'auto.t_88b894e52e'.tr(),
      accent: EtbalyWebColors.purple,
      alternate: true,
      cards: [
        _WorkStepData(
          number: '04',
          title: 'auto.t_b25d310892'.tr(),
          description: 'auto.t_df1b69a3e1'.tr(),
          icon: Icons.map,
        ),
        _WorkStepData(
          number: '05',
          title: 'auto.t_4b42563eeb'.tr(),
          description: 'auto.t_8f6a91812f'.tr(),
          icon: Icons.filter_alt,
        ),
        _WorkStepData(
          number: '06',
          title: 'auto.t_e42401d2d7'.tr(),
          description: 'auto.t_e202b204df'.tr(),
          icon: Icons.calendar_month,
        ),
      ],
    ),
    _WorkWaveData(
      number: '03',
      title: 'auto.t_31850bc686'.tr(),
      subtitle: 'auto.t_0df647ecc0'.tr(),
      accent: EtbalyWebColors.teal,
      cards: [
        _WorkStepData(
          number: '07',
          title: 'auto.t_33c20ade30'.tr(),
          description: 'auto.t_7ee746cf6e'.tr(),
          icon: Icons.brush,
        ),
        _WorkStepData(
          number: '08',
          title: 'auto.t_7f7d2ff2d6'.tr(),
          description: 'auto.t_f4f054f864'.tr(),
          icon: Icons.campaign,
        ),
        _WorkStepData(
          number: '09',
          title: 'auto.t_f7839756f5'.tr(),
          description: 'auto.t_ee4cfd3302'.tr(),
          icon: Icons.sync,
        ),
      ],
    ),
    _WorkWaveData(
      number: '04',
      title: 'auto.t_5f45f7f5fd'.tr(),
      subtitle: 'auto.t_3bb9acee9b'.tr(),
      accent: EtbalyWebColors.gold,
      alternate: true,
      cards: [
        _WorkStepData(
          number: '10',
          title: 'auto.t_6a22efc55b'.tr(),
          description: 'auto.t_4bef32ac85'.tr(),
          icon: Icons.query_stats,
        ),
        _WorkStepData(
          number: '11',
          title: 'auto.t_50abceb520'.tr(),
          description: 'auto.t_40e72968c6'.tr(),
          icon: Icons.emoji_events,
        ),
        _WorkStepData(
          number: '12',
          title: 'auto.t_fe4e6a9084'.tr(),
          description: 'auto.t_54337ca201'.tr(),
          icon: Icons.handshake,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = context.width < 600;
    final colors = context.etbalyColors;
    final waves = _buildWaves();

    return EtbalyWebSectionShell(
      backgroundColor: colors.bgSecondary,
      backgroundPainter: _HowWeWorkPainter(
        colors: colors,
        isDark: context.isDarkMode,
      ),
      child: Column(
        children: [
          EtbalyWebBadge(
            label: 'auto.t_4c301be00c'.tr(),
            glowDot: EtbalyWebColors.green,
            trailingDot: const Color(0xBBD4AF37),
            websiteStyle: true,
          ),
          SizedBox(height: isMobile ? 18 : 24),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'auto.t_01c9d25174'.tr()),
                TextSpan(
                  text: 'auto.t_599e52aefb'.tr(),
                  style: context.textTheme.displaySmall?.copyWith(
                    color: colors.gold,
                    fontSize: context.width < 390 ? 34 : 42,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: context.textTheme.displaySmall?.copyWith(
              color: colors.textMain,
              fontSize: context.width < 390 ? 34 : 42,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          SizedBox(height: 16.h),
          const EtbalyWebGoldDivider(),
          SizedBox(height: 24.h),
          Text(
            'auto.t_567c4dafc2'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              color: colors.textMuted,
              fontSize: context.width < 390 ? 14 : 16,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 34 : 46),
          for (var i = 0; i < waves.length; i++) ...[
            _ProcessWave(wave: waves[i]),
            if (i != waves.length - 1) SizedBox(height: isMobile ? 30 : 42),
          ],
        ],
      ),
    );
  }
}

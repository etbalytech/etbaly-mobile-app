part of '../screens/home_page.dart';

class _StripHeader extends StatelessWidget {
  const _StripHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;

    return Row(
      children: [
        Expanded(child: Divider(color: colors.gold.withValues(alpha: 0.35))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            'auto.t_4ab7f5f8c1'.tr(),
            style: context.textTheme.labelLarge?.copyWith(
              color: colors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.gold.withValues(alpha: 0.35))),
      ],
    );
  }
}

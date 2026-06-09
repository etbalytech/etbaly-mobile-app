part of '../screens/home_page.dart';

class _AirplaneFeaturePills extends StatelessWidget {
  const _AirplaneFeaturePills();

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final features = [
      ('auto.t_5dbc6132d0'.tr(), Icons.auto_awesome),
      ('auto.t_c8dd386e3c'.tr(), Icons.diamond_outlined),
      ('auto.t_613a55a9d3'.tr(), Icons.hexagon_outlined),
      ('auto.t_61e87743ae'.tr(), Icons.adjust),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.r,
      runSpacing: 10.r,
      children: [
        for (final feature in features)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: colors.badgeBg,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: colors.borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(feature.$2, color: colors.primary, size: 15.sp),
                SizedBox(width: 8.w),
                Text(
                  feature.$1,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: colors.textMain,
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

part of '../screens/home_page.dart';

class _StatsBandDivider extends StatelessWidget {
  const _StatsBandDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 50.h,
      color: context.etbalyColors.borderColor.withValues(alpha: 0.7),
    );
  }
}

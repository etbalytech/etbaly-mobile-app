part of '../screens/home_page.dart';

class _AirplaneStatDivider extends StatelessWidget {
  const _AirplaneStatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 92.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: context.etbalyColors.borderColor.withValues(alpha: 0.7),
    );
  }
}

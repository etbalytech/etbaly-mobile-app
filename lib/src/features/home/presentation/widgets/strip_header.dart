part of '../screens/home_page.dart';

class _StripHeader extends StatelessWidget {
  const _StripHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0x55D4AF37))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            'auto.t_4ab7f5f8c1'.tr(),
            style: context.textTheme.labelLarge?.copyWith(
              color: const Color(0xFFD4AF37),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0x55D4AF37))),
      ],
    );
  }
}

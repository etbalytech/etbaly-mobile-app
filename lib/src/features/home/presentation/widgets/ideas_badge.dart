part of '../screens/home_page.dart';

class _IdeasBadge extends StatelessWidget {
  const _IdeasBadge();

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.languageCode == 'en';

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: context.width - 44.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 14.w, 10.h),
        decoration: BoxDecoration(
          color: const Color(0xCC241B2E),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: const Color(0x667B6A86)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x5520182C),
              blurRadius: 18.r,
              offset: Offset(0.w, 8.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: const Color(0xFF14B867),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xAA14B867),
                    blurRadius: 12.r,
                    spreadRadius: 2.r,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Text(
                'auto.t_24f008b70e'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFFD4AF37),
                  fontSize: isEnglish ? 12.sp : 13.sp,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

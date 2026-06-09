part of '../screens/home_page.dart';

class _IdeasBadge extends StatelessWidget {
  const _IdeasBadge();

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.languageCode == 'en';
    final colors = context.etbalyColors;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: context.width - 44.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 14.w, 10.h),
        decoration: BoxDecoration(
          color:
              colors.bgCard.withValues(alpha: context.isDarkMode ? 0.82 : 0.94),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: colors.borderColor),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow,
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
                  color: colors.gold,
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

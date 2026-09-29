import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../extensions/context_extension.dart';

const etbalyPrivacyUrl = 'https://etba3ly-dm.com/privacy';

/// A small "Privacy Policy" link for the screens that collect personal data
/// (contact, start now, careers). Google Play asks for the policy to be
/// reachable from inside the app as well as from the store listing.
class EtbalyPrivacyLink extends StatelessWidget {
  const EtbalyPrivacyLink({super.key});

  Future<void> _open() async {
    final uri = Uri.parse(etbalyPrivacyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final colors = context.etbalyColors;

    return Center(
      child: InkWell(
        onTap: _open,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user_outlined,
                  size: 15.sp, color: colors.textMuted),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  isArabic
                      ? 'بإرسال بياناتك أنت توافق على سياسة الخصوصية'
                      : 'By sending your data you agree to our Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../extensions/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Etbaly Button Component
/// Gold gradient primary + outline-gold secondary matching web's buttons
class EtbalyButton extends StatelessWidget {
  const EtbalyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = EtbalyButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.animate = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final EtbalyButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final designTokens = context.designTokens;

    Widget button;
    final isDisabled = onPressed == null || isLoading;

    switch (style) {
      case EtbalyButtonStyle.primary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: etbalyColors.gold,
            foregroundColor: Colors.black,
            minimumSize: fullWidth ? Size.infinite : Size(120.w, 48.h),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(designTokens.borderRadiusMedium),
            ),
            elevation: 0,
            shadowColor: etbalyColors.goldGlow,
            disabledBackgroundColor:
                etbalyColors.goldLight.withValues(alpha: 0.5),
            disabledForegroundColor: Colors.black.withValues(alpha: 0.5),
          ),
          child: _buildButtonContent(),
        );
        break;

      case EtbalyButtonStyle.outline:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: etbalyColors.gold,
            minimumSize: fullWidth ? Size.infinite : Size(120.w, 48.h),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(designTokens.borderRadiusMedium),
            ),
            side: BorderSide(color: etbalyColors.gold, width: 2.w),
            disabledForegroundColor: etbalyColors.gold.withValues(alpha: 0.5),
          ),
          child: _buildButtonContent(),
        );
        break;

      case EtbalyButtonStyle.secondary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: etbalyColors.primary,
            foregroundColor: Colors.white,
            minimumSize: fullWidth ? Size.infinite : Size(120.w, 48.h),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(designTokens.borderRadiusMedium),
            ),
            elevation: 0,
            shadowColor: etbalyColors.primaryGlow,
            disabledBackgroundColor:
                etbalyColors.primaryLight.withValues(alpha: 0.5),
            disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
          ),
          child: _buildButtonContent(),
        );
        break;
    }

    // Animation temporarily disabled to fix null check error
    // if (animate && !isDisabled) {
    //   button = button.animate().scale(
    //     begin: Offset(0.95.w, 0.95.h),
    //     duration: Duration(milliseconds: 200),
    //     curve: Curves.easeOutCubic,
    //   );
    // }

    return button;
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 20.h,
        width: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.r,
          valueColor: AlwaysStoppedAnimation<Color>(
            style == EtbalyButtonStyle.primary ? Colors.black : Colors.white,
          ),
        ),
      );
    }

    final children = <Widget>[
      if (icon != null) ...[
        Icon(icon, size: 16.sp),
        SizedBox(width: 8.w),
      ],
      Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

enum EtbalyButtonStyle {
  primary,
  outline,
  secondary,
}

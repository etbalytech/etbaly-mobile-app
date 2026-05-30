import 'package:flutter/material.dart';
import '../../../extensions/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ToastCard widget to display decent and rich looking toast.
class ToastCard extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final Color? shadowColor;
  final void Function()? onTap;

  const ToastCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.color,
    this.shadowColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: color ?? context.theme.dialogTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.theme.colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.r,
            spreadRadius: 0.r,
            offset: Offset.zero,
            color: shadowColor ?? Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: leading,
        ),
        trailing: trailing,
        subtitle: subtitle,
        title: title,
        onTap: onTap,
      ),
    );
  }
}

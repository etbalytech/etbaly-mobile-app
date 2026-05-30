import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Predefined box shadows aligned with Material 3 elevation tiers.
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: AppShadows.card,
///   ),
/// )
/// ```
abstract final class AppShadows {
  AppShadows._();

  /// No shadow — flat, tonal surface (elevation 0).
  static List<BoxShadow> none = [];

  /// Minimal shadow — barely lifted surfaces (elevation 1).
  /// Use for: toggle surfaces, filled cards on white background.
  static List<BoxShadow> subtle = [
    BoxShadow(
      color: const Color(0x0D000000), // 5% black
      blurRadius: 2.r,
      offset: Offset(0.w, 1.h),
    ),
  ];

  /// Card shadow — clearly elevated content (elevation 2–3).
  /// Use for: cards, list items that are tappable, floating elements.
  static List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0x14000000), // 8% black
      blurRadius: 8.r,
      offset: Offset(0.w, 2.h),
    ),
    BoxShadow(
      color: const Color(0x0A000000), // 4% black
      blurRadius: 2.r,
      offset: Offset(0.w, 1.h),
    ),
  ];

  /// Elevated shadow — significantly raised surface (elevation 6–8).
  /// Use for: FABs, dropdown menus, tooltips.
  static List<BoxShadow> elevated = [
    BoxShadow(
      color: const Color(0x1F000000), // 12% black
      blurRadius: 16.r,
      offset: Offset(0.w, 6.h),
    ),
    BoxShadow(
      color: const Color(0x0F000000), // 6% black
      blurRadius: 4.r,
      offset: Offset(0.w, 2.h),
    ),
  ];

  /// Modal shadow — overlay surfaces, dialogs, bottom sheets (elevation 12+).
  /// Use for: dialogs, modals, side sheets.
  static List<BoxShadow> modal = [
    BoxShadow(
      color: const Color(0x29000000), // 16% black
      blurRadius: 32.r,
      offset: Offset(0.w, 12.h),
    ),
    BoxShadow(
      color: const Color(0x14000000), // 8% black
      blurRadius: 8.r,
      offset: Offset(0.w, 4.h),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable border radii and border shapes used across the app.
///
/// Usage:
/// ```dart
/// Container(decoration: BoxDecoration(borderRadius: AppBorders.md))
/// ```
abstract final class AppBorders {
  AppBorders._();

  // ── Border Radii ──────────────────────────────────────────────────────────

  /// 4 pt — subtle rounding, used for small chips, badges.
  static BorderRadius get xs => BorderRadius.all(Radius.circular(4.r));

  /// 8 pt — standard rounding for buttons, text fields.
  static BorderRadius get sm => BorderRadius.all(Radius.circular(8.r));

  /// 12 pt — medium rounding for cards, list tiles.
  static BorderRadius get md => BorderRadius.all(Radius.circular(12.r));

  /// 16 pt — large rounding for modals, bottom sheets.
  static BorderRadius get lg => BorderRadius.all(Radius.circular(16.r));

  /// 24 pt — extra large rounding for dialogs, feature cards.
  static BorderRadius get xl => BorderRadius.all(Radius.circular(24.r));

  /// 28 pt — Material 3 bottom sheet top radius.
  static BorderRadius get bottomSheet => BorderRadius.vertical(
        top: Radius.circular(28.r),
      );

  /// Fully circular (pill/stadium shape).
  static BorderRadius get full => BorderRadius.all(Radius.circular(999.r));

  // ── Semantic aliases ──────────────────────────────────────────────────────

  /// Default button border radius.
  static BorderRadius get button => lg;

  /// Default card border radius.
  static BorderRadius get card => md;

  /// Default input field border radius.
  static BorderRadius get input => sm;

  /// Default dialog border radius.
  static BorderRadius get dialog => xl;

  // ── RoundedRectangleBorder shapes (for ShapeBorder APIs) ─────────────────

  /// Small rounded rectangle shape (8 pt).
  static RoundedRectangleBorder get shapeSm => RoundedRectangleBorder(
        borderRadius: sm,
      );

  /// Medium rounded rectangle shape (12 pt).
  static RoundedRectangleBorder get shapeMd => RoundedRectangleBorder(
        borderRadius: md,
      );

  /// Large rounded rectangle shape (16 pt).
  static RoundedRectangleBorder get shapeLg => RoundedRectangleBorder(
        borderRadius: lg,
      );

  /// Fully circular/stadium shape.
  static StadiumBorder stadium = const StadiumBorder();
}

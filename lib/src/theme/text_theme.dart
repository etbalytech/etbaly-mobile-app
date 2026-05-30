import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Returns the appropriate font family based on the current locale
String _getFontFamilyForLocale(Locale locale) {
  // Arabic locales use Tajawal, others use Sora
  if (locale.languageCode == 'ar') {
    return 'Tajawal';
  }
  return 'Sora';
}

/// Creates a TextStyle with locale-aware font family
TextStyle _createTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  double? letterSpacing,
  Locale? locale,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    fontFamily: _getFontFamilyForLocale(locale ?? const Locale('en')),
  );
}

/// Defines the full Material 3 typescale for the application with language-aware fonts.
///
/// Prefer accessing styles through [BuildContext] extensions:
/// ```dart
/// Text('Hello', style: context.textTheme.titleLarge);
/// ```
TextTheme buildTextTheme([Locale? locale]) {
  final currentLocale = locale ?? const Locale('en');

  // ── Display ──────────────────────────────────────────────────────────────
  // Use for the largest, most impactful text on a screen.
  // Typically reserved for hero/marketing sections, splash screens,
  // or short one-word statements. Never use for body copy.

  /// 57 sp — Largest display text.
  /// Use for: splash screen titles, giant counters, hero numbers.
  final displayLarge = _createTextStyle(
    fontSize: 57.sp,
    fontWeight: FontWeight.w800, // Heavier weight for impact
    letterSpacing: -0.25,
    locale: currentLocale,
  );

  /// 45 sp — Mid-size display text.
  /// Use for: prominent feature headlines, onboarding first-screen titles.
  final displayMedium = _createTextStyle(
    fontSize: 45.sp,
    fontWeight: FontWeight.w700, // Bold for headings
    letterSpacing: 0,
    locale: currentLocale,
  );

  /// 36 sp — Smallest display text.
  /// Use for: section-level hero text, large marketing callouts.
  final displaySmall = _createTextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    locale: currentLocale,
  );

  // ── Headline ─────────────────────────────────────────────────────────────
  // Use for page/screen-level headings. Slightly smaller than Display —
  // works well as the primary title of a full page or major section.

  /// 32 sp — Large page-level heading.
  /// Use for: main screen titles (e.g. "My Profile"), large dialog headers.
  final headlineLarge = _createTextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700, // Bold for page titles
    letterSpacing: 0,
    locale: currentLocale,
  );

  /// 28 sp — Standard page-level heading.
  /// Use for: AppBar titles on content-heavy screens, sheet headers.
  final headlineMedium = _createTextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    locale: currentLocale,
  );

  /// 24 sp — Compact page-level heading.
  /// Use for: section headings within a scrollable page, card group titles.
  final headlineSmall = _createTextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    locale: currentLocale,
  );

  // ── Title ─────────────────────────────────────────────────────────────────
  // Use for component-level titles and prominent labels inside cards,
  // lists, or dialogs. More emphasis than body, less than headline.

  /// 22 sp — Prominent component title.
  /// Use for: AppBar titles (standard), large list-section headers,
  ///          dialog/modal titles.
  final titleLarge = _createTextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    locale: currentLocale,
  );

  /// 16 sp — Standard component title.
  /// Use for: ListTile titles, card headings, tab labels, dropdown labels.
  final titleMedium = _createTextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    locale: currentLocale,
  );

  /// 14 sp — Compact component title.
  /// Use for: dense list item titles, chip labels, form field labels,
  ///          subtitle of a section.
  final titleSmall = _createTextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    locale: currentLocale,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  // Use for reading/content text. Optimised for legibility at comfortable
  // reading sizes. Default for paragraphs and descriptions.

  /// 16 sp — Primary body text.
  /// Use for: main paragraph text, message bubbles, article content,
  ///          default Text() inside cards.
  final bodyLarge = _createTextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    locale: currentLocale,
  );

  /// 14 sp — Standard body text (most common).
  /// Use for: secondary descriptions, ListTile subtitles, form helper text,
  ///          dialog body copy. This is the workhorse style.
  final bodyMedium = _createTextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    locale: currentLocale,
  );

  /// 12 sp — Small body / caption text.
  /// Use for: captions under images, timestamps, metadata, fine print,
  ///          secondary info below a ListTile.
  final bodySmall = _createTextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    locale: currentLocale,
  );

  // ── Label ─────────────────────────────────────────────────────────────────
  // Use for UI control labels, buttons, and navigation items.
  // NOT for body copy — these are designed to label interactive elements.

  /// 14 sp — Button and prominent control label.
  /// Use for: ElevatedButton / TextButton / OutlinedButton text,
  ///          navigation bar labels (selected), tab bar labels.
  final labelLarge = _createTextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    locale: currentLocale,
  );

  /// 12 sp — Standard control label.
  /// Use for: chip text, badge text, tooltip text, navigation rail labels,
  ///          input counter text, overline headings.
  final labelMedium = _createTextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    locale: currentLocale,
  );

  /// 11 sp — Smallest control label.
  /// Use for: dense navigation labels, very small badges, annotation text,
  ///          data table column headers. Avoid for reading-heavy content.
  final labelSmall = _createTextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    locale: currentLocale,
  );

  return TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}

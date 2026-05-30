import 'package:flutter/material.dart';

/// Etbaly Brand Color System - Purple + Gold
/// Matching the web version's design tokens
class EtbalyColorsExtension extends ThemeExtension<EtbalyColorsExtension> {
  const EtbalyColorsExtension({
    // Primary Purple
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.primaryGlow,
    required this.primaryGlowStrong,
    // Gold Accent
    required this.gold,
    required this.goldLight,
    required this.goldDark,
    required this.goldGlow,
    required this.goldGlowStrong,
    // Backgrounds
    required this.bgMain,
    required this.bgSecondary,
    required this.bgCard,
    required this.bgSubtle,
    // Text
    required this.textMain,
    required this.textMuted,
    required this.textLight,
    // Borders
    required this.borderColor,
    required this.borderSubtle,
    // Badge
    required this.badgeBg,
    // Shadows
    required this.shadowPrimary,
    required this.shadowPrimaryHover,
    required this.shadowGold,
    required this.shadowGoldHover,
    required this.cardShadow,
    required this.cardShadowHover,
    // Semantic
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  // Primary Purple
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color primaryGlow;
  final Color primaryGlowStrong;

  // Gold Accent
  final Color gold;
  final Color goldLight;
  final Color goldDark;
  final Color goldGlow;
  final Color goldGlowStrong;

  // Backgrounds
  final Color bgMain;
  final Color bgSecondary;
  final Color bgCard;
  final Color bgSubtle;

  // Text
  final Color textMain;
  final Color textMuted;
  final Color textLight;

  // Borders
  final Color borderColor;
  final Color borderSubtle;

  // Badge
  final Color badgeBg;

  // Shadows (stored as colors for reference, actual shadows use these)
  final Color shadowPrimary;
  final Color shadowPrimaryHover;
  final Color shadowGold;
  final Color shadowGoldHover;
  final Color cardShadow;
  final Color cardShadowHover;

  // Semantic
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;

  @override
  ThemeExtension<EtbalyColorsExtension> copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? primaryGlow,
    Color? primaryGlowStrong,
    Color? gold,
    Color? goldLight,
    Color? goldDark,
    Color? goldGlow,
    Color? goldGlowStrong,
    Color? bgMain,
    Color? bgSecondary,
    Color? bgCard,
    Color? bgSubtle,
    Color? textMain,
    Color? textMuted,
    Color? textLight,
    Color? borderColor,
    Color? borderSubtle,
    Color? badgeBg,
    Color? shadowPrimary,
    Color? shadowPrimaryHover,
    Color? shadowGold,
    Color? shadowGoldHover,
    Color? cardShadow,
    Color? cardShadowHover,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) {
    return EtbalyColorsExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryGlow: primaryGlow ?? this.primaryGlow,
      primaryGlowStrong: primaryGlowStrong ?? this.primaryGlowStrong,
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
      goldDark: goldDark ?? this.goldDark,
      goldGlow: goldGlow ?? this.goldGlow,
      goldGlowStrong: goldGlowStrong ?? this.goldGlowStrong,
      bgMain: bgMain ?? this.bgMain,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgCard: bgCard ?? this.bgCard,
      bgSubtle: bgSubtle ?? this.bgSubtle,
      textMain: textMain ?? this.textMain,
      textMuted: textMuted ?? this.textMuted,
      textLight: textLight ?? this.textLight,
      borderColor: borderColor ?? this.borderColor,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      badgeBg: badgeBg ?? this.badgeBg,
      shadowPrimary: shadowPrimary ?? this.shadowPrimary,
      shadowPrimaryHover: shadowPrimaryHover ?? this.shadowPrimaryHover,
      shadowGold: shadowGold ?? this.shadowGold,
      shadowGoldHover: shadowGoldHover ?? this.shadowGoldHover,
      cardShadow: cardShadow ?? this.cardShadow,
      cardShadowHover: cardShadowHover ?? this.cardShadowHover,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
    );
  }

  @override
  ThemeExtension<EtbalyColorsExtension> lerp(
    covariant ThemeExtension<EtbalyColorsExtension>? other,
    double t,
  ) {
    if (other is! EtbalyColorsExtension) {
      return this;
    }
    return EtbalyColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryGlow: Color.lerp(primaryGlow, other.primaryGlow, t)!,
      primaryGlowStrong:
          Color.lerp(primaryGlowStrong, other.primaryGlowStrong, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
      goldDark: Color.lerp(goldDark, other.goldDark, t)!,
      goldGlow: Color.lerp(goldGlow, other.goldGlow, t)!,
      goldGlowStrong: Color.lerp(goldGlowStrong, other.goldGlowStrong, t)!,
      bgMain: Color.lerp(bgMain, other.bgMain, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgCard: Color.lerp(bgCard, other.bgCard, t)!,
      bgSubtle: Color.lerp(bgSubtle, other.bgSubtle, t)!,
      textMain: Color.lerp(textMain, other.textMain, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      badgeBg: Color.lerp(badgeBg, other.badgeBg, t)!,
      shadowPrimary: Color.lerp(shadowPrimary, other.shadowPrimary, t)!,
      shadowPrimaryHover:
          Color.lerp(shadowPrimaryHover, other.shadowPrimaryHover, t)!,
      shadowGold: Color.lerp(shadowGold, other.shadowGold, t)!,
      shadowGoldHover: Color.lerp(shadowGoldHover, other.shadowGoldHover, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      cardShadowHover: Color.lerp(cardShadowHover, other.cardShadowHover, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
    );
  }
}

/// Light theme color palette - Balanced Day Mode (subtle purple hint)
class EtbalyLightPalette {
  EtbalyLightPalette._();

  static const colors = EtbalyColorsExtension(
    // Primary Purple
    primary: Color(0xFF6f3ff5),
    primaryLight: Color(0xFFb9a3ff),
    primaryDark: Color(0xFF4e22d4),
    primaryGlow: Color(0x2D6f3ff5), // rgba(111, 63, 245, 0.18)
    primaryGlowStrong: Color(0x6B6f3ff5), // rgba(111, 63, 245, 0.42)
    // Gold Accent
    gold: Color(0xFFd4af37),
    goldLight: Color(0xFFe8c878),
    goldDark: Color(0xFFb8922a),
    goldGlow: Color(0x2D6f3ff5), // Using primary glow
    goldGlowStrong: Color(0x616f3ff5),
    // Backgrounds
    bgMain: Color(0xFFf8f6fd),
    bgSecondary: Color(0xFFffffff),
    bgCard: Color(0xFFffffff),
    bgSubtle: Color(0xFFf0ecfb),
    // Text
    textMain: Color(0xFF12101c),
    textMuted: Color(0xFF524870),
    textLight: Color(0xFF8b80b4),
    // Borders
    borderColor: Color(0xFFddd8f2),
    borderSubtle: Color(0xFFe8e4f8),
    // Badge
    badgeBg: Color(0x176f3ff5), // rgba(111, 63, 245, 0.09)
    // Shadows
    shadowPrimary: Color(0x2D6f3ff5),
    shadowPrimaryHover: Color(0x526f3ff5),
    shadowGold: Color(0x266f3ff5),
    shadowGoldHover: Color(0x406f3ff5),
    cardShadow: Color(0x126f3ff5), // rgba(111, 63, 245, 0.07)
    cardShadowHover: Color(0x266f3ff5), // rgba(111, 63, 245, 0.15)
    // Semantic
    success: Color(0xFF2E7D32),
    onSuccess: Colors.white,
    warning: Color(0xFFED6C02),
    onWarning: Colors.white,
    info: Color(0xFF0288D1),
    onInfo: Colors.white,
  );
}

/// Dark theme color palette - Deep Purple Night
class EtbalyDarkPalette {
  EtbalyDarkPalette._();

  static const colors = EtbalyColorsExtension(
    // Primary Purple
    primary: Color(0xFF6f3ff5),
    primaryLight: Color(0xFFb9a3ff),
    primaryDark: Color(0xFF4e22d4),
    primaryGlow: Color(0x386f3ff5), // rgba(111, 63, 245, 0.22)
    primaryGlowStrong: Color(0x6B6f3ff5), // rgba(111, 63, 245, 0.42)
    // Gold Accent
    gold: Color(0xFFd4af37),
    goldLight: Color(0xFFe8c878),
    goldDark: Color(0xFFb8922a),
    goldGlow: Color(0x386f3ff5),
    goldGlowStrong: Color(0x616f3ff5),
    // Backgrounds
    bgMain: Color(0xFF0f0e18),
    bgSecondary: Color(0xFF16152a),
    bgCard: Color(0xFF1e1b30),
    bgSubtle: Color(0xFF252040),
    // Text
    textMain: Color(0xFFede8ff),
    textMuted: Color(0xFFb9a3ff),
    textLight: Color(0xFF8b7dc8),
    // Borders
    borderColor: Color(0xFF332d55),
    borderSubtle: Color(0xFF2a2448),
    // Badge
    badgeBg: Color(0x1Fb9a3ff), // rgba(185, 163, 255, 0.12)
    // Shadows
    shadowPrimary: Color(0x386f3ff5),
    shadowPrimaryHover: Color(0x526f3ff5),
    shadowGold: Color(0x26b9a3ff),
    shadowGoldHover: Color(0x40b9a3ff),
    cardShadow: Color(0x66000000), // rgba(0, 0, 0, 0.4)
    cardShadowHover: Color(0x1Ab9a3ff), // rgba(185, 163, 255, 0.1)
    // Semantic
    success: Color(0xFF81C784),
    onSuccess: Color(0xFF003300),
    warning: Color(0xFFFFB74D),
    onWarning: Color(0xFF5D4037),
    info: Color(0xFF4FC3F7),
    onInfo: Color(0xFF01579B),
  );
}

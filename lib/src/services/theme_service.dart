import 'package:flutter/material.dart';
import 'storage_service.dart';

class ThemeService {
  ThemeService._();
  static final ThemeService instance = ThemeService._();

  static const _kThemeKey = 'etbaly_theme_mode';

  late final ValueNotifier<ThemeMode> themeMode;

  Future<void> init() async {
    final saved = StorageService.instance.getString(_kThemeKey);
    final initial = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
    themeMode = ValueNotifier(initial);
  }

  Future<void> toggle() async {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = next;
    await StorageService.instance.setString(
      _kThemeKey,
      next == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  bool get isDark => themeMode.value == ThemeMode.dark;
}

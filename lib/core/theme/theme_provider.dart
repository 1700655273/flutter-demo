import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'app_theme.dart';

/// 主题模式枚举
enum ThemeModeOption {
  system('跟随系统', Icons.brightness_auto),
  light('亮色模式', Icons.light_mode),
  dark('暗色模式', Icons.dark_mode);

  final String label;
  final IconData icon;
  const ThemeModeOption(this.label, this.icon);

  ThemeMode toThemeMode() {
    switch (this) {
      case ThemeModeOption.system:
        return ThemeMode.system;
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
    }
  }

  static ThemeModeOption fromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return ThemeModeOption.system;
      case ThemeMode.light:
        return ThemeModeOption.light;
      case ThemeMode.dark:
        return ThemeModeOption.dark;
    }
  }
}

/// 主题状态管理
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeNotifier(this._prefs) : super(_loadTheme(_prefs));

  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final index = prefs.getInt(AppConstants.themeKey);
    if (index != null && index < ThemeModeOption.values.length) {
      return ThemeModeOption.values[index].toThemeMode();
    }
    return ThemeMode.system;
  }

  void setTheme(ThemeModeOption option) {
    state = option.toThemeMode();
    _prefs.setInt(AppConstants.themeKey, option.index);
  }

  ThemeData get currentTheme {
    return state == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}

/// 主题 Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('需要在 main 中覆盖');
});

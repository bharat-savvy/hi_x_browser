import 'package:flutter/material.dart';

enum ThemeModeType {
  system,
  light,
  dark,
}

class ThemeProvider with ChangeNotifier {
  ThemeModeType _themeModeType = ThemeModeType.system;

  ThemeModeType get themeModeType => _themeModeType;

  void setThemeModeType(ThemeModeType mode) {
    _themeModeType = mode;
    notifyListeners();
  }

  ThemeMode get themeMode {
    switch (_themeModeType) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }
}
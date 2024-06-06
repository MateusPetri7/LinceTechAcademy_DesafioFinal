import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appThemeModeKey = 'appThemeModeKey';

class ThemeModel extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeModel() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final savedThemeMode = _sharedPreferences.getString(appThemeModeKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
            (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system,
      );
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _sharedPreferences.setString(appThemeModeKey, mode.toString());
    notifyListeners();
  }
}

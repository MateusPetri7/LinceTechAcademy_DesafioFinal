import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A model class for managing the theme mode using SharedPreferences.
class ThemeModel extends ChangeNotifier {
  static const String _appThemeModeKey = 'appThemeModeKey';
  late SharedPreferences _sharedPreferences;
  ThemeMode _themeMode = ThemeMode.system;

  /// Getter to retrieve the current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Constructor that initializes the theme model and loads the saved theme mode.
  ThemeModel() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final savedThemeMode = _sharedPreferences.getString(_appThemeModeKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system,
      );
    }
    notifyListeners();
  }

  /// Sets the theme mode and saves it to SharedPreferences.
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _sharedPreferences.setString(_appThemeModeKey, mode.toString());
    notifyListeners();
  }
}

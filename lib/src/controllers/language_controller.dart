import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController with ChangeNotifier {
  static const String _languageKey = 'selectedLanguage';
  String _selectedLanguage = 'en';

  LanguageController() {
    _loadLanguage();
  }

  String get selectedLanguage => _selectedLanguage;

  Future<void> selectLanguage(String language) async {
    _selectedLanguage = language;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString(_languageKey) ?? 'en';
    notifyListeners();
  }
}

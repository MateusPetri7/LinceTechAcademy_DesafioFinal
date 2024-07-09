import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A model class for managing the selected language using SharedPreferences.
class LanguageModel extends ChangeNotifier {
  static const String _languageKey = 'selectedLanguage';
  String _selectedLanguage = 'en';

  /// Getter to retrieve the currently selected language.
  String get selectedLanguage => _selectedLanguage;

  /// Constructor that initializes the language model and loads the
  /// saved language.
  LanguageModel() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString(_languageKey) ?? 'en';
    notifyListeners();
  }

  /// Sets the selected language and saves it to SharedPreferences.
  ///
  /// This method updates the [_selectedLanguage] with the new value and
  /// saves it in the persistent storage. It also notifies listeners
  /// about the change.
  ///
  /// - [language]: The new language code to be set and saved.
  Future<void> setLanguage(String language) async {
    _selectedLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
    notifyListeners();
  }
}

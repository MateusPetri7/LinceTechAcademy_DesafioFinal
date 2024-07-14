// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/language_model.dart';

/// Controller class for managing language selection.
///
/// Provides a static method [selectLanguage] to update the language in
/// the [LanguageModel] instance using the [Provider] context.
class LanguageController {
  /// Selects a language and updates the [LanguageModel] instance.
  ///
  /// This method retrieves the [LanguageModel] from the [Provider] context
  /// and sets the specified [language].
  static void selectLanguage(BuildContext context, String language) {
    final languageModel = Provider.of<LanguageModel>(context, listen: false);
    languageModel.setLanguage(language);
  }
}

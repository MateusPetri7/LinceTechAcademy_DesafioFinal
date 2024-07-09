// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/language_model.dart';

/// A controller class for managing language selection.
class LanguageController {
  /// Static method to select a language.
  ///
  /// This method updates the language in the provided [LanguageModel] instance
  /// through the [Provider] context.
  static void selectLanguage(BuildContext context, String language) {
    final languageModel = Provider.of<LanguageModel>(context, listen: false);
    languageModel.setLanguage(language);
  }
}

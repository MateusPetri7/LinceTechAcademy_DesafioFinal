// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

/// A controller class for managing theme toggling.
class ThemeController {
  /// Static method to toggle between light and dark themes.
  ///
  /// This method toggles the theme in the provided [ThemeModel] instance
  /// through the [Provider] context.
  static void toggleTheme(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    if (themeModel.themeMode == ThemeMode.light) {
      themeModel.setThemeMode(ThemeMode.dark);
    } else if (themeModel.themeMode == ThemeMode.dark) {
      themeModel.setThemeMode(ThemeMode.light);
    } else {
      final platformBrightness = MediaQuery.of(context).platformBrightness;
      themeModel.setThemeMode(platformBrightness == Brightness.light
          ? ThemeMode.dark
          : ThemeMode.light);
    }
  }
}

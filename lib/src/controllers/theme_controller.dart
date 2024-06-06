import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ThemeController {
  static void toggleTheme(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    if (themeModel.themeMode == ThemeMode.light) {
      themeModel.setThemeMode(ThemeMode.dark);
    } else if (themeModel.themeMode == ThemeMode.dark) {
      themeModel.setThemeMode(ThemeMode.light);
    } else {
      final Brightness platformBrightness =
          MediaQuery.of(context).platformBrightness;
      themeModel.setThemeMode(
          platformBrightness == Brightness.light ? ThemeMode.dark : ThemeMode.light);
    }
  }
}

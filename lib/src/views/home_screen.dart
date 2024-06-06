import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/controllers/theme_controller.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/models/theme_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => ThemeController.toggleTheme(context),
          icon: Consumer<ThemeModel>(
            builder: (context, themeModel, _) {
              return Icon(
                themeModel.themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : themeModel.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.settings_brightness,
              );
            },
          ),
        ),
      ),
    );
  }
}

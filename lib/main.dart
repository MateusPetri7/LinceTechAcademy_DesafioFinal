import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/models/theme_model.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/views/my_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

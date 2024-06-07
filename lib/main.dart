import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/controllers/client_controller.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/models/theme_model.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/views/my_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider( providers: [
      ChangeNotifierProvider(create: (context) => ThemeModel()),
      ChangeNotifierProvider(create: (context) => ClientController()),
      ],
      child: const MyApp(),
    ),
  );
}

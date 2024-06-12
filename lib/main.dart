import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/controllers/client_controller.dart';
import 'src/models/theme_model.dart';
import 'src/views/my_app.dart';

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

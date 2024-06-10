import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/models/theme_model.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/views/home_screen.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/views/register_client.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/views/registered_clients.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, _) {
        return MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(),
            '/registerClient': (context) => RegisterClient(),
            '/registeredClient': (context) => RegisteredClients(),
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeModel.themeMode,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/theme_controller.dart';
import '../models/theme_model.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.registerClient
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text('Cadastrar Clientes'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      AppRoutes.registeredClients
                  );
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Listar Clientes'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      AppRoutes.registerManager
                  );
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Cadastrar Gerentes'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      AppRoutes.registeredManagers
                  );
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Listar Gerentes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

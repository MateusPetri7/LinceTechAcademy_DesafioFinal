import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/language_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/language_model.dart';
import '../models/theme_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 0) {
                ThemeController.toggleTheme(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Consumer<ThemeModel>(
                  builder: (context, themeModel, _) {
                    return Row(
                      children: [
                        Icon(
                          themeModel.themeMode == ThemeMode.light
                              ? Icons.dark_mode
                              : themeModel.themeMode == ThemeMode.dark
                                  ? Icons.light_mode
                                  : Icons.settings_brightness,
                        ),
                        const SizedBox(width: 8),
                        Text('Change Theme'),
                      ],
                    );
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Consumer<LanguageModel>(
                  builder: (context, state, _) {
                    return Row(
                      children: [
                        Icon(Icons.language),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: state.selectedLanguage,
                          onChanged: (String? language) {
                            if (language != null) {
                              LanguageController.selectLanguage(
                                  context, language);
                            }
                          },
                          items: <String>['pt', 'en']
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registerClient);
                },
                icon: const Icon(Icons.person),
                label: Text(AppLocalizations.of(context)!.language),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registeredClients);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Listar Clientes'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registerManager);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Cadastrar Gerentes'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registeredManagers);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Listar Gerentes'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registerVehicle);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Cadastrar Veículos'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registeredVehicles);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Listar Veículos'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registerRent);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Cadastrar alugueis'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registeredRent);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Aluguéis cadastrados'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.pdfView);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Pdf'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registeredPDF);
                },
                icon: const Icon(Icons.person_3),
                label: const Text('Pdf Lista'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

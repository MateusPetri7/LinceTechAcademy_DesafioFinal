import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/controllers/client_controller.dart';
import 'src/controllers/manager_controller.dart';
import 'src/models/theme_model.dart';
import 'src/repositories/client_repository.dart';
import 'src/services/http_client.dart';
import 'src/views/my_app.dart';

void main() {
  final httpClient = HttpClient();
  final clientRepository = ClientRepository(client: httpClient);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel()),
        ChangeNotifierProvider(
            create: (context) =>
                ClientController(clientRepository: clientRepository)),
        ChangeNotifierProvider(create: (context) => ManagerController()),
      ],
      child: const MyApp(),
    ),
  );
}

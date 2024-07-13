import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/controllers/client_controller.dart';
import 'src/controllers/image_controller.dart';
import 'src/controllers/manager_controller.dart';
import 'src/controllers/pdf_controller.dart';
import 'src/controllers/rent_controller.dart';
import 'src/controllers/vehicle_controller.dart';
import 'src/models/language_model.dart';
import 'src/models/theme_model.dart';
import 'src/repositories/client_repository.dart';
import 'src/repositories/vehicle_repository.dart';
import 'src/services/http_client.dart';
import 'src/views/my_app.dart';

void main() {
  final httpClient = HttpClient();
  final clientRepository = ClientRepository(client: httpClient);
  final vehicleRepository = VehicleRepository(client: httpClient);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel()),
        ChangeNotifierProvider(
            create: (context) =>
                ClientController(clientRepository: clientRepository)),
        ChangeNotifierProvider(create: (context) => ManagerController()),
        ChangeNotifierProvider(
            create: (context) =>
                VehicleController(vehicleRepository: vehicleRepository)),
        ChangeNotifierProvider(create: (context) => ImageController()),
        ChangeNotifierProvider(create: (context) => RentController()),
        ChangeNotifierProvider(create: (context) => PdfController()),
        ChangeNotifierProvider(create: (context) => LanguageModel()),
      ],
      child: const MyApp(),
    ),
  );
}

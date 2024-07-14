// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';
import 'src/models/client_model.dart';
import 'src/models/manager_model.dart';
import 'src/models/pdf_model.dart';
import 'src/models/rent_model.dart';
import 'src/models/vehicle_model.dart';
import 'src/views/client_details.dart';
import 'src/views/client_edit.dart';
import 'src/views/client_register.dart';
import 'src/views/clients_registered.dart';
import 'src/views/home_screen.dart';
import 'src/views/manager_edit.dart';
import 'src/views/manager_register.dart';
import 'src/views/managers_registered.dart';
import 'src/views/pdf_registered.dart';
import 'src/views/pdf_view.dart';
import 'src/views/rent_edit.dart';
import 'src/views/rent_register.dart';
import 'src/views/rent_registered.dart';
import 'src/views/vehicle_edit.dart';
import 'src/views/vehicle_register.dart';
import 'src/views/vehicles_registered.dart';

class AppRoutes {
  static const String home = '/';
  static const String registerClient = '/registerClient';
  static const String registeredClients = '/registeredClients';
  static const String editClient = '/editClient';
  static const String detailsClient = '/datailsClient';
  static const String registerManager = '/registerManager';
  static const String registeredManagers = '/registeredManagers';
  static const String editManager = '/editManager';
  static const String registerVehicle = '/registerVehicle';
  static const String registeredVehicles = '/registeredVehicles';
  static const String editVehicle = '/editVehicle';
  static const String registerRent = '/registerRent';
  static const String registeredRent = '/registeredRent';
  static const String editRent = '/editRent';
  static const String pdfView = '/pdfView';
  static const String registeredPDF = '/registeredPDF';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case registerClient:
        return MaterialPageRoute(builder: (_) => const RegisterClient());
      case registeredClients:
        return MaterialPageRoute(builder: (_) => const RegisteredClients());
      case editClient:
        final args = settings.arguments as ClientModel;
        return MaterialPageRoute(builder: (_) => EditClient(client: args));
      case detailsClient:
        final args = settings.arguments as ClientModel;
        return MaterialPageRoute(builder: (_) => DetailsClient(client: args));
      case registerManager:
        return MaterialPageRoute(builder: (_) => const RegisterManager());
      case registeredManagers:
        return MaterialPageRoute(builder: (_) => const RegisteredManagers());
      case editManager:
        final args = settings.arguments as ManagerModel;
        return MaterialPageRoute(builder: (_) => EditManager(manager: args));
      case registerVehicle:
        return MaterialPageRoute(builder: (_) => const RegisterVehicle());
      case registeredVehicles:
        return MaterialPageRoute(builder: (_) => const RegisteredVehicles());
      case editVehicle:
        final args = settings.arguments as VehicleModel;
        return MaterialPageRoute(builder: (_) => EditVehicle(vehicle: args));
      case registerRent:
        return MaterialPageRoute(builder: (_) => const RegisterRent());
      case registeredRent:
        return MaterialPageRoute(builder: (_) => const RegisteredRent());
      case editRent:
        final args = settings.arguments as RentModel;
        return MaterialPageRoute(
            builder: (_) => EditRent(rent: args));
      case pdfView:
        final args = settings.arguments as PdfModel;
        return MaterialPageRoute(
            builder: (_) => PdfView(pdf: args));
      case registeredPDF:
        return MaterialPageRoute(builder: (_) => const RegisteredPDF());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}

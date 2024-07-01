// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';
import 'src/models/client_model.dart';
import 'src/models/manager_model.dart';
import 'src/models/rentals_held_model.dart';
import 'src/models/vehicle_model.dart';
import 'src/views/client_edit.dart';
import 'src/views/client_register.dart';
import 'src/views/clients_registered.dart';
import 'src/views/home_screen.dart';
import 'src/views/manager_edit.dart';
import 'src/views/manager_register.dart';
import 'src/views/managers_registered.dart';
import 'src/views/rentals_held_edit.dart';
import 'src/views/rentals_held_register.dart';
import 'src/views/rentals_held_registered.dart';
import 'src/views/vehicle_edit.dart';
import 'src/views/vehicle_register.dart';
import 'src/views/vehicles_registered.dart';

class AppRoutes {
  static const String home = '/';
  static const String registerClient = '/registerClient';
  static const String registeredClients = '/registeredClients';
  static const String editClient = '/editClient';
  static const String registerManager = '/registerManager';
  static const String registeredManagers = '/registeredManagers';
  static const String editManager = '/editManager';
  static const String registerVehicle = '/registerVehicle';
  static const String registeredVehicles = '/registeredVehicles';
  static const String editVehicle = '/editVehicle';
  static const String registerRentals = '/registerRentals';
  static const String registeredRentalsHeld = '/registeredRentalsHeld';
  static const String editRentals = '/editRentals';

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
      case registerRentals:
        return MaterialPageRoute(builder: (_) => const RegisterRentalsHeld());
      case registeredRentalsHeld:
        return MaterialPageRoute(builder: (_) => const RegisteredRentalsHeld());
      case editRentals:
        final args = settings.arguments as RentalsHeldModel;
        return MaterialPageRoute(
            builder: (_) => EditRentalsHeld(rentals: args));
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}

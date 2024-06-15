import 'package:flutter/material.dart';
import 'src/models/client_model.dart';
import 'src/models/manager_model.dart';
import 'src/views/client_edit.dart';
import 'src/views/client_register.dart';
import 'src/views/clients_registered.dart';
import 'src/views/home_screen.dart';
import 'src/views/manager_edit.dart';
import 'src/views/manager_register.dart';
import 'src/views/managers_registered.dart';

class AppRoutes {
  static const String home = '/';
  static const String registerClient = '/registerClient';
  static const String registeredClients = '/registeredClients';
  static const String editClient = '/editClient';
  static const String registerManager = '/registerManager';
  static const String registeredManagers = '/registeredManagers';
  static const String editManager = '/editManager';

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
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}

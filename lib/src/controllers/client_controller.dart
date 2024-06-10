import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/models/client_model.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/controllers/database.dart'
    as database;

class ClientController extends ChangeNotifier {
  ClientController() {
    load();
  }
  final _controllerDataBase = database.ClientController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _tinController = TextEditingController();

  final _listClient = <ClientModel>[];

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;

  TextEditingController get telephoneController => _telephoneController;

  TextEditingController get cityController => _cityController;

  TextEditingController get stateController => _stateController;

  TextEditingController get tinController => _tinController;

  List<ClientModel> get listClient => _listClient;

  Future<void> insert() async {
    final client = ClientModel(
      name: nameController.text,
      telephone: telephoneController.text,
      city: cityController.text,
      state: stateController.text,
      tin: tinController.text,
    );

    await _controllerDataBase.insert(client);

    nameController.clear();
    telephoneController.clear();
    cityController.clear();
    stateController.clear();
    tinController.clear();

    notifyListeners();
  }

  Future<void> delete(ClientModel client) async {
    await _controllerDataBase.delete(client);
    await load();

    notifyListeners();
  }

  Future<void> load() async {
    final list = await _controllerDataBase.select();

    listClient.clear();
    listClient.addAll(list);

    notifyListeners();
  }
}

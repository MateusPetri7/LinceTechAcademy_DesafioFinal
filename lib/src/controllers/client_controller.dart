import 'package:flutter/material.dart';
import '../controllers/database.dart' as database;
import '../models/client_model.dart';

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
  ClientModel _clientCurrent = ClientModel();
  final _listClient = <ClientModel>[];

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get nameController => _nameController;

  TextEditingController get telephoneController => _telephoneController;

  TextEditingController get cityController => _cityController;

  TextEditingController get stateController => _stateController;

  TextEditingController get tinController => _tinController;

  List<ClientModel> get listClient => _listClient;

  ClientModel? get clientCurrent => _clientCurrent;

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

  void populateClientInformation(ClientModel client) {
    _nameController.text = client.name ?? '';
    _telephoneController.text = client.telephone ?? '';
    _cityController.text = client.city ?? '';
    _stateController.text = client.state ?? '';
    _tinController.text = client.tin ?? '';

    _clientCurrent = ClientModel(
        id: client.id,
    );
  }

  Future<void> update() async {
    final editedClient = ClientModel(
        id: _clientCurrent.id,
        name: nameController.text,
        telephone: telephoneController.text,
        city: cityController.text,
        state: stateController.text,
        tin: tinController.text
    );

    await _controllerDataBase.update(editedClient);

    _clientCurrent = ClientModel();
    nameController.clear();
    telephoneController.clear();
    cityController.clear();
    stateController.clear();
    tinController.clear();

    await load();

    notifyListeners();
  }
}

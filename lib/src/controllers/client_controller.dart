import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../repositories/client_repository.dart';
import '../services/exceptions.dart';
import 'databases/client_controller.dart' as database;
import 'databases/manager_controller.dart';

class ClientController extends ChangeNotifier {
  final IClientRepository clientRepository;

  ClientController({required this.clientRepository}) {
    load();
  }

  final _controllerDataBase = database.ClientController();
  final _managerControllerDatabase = ManagerController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _companyRegistrationNumberController = TextEditingController();
  final _managerController = TextEditingController();
  final _listClient = <ClientModel>[];
  ClientModel _clientCurrent = ClientModel();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get telephoneController => _telephoneController;
  TextEditingController get cityController => _cityController;
  TextEditingController get stateController => _stateController;
  TextEditingController get companyRegistrationNumberController =>
      _companyRegistrationNumberController;
  TextEditingController get managerController => _managerController;
  List<ClientModel> get listClient => _listClient;
  ClientModel get clientCurrent => _clientCurrent;

  Future<void> getClientData(String tin) async {
    try {
      final clientData = await clientRepository.getClientData(tin);
      _clientCurrent = clientData;
      notifyListeners();
    } on NotFoundException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getManagerFromState(String state) async {
    final manager = await _managerControllerDatabase.getManagerFromState(state);

    if (manager != null) {
      managerController.text = manager.name!;
    } else {
      managerController.text = 'Nenhum gerente encontrado';
    }

    notifyListeners();
  }

  Future<void> insert() async {
    final manager = await _managerControllerDatabase
        .getManagerFromState(stateController.text);
    final client = ClientModel(
      name: nameController.text,
      telephone: telephoneController.text,
      city: cityController.text,
      state: stateController.text,
      companyRegistrationNumber: companyRegistrationNumberController.text,
      managerId: manager!.id.toString(),
    );

    await _controllerDataBase.insert(client);

    _clearControllers();

    await load();
    notifyListeners();
  }

  Future<void> delete(ClientModel client) async {
    await _controllerDataBase.delete(client);
    await load();

    notifyListeners();
  }

  Future<void> load() async {
    final list = await _controllerDataBase.select();

    _listClient.clear();
    _listClient.addAll(list);

    notifyListeners();
  }

  void populateClientInformation(ClientModel client) {
    _nameController.text = client.name ?? '';
    _telephoneController.text = client.telephone ?? '';
    _cityController.text = client.city ?? '';
    _stateController.text = client.state ?? '';
    _companyRegistrationNumberController.text =
        client.companyRegistrationNumber ?? '';
    managerController.text =
        client.managerId != null ? client.managerId.toString() : '';

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
        companyRegistrationNumber: companyRegistrationNumberController.text,
        managerId: managerController.text);

    await _controllerDataBase.update(editedClient);

    _clientCurrent = ClientModel();

    _clearControllers();

    await load();
    notifyListeners();
  }

  void _clearControllers() {
    nameController.clear();
    telephoneController.clear();
    cityController.clear();
    stateController.clear();
    companyRegistrationNumberController.clear();
    managerController.clear();
  }
}

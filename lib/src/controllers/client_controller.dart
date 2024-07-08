import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/client_model.dart';
import '../models/manager_model.dart';
import '../repositories/client_repository.dart';
import '../services/exceptions.dart';
import 'databases/client_controller.dart' as database;
import 'databases/manager_controller.dart' as database_manager;

class ClientController extends ChangeNotifier {
  final IClientRepository clientRepository;

  ClientController({required this.clientRepository}) {
    load();
  }

  final _controllerDataBase = database.ClientController();
  final _managerControllerDatabase = database_manager.ManagerController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _cityController = TextEditingController();
  final List<String> _states = Estados.listaEstadosSigla;
  final _companyRegistrationNumberController = TextEditingController();
  List<ManagerModel> _listManager = <ManagerModel>[];
  final _listClient = <ClientModel>[];
  ClientModel _clientCurrent = ClientModel();
  String? _selectedState;
  ManagerModel? _selectedManager;

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get nameController => _nameController;

  TextEditingController get telephoneController => _telephoneController;

  TextEditingController get cityController => _cityController;

  List<String> get states => _states;

  TextEditingController get companyRegistrationNumberController =>
      _companyRegistrationNumberController;

  List<ManagerModel> get listManager => _listManager;

  List<ClientModel> get listClient => _listClient;

  ClientModel get clientCurrent => _clientCurrent;

  String? get selectedState => _selectedState;

  ManagerModel? get selectedManager => _selectedManager;

  set selectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  set selectedManager(ManagerModel? value) {
    _selectedManager = value;
    notifyListeners();
  }

  Future<void> getClientData(String companyRegistrationNumber) async {
    try {
      final clientData =
          await clientRepository.getClientData(companyRegistrationNumber);
      _clientCurrent = clientData;
      notifyListeners();
    } on NotFoundException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getManagersFromState(String state) async {
    _listManager = [];
    final managersList =
        await _managerControllerDatabase.getManagersFromState(state);
    _listManager = managersList;
    if (_listManager.length == 1) {
      _selectedManager = _listManager.first;
    }
    notifyListeners();
  }

  Future<void> getManagerFromClient(String state, String managerId) async {
    _listManager = await _managerControllerDatabase.getManagersFromState(state);

    final manager = _listManager.firstWhere(
          (m) => m.id.toString() == managerId,
      orElse: () => ManagerModel(id: null, name: 'Gerente não encontrado'),
    );

    if (manager.id != null) {
      _selectedManager = manager;
    } else {
      _selectedManager = null;
    }

    notifyListeners();
  }

  Future<void> insert() async {
    final client = ClientModel(
      name: nameController.text,
      telephone: telephoneController.text,
      city: cityController.text,
      state: selectedState,
      companyRegistrationNumber: companyRegistrationNumberController.text,
      managerId: _selectedManager!.id.toString(),
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

  Future<void> populateClientInformation(ClientModel client) async {
    await getManagerFromClient(client.state!, client.managerId.toString());

    _companyRegistrationNumberController.text =
        client.companyRegistrationNumber ?? '';
    _nameController.text = client.name ?? '';
    _telephoneController.text = client.telephone ?? '';
    _cityController.text = client.city ?? '';
    _selectedState = client.state;

    _clientCurrent = ClientModel(
      id: client.id,
    );
    notifyListeners();
  }

  Future<void> populateClientInformationAtRegistration(
      ClientModel client) async {
    _clearControllersWhenSwitchingCompanyRegistrationNumber();

    getManagersFromState(client.state!);

    _nameController.text = client.name ?? '';
    _telephoneController.text = formatTelephone(client.telephone);
    _cityController.text = client.city ?? '';
    _selectedState = client.state;

    _clientCurrent = ClientModel(
      id: client.id,
    );
    notifyListeners();
  }

  Future<void> update() async {
    final editedClient = ClientModel(
        id: _clientCurrent.id,
        name: nameController.text,
        telephone: telephoneController.text,
        city: cityController.text,
        state: selectedState,
        companyRegistrationNumber: companyRegistrationNumberController.text,
        managerId: _selectedManager!.id.toString());

    await _controllerDataBase.update(editedClient);

    _clientCurrent = ClientModel();

    _clearControllers();

    await load();
    notifyListeners();
  }

  void _clearControllers() {
    _companyRegistrationNumberController.clear();
    _nameController.clear();
    _telephoneController.clear();
    _cityController.clear();
    _selectedState = null;
    _selectedManager = null;
    _listManager = [];
  }

  void _clearControllersWhenSwitchingCompanyRegistrationNumber() {
    _nameController.clear();
    _telephoneController.clear();
    _cityController.clear();
    _selectedState = null;
    _selectedManager = null;
    _listManager = [];
  }

  String formatcompanyRegistrationNumber(String companyRegistrationNumber) {
    final cnpjMaskFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {'#': RegExp(r'[0-9]')},
    );
    return cnpjMaskFormatter.maskText(companyRegistrationNumber);
  }

  String formatTelephone(String? telephone) {
    if (telephone != null) {
      final phoneMaskFormatter = MaskTextInputFormatter(
        mask: '(##) #####-####',
        filter: {'#': RegExp(r'[0-9]')},
      );
      return phoneMaskFormatter.maskText(telephone);
    } else {
      return '';
    }
  }
}

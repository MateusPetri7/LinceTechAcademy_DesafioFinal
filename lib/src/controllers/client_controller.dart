import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/client_model.dart';
import '../models/manager_model.dart';
import '../repositories/client_repository.dart';
import '../services/exceptions.dart';
import 'databases/client_controller.dart' as database;
import 'databases/manager_controller.dart' as database_manager;

/// Controller for managing client data and interactions.
class ClientController extends ChangeNotifier {
  /// Repository for client data.
  final ClientRepository clientRepository;

  /// Constructor to initialize the client controller with the
  /// required [clientRepository].
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

  /// Returns the global form key used to manage the form state.
  GlobalKey<FormState> get formKey => _formKey;

  /// Returns the controller managing the client's name input field.
  TextEditingController get nameController => _nameController;

  /// Returns the controller managing the client's telephone input field.
  TextEditingController get telephoneController => _telephoneController;

  /// Returns the controller managing the client's city input field.
  TextEditingController get cityController => _cityController;

  /// Returns the list of Brazilian states abbreviations.
  List<String> get states => _states;

  /// Returns the controller managing the company registration number
  /// input field.
  TextEditingController get companyRegistrationNumberController =>
      _companyRegistrationNumberController;

  /// Returns the list of  managers possible to associate with clients.
  List<ManagerModel> get listManager => _listManager;

  /// Returns the list of clients managed by the controller.
  List<ClientModel> get listClient => _listClient;

  /// Returns the currently selected client.
  ClientModel get clientCurrent => _clientCurrent;

  /// Returns the currently selected state.
  String? get selectedState => _selectedState;

  /// Returns the currently selected manager.
  ManagerModel? get selectedManager => _selectedManager;

  set selectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  set selectedManager(ManagerModel? value) {
    _selectedManager = value;
    notifyListeners();
  }

  /// Fetches client data from the repository based on the
  /// company registration number.
  ///
  /// Throws a [NotFoundException] if the client data is not found.
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

  /// Fetches managers from the database based on the state.
  Future<void> getManagersFromState(String state) async {
    _selectedManager = null;
    _listManager = [];
    final managersList =
        await _managerControllerDatabase.getManagersFromState(state);
    _listManager = managersList;
    if (_listManager.length == 1) {
      _selectedManager = _listManager.first;
    }
    notifyListeners();
  }

  Future<void> _getManagerFromClient(String state, String managerId) async {
    _listManager = await _managerControllerDatabase.getManagersFromState(state);

    final manager = _listManager.firstWhere(
      (m) => m.id.toString() == managerId,
      orElse: () => ManagerModel(id: null, name: ''),
    );

    if (manager.id != null) {
      _selectedManager = manager;
    } else {
      _selectedManager = null;
    }

    notifyListeners();
  }

  /// Inserts a new client into the database.
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

  /// Deletes a client from the database.
  Future<void> delete(ClientModel client) async {
    await _controllerDataBase.delete(client);
    await load();

    notifyListeners();
  }

  /// Loads all clients from the database.
  Future<void> load() async {
    final list = await _controllerDataBase.select();

    _listClient.clear();
    _listClient.addAll(list);

    notifyListeners();
  }

  /// Populates client information based on a given client model.
  Future<void> populateClientInformation(ClientModel client) async {
    await _getManagerFromClient(client.state!, client.managerId.toString());

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

  /// Populates client information during registration based
  /// on a given client model.
  Future<void> populateClientInformationAtRegistration(
      ClientModel client) async {
    _clearControllersWhenSwitchingCompanyRegistrationNumber();

    await getManagersFromState(client.state!);

    _nameController.text = client.name ?? '';
    _telephoneController.text = _formatTelephone(client.telephone);
    _cityController.text = client.city ?? '';
    _selectedState = client.state;

    notifyListeners();
  }

  /// Updates client information in the database.
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

  String _formatTelephone(String? telephone) {
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

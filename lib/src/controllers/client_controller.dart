import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  final List<String> _states = Estados.listaEstadosSigla;
  final _companyRegistrationNumberController = TextEditingController();
  final _managerController = TextEditingController();
  final _listClient = <ClientModel>[];
  ClientModel _clientCurrent = ClientModel();
  String? _selectedState;

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get nameController => _nameController;

  TextEditingController get telephoneController => _telephoneController;

  TextEditingController get cityController => _cityController;

  List<String> get states => _states;

  TextEditingController get companyRegistrationNumberController =>
      _companyRegistrationNumberController;

  TextEditingController get managerController => _managerController;

  List<ClientModel> get listClient => _listClient;

  ClientModel get clientCurrent => _clientCurrent;

  String? get selectedState => _selectedState;

  set selectedState(String? value) {
    _selectedState = value;
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

  Future<void> getManagerFromState(String state) async {
    final manager = await _managerControllerDatabase.getManagerFromState(state);
    managerController.text = manager?.name ?? 'Nenhum gerente encontrado';
    notifyListeners();
  }

  Future<void> insert() async {
    final manager =
        await _managerControllerDatabase.getManagerFromState(selectedState!);
    final client = ClientModel(
      name: nameController.text,
      telephone: telephoneController.text,
      city: cityController.text,
      state: selectedState,
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

  void populateClientInformation(ClientModel client) async {
    final manager = await _managerControllerDatabase
        .getManagerFromId(client.managerId.toString());
    _nameController.text = client.name ?? '';
    _telephoneController.text = client.telephone ?? '';
    _cityController.text = client.city ?? '';
    selectedState = client.state;
    _companyRegistrationNumberController.text =
        client.companyRegistrationNumber ?? '';
    managerController.text = manager?.name ?? '';

    _clientCurrent = ClientModel(
      id: client.id,
    );
  }

  Future<void> populateClientInformationAtRegistration(
      ClientModel client) async {
    final manager =
        await _managerControllerDatabase.getManagerFromState(client.state!);

    _nameController.text = client.name ?? '';
    _telephoneController.text = formatTelephone(client.telephone);
    _cityController.text = client.city ?? '';
    selectedState = client.state;
    managerController.text = manager?.name ?? '';

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
        state: selectedState,
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
    companyRegistrationNumberController.clear();
    managerController.clear();
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

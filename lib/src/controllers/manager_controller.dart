import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import '../models/manager_model.dart';
import 'databases/manager_controller.dart' as database;

class ManagerController extends ChangeNotifier {
  ManagerController() {
    load();
  }
  final _controllerDataBase = database.ManagerController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _individualTaxpayerRegistryController = TextEditingController();
  final List<String> _states = Estados.listaEstadosSigla;
  final _telephoneController = TextEditingController();
  final _commissionPercentageController = TextEditingController();
  final _listManager = <ManagerModel>[];
  ManagerModel _managerCurrent = ManagerModel();
  String? _selectedState;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get individualTaxpayerRegistryController =>
      _individualTaxpayerRegistryController;
  List<String> get states => _states;
  TextEditingController get telephoneController => _telephoneController;
  TextEditingController get commissionPercentageController =>
      _commissionPercentageController;
  List<ManagerModel> get listManager => _listManager;
  ManagerModel get managerCurrent => _managerCurrent;
  String? get selectedState => _selectedState;

  set selectedState(String? value) {
    print('Setting selectedState: $value');
    _selectedState = null;
    _selectedState = value;
    notifyListeners();
  }

  Future<void> insert() async {
    final manager = ManagerModel(
        name: nameController.text,
        individualTaxpayerRegistry: individualTaxpayerRegistryController.text,
        state: _selectedState,
        telephone: telephoneController.text,
        commissionPercentage: commissionPercentageController.text);

    await _controllerDataBase.insert(manager);

    _clearControllers();

    await load();
    notifyListeners();
  }

  Future<void> delete(ManagerModel manager) async {
    await _controllerDataBase.delete(manager);
    await load();

    notifyListeners();
  }

  Future<void> load() async {
    final list = await _controllerDataBase.select();

    _listManager.clear();
    _listManager.addAll(list);

    notifyListeners();
  }

  void populateManagerInformation(ManagerModel manager) {
    _nameController.text = manager.name ?? '';
    _individualTaxpayerRegistryController.text =
        manager.individualTaxpayerRegistry ?? '';
    _selectedState = manager.state ?? '';
    _telephoneController.text = manager.telephone ?? '';
    _commissionPercentageController.text = manager.commissionPercentage ?? '';

    _managerCurrent = ManagerModel(
      id: manager.id,
    );

    notifyListeners();
  }

  Future<void> update() async {
    final editedManager = ManagerModel(
        id: _managerCurrent.id,
        name: nameController.text,
        individualTaxpayerRegistry: individualTaxpayerRegistryController.text,
        state: selectedState,
        telephone: telephoneController.text,
        commissionPercentage: commissionPercentageController.text);

    print('Updating manager: ${editedManager.state}');
    await _controllerDataBase.update(editedManager);

    _managerCurrent = ManagerModel();
    _clearControllers();

    await load();
    notifyListeners();
  }

  void _clearControllers() {
    nameController.clear();
    individualTaxpayerRegistryController.clear();
    telephoneController.clear();
    commissionPercentageController.clear();
    selectedState = null;
  }
}

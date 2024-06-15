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
  final _stateController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _commissionPercentageController = TextEditingController();
  final _listManager = <ManagerModel>[];
  ManagerModel _managerCurrent = ManagerModel();

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get nameController => _nameController;

  TextEditingController get individualTaxpayerRegistryController =>
      _individualTaxpayerRegistryController;

  TextEditingController get stateController => _stateController;

  TextEditingController get telephoneController => _telephoneController;

  TextEditingController get commissionPercentageController =>
      _commissionPercentageController;

  List<ManagerModel> get listManager => _listManager;

  ManagerModel get managerCurrent => _managerCurrent;

  Future<void> insert() async {
    final manager = ManagerModel(
        name: nameController.text,
        individualTaxpayerRegistry: individualTaxpayerRegistryController.text,
        state: stateController.text,
        telephone: telephoneController.text,
        commissionPercentage: commissionPercentageController.text);

    await _controllerDataBase.insert(manager);

    nameController.clear();
    individualTaxpayerRegistryController.clear();
    stateController.clear();
    telephoneController.clear();
    commissionPercentageController.clear();

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
    _individualTaxpayerRegistryController.text = manager.individualTaxpayerRegistry ?? '';
    _stateController.text = manager.state ?? '';
    _telephoneController.text = manager.telephone ?? '';
    _commissionPercentageController.text = manager.commissionPercentage ?? '';

    _managerCurrent = ManagerModel(
      id: manager.id,
    );
  }

  Future<void> update() async {
    final editedManager = ManagerModel(
        id: _managerCurrent.id,
        name: nameController.text,
        individualTaxpayerRegistry: individualTaxpayerRegistryController.text,
        state: stateController.text,
        telephone: telephoneController.text,
        commissionPercentage: commissionPercentageController.text);

    await _controllerDataBase.update(editedManager);

    _managerCurrent = ManagerModel();
    nameController.clear();
    individualTaxpayerRegistryController.clear();
    stateController.clear();
    telephoneController.clear();
    commissionPercentageController.clear();

    await load();
    notifyListeners();
  }
}

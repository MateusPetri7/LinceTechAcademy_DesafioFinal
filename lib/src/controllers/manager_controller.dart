import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import '../models/manager_model.dart';
import 'databases/manager_controller.dart' as database;

/// Controller class for managing manager data and interactions.
///
/// Provides methods to insert, delete, update, and load manager data.
class ManagerController extends ChangeNotifier {
  /// Constructs a [ManagerController] and initiates data loading.
  ManagerController() {
    load();
  }
  final _controllerDataBase = database.ManagerController();
  final _nameController = TextEditingController();
  final _individualTaxpayerRegistryController = TextEditingController();
  final List<String> _states = Estados.listaEstadosSigla;
  final _telephoneController = TextEditingController();
  final _commissionPercentageController = TextEditingController();
  final _listManager = <ManagerModel>[];
  ManagerModel _managerCurrent = ManagerModel();
  String? _selectedState;

  /// Returns the controller managing the manager's name input field.
  TextEditingController get nameController => _nameController;
  /// Returns the controller managing the manager's individual taxpayer registry
  /// input field.
  TextEditingController get individualTaxpayerRegistryController =>
      _individualTaxpayerRegistryController;
  /// Returns the list of Brazilian states abbreviations.
  List<String> get states => _states;
  /// Returns the controller managing the manager's telephone input field.
  TextEditingController get telephoneController => _telephoneController;
  /// Returns the controller managing the manager's commission percentage
  /// input field.
  TextEditingController get commissionPercentageController =>
      _commissionPercentageController;
  /// Returns the list of managers managed by the controller.
  List<ManagerModel> get listManager => _listManager;
  /// Returns the currently selected manager.
  ManagerModel get managerCurrent => _managerCurrent;
  /// Returns the currently selected state.
  String? get selectedState => _selectedState;

  set selectedState(String? value) {
    _selectedState = null;
    _selectedState = value;
    notifyListeners();
  }

  GlobalKey<FormState> generateFormKey() {
    return GlobalKey<FormState>();
  }

  /// Inserts a new manager into the database.
  ///
  /// Clears input controllers, reloads the manager list from the database,
  /// and notifies listeners.
  Future<void> insert() async {
    final manager = ManagerModel(
        name: nameController.text,
        individualTaxpayerRegistry: individualTaxpayerRegistryController.text,
        state: _selectedState,
        telephone: telephoneController.text,
        commissionPercentage: commissionPercentageController.text);

    await _controllerDataBase.insert(manager);

    clearControllers();

    await load();
    notifyListeners();
  }

  /// Deletes a manager from the database.
  ///
  /// Reloads the manager list from the database and notifies listeners
  /// after deletion.
  Future<void> delete(ManagerModel manager) async {
    await _controllerDataBase.delete(manager);
    await load();

    notifyListeners();
  }

  /// Loads all managers from the database.
  ///
  /// Clears the current list of managers, fetches the updated list from
  /// database, and notifies listeners of the change.
  Future<void> load() async {
    final list = await _controllerDataBase.select();

    _listManager.clear();
    _listManager.addAll(list);

    notifyListeners();
  }

  /// Populates manager information based on a given manager model.
  ///
  /// Sets input controllers with the provided manager's data and updates
  /// Notifies listeners of the change.
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

  /// Updates manager information in the database.
  ///
  /// Clears input controllers after updating the manager's data in the
  /// database, reloads the manager list, and notifies listeners of the change.
  Future<void> update() async {
    final editedManager = ManagerModel(
        id: _managerCurrent.id,
        name: nameController.text,
        individualTaxpayerRegistry: individualTaxpayerRegistryController.text,
        state: selectedState,
        telephone: telephoneController.text,
        commissionPercentage: commissionPercentageController.text);

    await _controllerDataBase.update(editedManager);

    _managerCurrent = ManagerModel();
    clearControllers();

    await load();
    notifyListeners();
  }

  void clearControllers() {
    nameController.clear();
    individualTaxpayerRegistryController.clear();
    telephoneController.clear();
    commissionPercentageController.clear();
    selectedState = null;
  }
}

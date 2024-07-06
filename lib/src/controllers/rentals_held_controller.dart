import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../models/rentals_held_model.dart';
import '../models/vehicle_model.dart';
import 'databases/client_controller.dart' as database_client;
import 'databases/manager_controller.dart' as database_manager;
import 'databases/rentals_held_controller.dart' as database;
import 'databases/vehicle_controller.dart' as database_vehicle;

class RentalsHeldController extends ChangeNotifier {
  RentalsHeldController() {
    load();
    loadVehicles();
  }

  final _controllerDataBase = database.RentalsHeldController();
  final _clientControllerDataBase = database_client.ClientController();
  final _vehicleControllerDataBase = database_vehicle.VehicleController();
  final _managerControllerDataBase = database_manager.ManagerController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _states = Estados.listaEstadosSigla;
  String? _selectedState;
  final _listClient = <ClientModel>[];
  ClientModel? _selectedClient;
  final _listVehicle = <VehicleModel>[];
  VehicleModel? _selectedVehicle;

  //final _clientIdController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _numberOfDaysController = TextEditingController();
  final _totalAmountPayableController = TextEditingController();
  final _percentageManagerCommissionController = TextEditingController();
  final _managerCommissionValueController = TextEditingController();
  final _listRentalsHeld = <RentalsHeldModel>[];
  RentalsHeldModel _rentalsCurrent = RentalsHeldModel();

  GlobalKey<FormState> get formKey => _formKey;

  List<String> get states => _states;

  String? get selectedState => _selectedState;

  List<ClientModel> get listClient => _listClient;

  ClientModel? get selectedClient => _selectedClient;

  List<VehicleModel> get listVehicle => _listVehicle;

  VehicleModel? get selectedVehicle => _selectedVehicle;

  //TextEditingController get clientIdController => _clientIdController;

  TextEditingController get startDateController => _startDateController;

  TextEditingController get endDateController => _endDateController;

  TextEditingController get numberOfDaysController => _numberOfDaysController;

  TextEditingController get totalAmountPayableController =>
      _totalAmountPayableController;

  TextEditingController get percentageManagerCommissionController =>
      _percentageManagerCommissionController;

  TextEditingController get managerCommissionValueController =>
      _managerCommissionValueController;

  List<RentalsHeldModel> get listRentalsHeld => _listRentalsHeld;

  RentalsHeldModel get rentalsCurrent => _rentalsCurrent;

  set selectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  set selectedClient(ClientModel? value) {
    _selectedClient = value;
    if (_selectedClient != null) {
      setPercentageManagerCommission(_selectedClient!.managerId.toString());
    }
    notifyListeners();
  }

  set selectedVehicle(VehicleModel? value) {
    _selectedVehicle = value;
    calculateTotalValue();
    notifyListeners();
  }

  Future<void> setPercentageManagerCommission(String id) async {
    final manager = await _managerControllerDataBase.getManagerFromId(id);
    if (manager != null) {
      _percentageManagerCommissionController.text =
          manager.commissionPercentage ?? '';
    }
  }

  void calculateManagerCommissionValue(
      double rentalsValue, String percentageManagerCommission) {

  }

  Future<void> loadClients(String state) async {
    final list = await _clientControllerDataBase.getClientsFromState(state);
    _listClient.clear();
    _listClient.addAll(list);
    notifyListeners();
  }

  Future<void> loadVehicles() async {
    final list = await _vehicleControllerDataBase.select();
    _listVehicle.clear();
    _listVehicle.addAll(list);
    notifyListeners();
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = UtilData.obterDataDDMMAAAA(picked);
      calculateNumberOfDays();
      notifyListeners();
    }
  }

  void calculateNumberOfDays() {
    if (_startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty) {
      final startDate = DateTime.parse(
          _startDateController.text.split('/').reversed.join('-'));
      final endDate =
          DateTime.parse(_endDateController.text.split('/').reversed.join('-'));
      final difference = endDate.difference(startDate).inDays;
      _numberOfDaysController.text = difference.toString();
      calculateTotalValue();
      notifyListeners();
    }
  }

  void calculateTotalValue() {
    if (_numberOfDaysController.text.isNotEmpty && selectedVehicle != null) {
      final dailyRentalCost = selectedVehicle?.dailyRentalCost ?? 0;
      final totalValue =
          dailyRentalCost * int.parse(_numberOfDaysController.text);
      _totalAmountPayableController.text = totalValue.toStringAsFixed(2);
    }
  }

  Future<void> insert() async {
    final rentals = RentalsHeldModel(
      clientId: _selectedClient?.id,
      vehicleId: _selectedVehicle?.id,
      startDate: DateTime.parse(
          _startDateController.text.split('/').reversed.join('-')),
      endDate:
          DateTime.parse(_endDateController.text.split('/').reversed.join('-')),
      numberOfDays: int.parse(_numberOfDaysController.text),
      totalAmountPayable: double.parse(_totalAmountPayableController.text),
    );

    await _controllerDataBase.insert(rentals);

    _clearControllers();

    await load();
    notifyListeners();
  }

  Future<void> delete(RentalsHeldModel rentalsHeld) async {
    await _controllerDataBase.delete(rentalsHeld);
    await load();
    notifyListeners();
  }

  Future<void> load() async {
    final list = await _controllerDataBase.select();

    _listRentalsHeld.clear();
    _listRentalsHeld.addAll(list);

    notifyListeners();
  }

  Future<void> populateRentalInformation(RentalsHeldModel rentals) async {
    _startDateController.text = rentals.startDate != null
        ? UtilData.obterDataDDMMAAAA(rentals.startDate!)
        : '';
    _endDateController.text = rentals.endDate != null
        ? UtilData.obterDataDDMMAAAA(rentals.endDate!)
        : '';
    _numberOfDaysController.text = rentals.numberOfDays?.toString() ?? '';
    _totalAmountPayableController.text =
        rentals.totalAmountPayable?.toString() ?? '';

    _rentalsCurrent = rentals;

    final client = await _clientControllerDataBase
        .getClientFromId(rentals.clientId.toString());
    _selectedClient = client;

    if (client != null) {
      _selectedState = client.state;
      await loadClients(client.state!);
    }

    final vehicle = await _vehicleControllerDataBase
        .getVehicleFromId(rentals.vehicleId.toString());
    _selectedVehicle = vehicle;

    notifyListeners();
  }

  Future<void> update() async {
    final editedRental = RentalsHeldModel(
      id: _rentalsCurrent.id,
      clientId: selectedClient?.id,
      vehicleId: _selectedVehicle?.id,
      startDate: DateTime.parse(
          _startDateController.text.split('/').reversed.join('-')),
      endDate:
          DateTime.parse(_endDateController.text.split('/').reversed.join('-')),
      numberOfDays: int.parse(_numberOfDaysController.text),
      totalAmountPayable: double.parse(_totalAmountPayableController.text),
    );

    await _controllerDataBase.update(editedRental);

    _rentalsCurrent = RentalsHeldModel();
    _clearControllers();
    await load();
    notifyListeners();
  }

  void _clearControllers() {
    _selectedState = null;
    _selectedClient = null;
    _selectedVehicle = null;
    _startDateController.clear();
    _endDateController.clear();
    _numberOfDaysController.clear();
    _totalAmountPayableController.clear();
  }
}

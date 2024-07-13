import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../models/rent_model.dart';
import '../models/vehicle_model.dart';
import 'databases/client_controller.dart' as database_client;
import 'databases/manager_controller.dart' as database_manager;
import 'databases/rent_controller.dart' as database;
import 'databases/vehicle_controller.dart' as database_vehicle;

class RentController extends ChangeNotifier {
  RentController() {
    load();
    loadClients();
  }

  final _controllerDataBase = database.RentController();
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
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _numberOfDaysController = TextEditingController();
  final _totalAmountPayableController = TextEditingController();
  final _percentageManagerCommissionController = TextEditingController();
  final _managerCommissionValueController = TextEditingController();
  final _listRent = <RentModel>[];
  RentModel? _rentCurrent = RentModel();

  GlobalKey<FormState> get formKey => _formKey;

  List<String> get states => _states;

  String? get selectedState => _selectedState;

  List<ClientModel> get listClient => _listClient;

  ClientModel? get selectedClient => _selectedClient;

  List<VehicleModel> get listVehicle => _listVehicle;

  VehicleModel? get selectedVehicle => _selectedVehicle;

  TextEditingController get startDateController => _startDateController;

  TextEditingController get endDateController => _endDateController;

  TextEditingController get numberOfDaysController => _numberOfDaysController;

  TextEditingController get totalAmountPayableController =>
      _totalAmountPayableController;

  TextEditingController get percentageManagerCommissionController =>
      _percentageManagerCommissionController;

  TextEditingController get managerCommissionValueController =>
      _managerCommissionValueController;

  List<RentModel> get listRent => _listRent;

  RentModel? get rentCurrent => _rentCurrent;

  set selectedState(String? value) {
    _selectedVehicle = null;
    _selectedState = value;
    notifyListeners();
  }

  set selectedClient(ClientModel? value) {
    _selectedClient = value;
    if (_selectedClient != null) {
      _setPercentageManagerCommission(_selectedClient!.managerId.toString());
    }
    notifyListeners();
  }

  set selectedVehicle(VehicleModel? value) {
    _selectedVehicle = value;
    calculateTotalValue();
    notifyListeners();
  }

  Future<void> _setPercentageManagerCommission(String id) async {
    final manager = await _managerControllerDataBase.getManagerFromId(id);
    if (manager != null) {
      _percentageManagerCommissionController.text =
          manager.commissionPercentage ?? '';
    }
  }

  void _setManagerCommissionValue() {
    if (_totalAmountPayableController.text.isNotEmpty &&
        _percentageManagerCommissionController.text.isNotEmpty) {
      _calculateManagerCommissionValue(
        double.tryParse(_totalAmountPayableController.text)!,
        double.tryParse(_percentageManagerCommissionController.text)!,
      );
    }
  }

  void _calculateManagerCommissionValue(
      double rentValue, double percentageManagerCommission) {
    final managerCommissionValue =
        rentValue * (percentageManagerCommission / 100);
    _managerCommissionValueController.text =
        managerCommissionValue.toStringAsFixed(2);
    notifyListeners();
  }

  Future<void> loadClients() async {
    final list = await _clientControllerDataBase.select();
    _listClient.clear();
    _listClient.addAll(list);
    notifyListeners();
  }

  Future<void> loadVehicles(String state) async {
    final list = await _vehicleControllerDataBase.getVehiclesFromState(state);
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
      _setManagerCommissionValue();
    }
  }

  Future<void> insert() async {
    final rent = RentModel(
        rentState: _selectedState,
        clientId: _selectedClient?.id,
        vehicleId: _selectedVehicle?.id,
        startDate: DateTime.parse(
            _startDateController.text.split('/').reversed.join('-')),
        endDate: DateTime.parse(
            _endDateController.text.split('/').reversed.join('-')),
        numberOfDays: int.parse(_numberOfDaysController.text),
        totalAmountPayable: double.parse(_totalAmountPayableController.text),
        percentageManagerCommission: _percentageManagerCommissionController.text,
        managerCommissionValue:
            double.parse(_managerCommissionValueController.text));

    final id = await _controllerDataBase.insert(rent);
    _rentCurrent = await _controllerDataBase.getRentsFromId(id.toString());

    await load();
    notifyListeners();
  }

  Future<void> delete(RentModel rent) async {
    await _controllerDataBase.delete(rent);
    await load();
    notifyListeners();
  }

  Future<void> load() async {
    final list = await _controllerDataBase.select();

    _listRent.clear();
    _listRent.addAll(list);

    notifyListeners();
  }

  Future<void> populateRentInformation(RentModel rent) async {
    _startDateController.text = rent.startDate != null
        ? UtilData.obterDataDDMMAAAA(rent.startDate!)
        : '';
    _endDateController.text = rent.endDate != null
        ? UtilData.obterDataDDMMAAAA(rent.endDate!)
        : '';
    _numberOfDaysController.text = rent.numberOfDays?.toString() ?? '';
    _totalAmountPayableController.text =
        rent.totalAmountPayable?.toString() ?? '';

    _rentCurrent = rent;

    final client = await _clientControllerDataBase
        .getClientFromId(rent.clientId.toString());
    _selectedClient = client;

    // if (client != null) {
    //   _selectedState = client.state;
    //   await loadClients(client.state!);
    // }

    final vehicle = await _vehicleControllerDataBase
        .getVehicleFromId(rent.vehicleId.toString());
    _selectedVehicle = vehicle;

    notifyListeners();
  }

  Future<void> update() async {
    final editedRent = RentModel(
      id: _rentCurrent!.id,
      clientId: selectedClient?.id,
      vehicleId: _selectedVehicle?.id,
      startDate: DateTime.parse(
          _startDateController.text.split('/').reversed.join('-')),
      endDate:
          DateTime.parse(_endDateController.text.split('/').reversed.join('-')),
      numberOfDays: int.parse(_numberOfDaysController.text),
      totalAmountPayable: double.parse(_totalAmountPayableController.text),
    );

    await _controllerDataBase.update(editedRent);

    _rentCurrent = RentModel();
    clearControllers();
    await load();
    notifyListeners();
  }

  void clearControllers() {
    _selectedState = null;
    _selectedClient = null;
    _selectedVehicle = null;
    _startDateController.clear();
    _endDateController.clear();
    _numberOfDaysController.clear();
    _totalAmountPayableController.clear();
    _percentageManagerCommissionController.clear();
    _managerCommissionValueController.clear();
  }
}

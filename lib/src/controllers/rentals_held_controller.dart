import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../models/rentals_held_model.dart';
import 'databases/client_controller.dart' as database_client;
import 'databases/rentals_held_controller.dart' as database;

class RentalsHeldController extends ChangeNotifier {
  RentalsHeldController() {
    load();
  }

  final _controllerDataBase = database.RentalsHeldController();
  final _clientControllerDataBase = database_client.ClientController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _states = Estados.listaEstadosSigla;
  String? _selectedState;
  final _listClient = <ClientModel>[];
  ClientModel? _selectedClient;
  //final _clientIdController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _numberOfDaysController = TextEditingController();
  final _totalAmountPayableController = TextEditingController();
  final _listRentalsHeld = <RentalsHeldModel>[];
  RentalsHeldModel _rentalsCurrent = RentalsHeldModel();

  GlobalKey<FormState> get formKey => _formKey;

  List<String> get states => _states;

  String? get selectedState => _selectedState;

  List<ClientModel> get listClient => _listClient;

  ClientModel? get selectedClient => _selectedClient;

  //TextEditingController get clientIdController => _clientIdController;

  TextEditingController get startDateController => _startDateController;

  TextEditingController get endDateController => _endDateController;

  TextEditingController get numberOfDaysController => _numberOfDaysController;

  TextEditingController get totalAmountPayableController =>
      _totalAmountPayableController;

  List<RentalsHeldModel> get listRentalsHeld => _listRentalsHeld;

  RentalsHeldModel get rentalsCurrent => _rentalsCurrent;

  set selectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  set selectedClient(ClientModel? value) {
    _selectedClient = value;
    notifyListeners();
  }

  Future<void> loadClients(String state) async {
    final list = await _clientControllerDataBase.getClientsFromState(state);
    _listClient.clear();
    _listClient.addAll(list);
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = UtilData.obterDataDDMMAAAA(picked);
      notifyListeners();
    }
  }

  Future<void> insert() async {
    final rentals = RentalsHeldModel(
      clientId: _selectedClient?.id,
      startDate: DateTime.parse(_startDateController.text),
      endDate: DateTime.parse(_endDateController.text),
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

  // void populateRentalInformation(RentalsHeldModel rentalsHeld) {
  //   _clientIdController.text = rentalsHeld.clientId ?? '';
  //   _startDateController.text = rentalsHeld.startDate?.toIso8601String() ?? '';
  //   _endDateController.text = rentalsHeld.endDate?.toIso8601String() ?? '';
  //   _numberOfDaysController.text = rentalsHeld.numberOfDays.toString();
  //   _totalAmountPayableController.text = rentalsHeld.totalAmountPayable.toString();
  //   _rentalsCurrent = rentalsHeld;
  // }

  Future<void> update() async {
    final editedRental = RentalsHeldModel(
      id: _rentalsCurrent.id,
      clientId: selectedClient?.id,
      startDate: DateTime.parse(_startDateController.text),
      endDate: DateTime.parse(_endDateController.text),
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
    _selectedClient = null;
    _startDateController.clear();
    _endDateController.clear();
    _numberOfDaysController.clear();
    _totalAmountPayableController.clear();
  }
}

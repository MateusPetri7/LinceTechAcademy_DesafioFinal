import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../models/vehicle_brand_model.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_model_model.dart';
import '../repositories/vehicle_repository.dart';
import '../services/exceptions.dart';
import 'databases/vehicle_controller.dart' as database;

class VehicleController extends ChangeNotifier {
  final IVehicleRepository vehicleRepository;

  VehicleController({required this.vehicleRepository}) {
    load();
  }

  final _controllerDataBase = database.VehicleController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _yearManufactureController = TextEditingController();
  final List<String> _states = Estados.listaEstadosSigla;
  final _dailyRentalCostController = TextEditingController();
  final List<String> _photosTheVehicle = [];
  final _listVehicle = <VehicleModel>[];
  VehicleModel _vehicleCurrent = VehicleModel();
  final List<String> _types = ['cars', 'motorcycles', 'trucks'];
  List<VehicleBrandModel> _vehicleBrands = [];
  List<VehicleModelModel> _vehicleModels = [];
  String? _selectedType;
  VehicleBrandModel? _selectedBrand;
  VehicleModelModel? _selectedModel;
  String? _selectedState;

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get typeController => _typeController;

  TextEditingController get brandController => _brandController;

  TextEditingController get modelController => _modelController;

  TextEditingController get plateController => _plateController;

  TextEditingController get yearManufactureController =>
      _yearManufactureController;

  List<String> get states => _states;

  TextEditingController get dailyRentalCostController =>
      _dailyRentalCostController;

  List<String> get photosTheVehicle => _photosTheVehicle;

  List<VehicleModel> get listVehicle => _listVehicle;

  VehicleModel get vehicleCurrent => _vehicleCurrent;

  List<String> get types => _types;

  List<VehicleBrandModel> get vehicleBrands => _vehicleBrands;

  List<VehicleModelModel> get vehicleModels => _vehicleModels;

  VehicleBrandModel? get selectedBrand => _selectedBrand;

  VehicleModelModel? get selectedModel => _selectedModel;

  String? get selectedType => _selectedType;

  String? get selectedState => _selectedState;

  set selectedType(String? value) {
    _selectedType = value;
    clearFields();
    if (value != null) {
      getVehicleBrands(value);
    }
    notifyListeners();
  }

  set selectedBrand(VehicleBrandModel? value) {
    _selectedBrand = value;
    _selectedModel = null;
    _vehicleModels.clear();
    if (value != null) {
      getVehicleModels(value.code);
    }
    notifyListeners();
  }

  set selectedModel(VehicleModelModel? value) {
    _selectedModel = value;
    notifyListeners();
  }

  set selectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  Future<void> getVehicleBrands(String selectedType) async {
    try {
      _vehicleBrands = await vehicleRepository.getVehicleBrands(selectedType);
      notifyListeners();
    } on NotFoundException catch (e) {
      throw NotFoundException("Erro");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getVehicleModels(String brandCode) async {
    try {
      _vehicleModels = await vehicleRepository.getVehicleModels(brandCode);
      notifyListeners();
    } on NotFoundException catch (e) {
      throw NotFoundException("Erro");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> insert() async {
    final vehicle = VehicleModel(
      type: _selectedType,
      brand: _selectedBrand?.name,
      model: _selectedModel?.name,
      plate: plateController.text,
      yearManufacture: int.tryParse(yearManufactureController.text) ?? 0,
      state: _selectedState,
      dailyRentalCost:
          _removeCurrencyFormatting(dailyRentalCostController.text),
      photosTheVehicle: _photosTheVehicle,
    );

    await _controllerDataBase.insert(vehicle);

    clearControllers();

    await load();
    notifyListeners();
  }

  Future<void> delete(VehicleModel vehicle) async {
    await _controllerDataBase.delete(vehicle);
    await load();
    notifyListeners();
  }

  Future<void> load() async {
    final list = await _controllerDataBase.select();

    _listVehicle.clear();
    _listVehicle.addAll(list);

    notifyListeners();
  }

  Future<void> populateVehicleInformation(VehicleModel vehicle) async {
    _typeController.text = vehicle.type ?? '';
    _brandController.text = vehicle.brand ?? '';
    _modelController.text = vehicle.model ?? '';
    _plateController.text = vehicle.plate ?? '';
    _yearManufactureController.text = vehicle.yearManufacture?.toString() ?? '';
    _selectedState = vehicle.state ?? '';
    _dailyRentalCostController.text =
        _formatCurrency(vehicle.dailyRentalCost ?? 0.0);

    _photosTheVehicle.clear();
    _photosTheVehicle.addAll(vehicle.photosTheVehicle ?? []);

    _vehicleCurrent = VehicleModel(
      id: vehicle.id,
      type: vehicle.type,
      brand: vehicle.brand,
      model: vehicle.model,
      plate: vehicle.plate,
      yearManufacture: vehicle.yearManufacture,
      state: vehicle.state,
      dailyRentalCost: vehicle.dailyRentalCost,
      photosTheVehicle: vehicle.photosTheVehicle,
    );

    notifyListeners();
  }

  Future<void> update() async {
    final editedVehicle = VehicleModel(
      id: _vehicleCurrent.id,
      type: _typeController.text,
      brand: _brandController.text,
      model: _modelController.text,
      plate: plateController.text,
      yearManufacture: int.tryParse(yearManufactureController.text) ?? 0,
      state: _selectedState,
      dailyRentalCost:
          _removeCurrencyFormatting(dailyRentalCostController.text),
      photosTheVehicle: _photosTheVehicle,
    );

    await _controllerDataBase.update(editedVehicle);

    _vehicleCurrent = VehicleModel();
    clearControllers();

    await load();
    notifyListeners();
  }

  void clearControllers() {
    _selectedType = null;
    _selectedBrand = null;
    _selectedModel = null;
    _plateController.clear();
    _yearManufactureController.clear();
    _selectedState = null;
    _dailyRentalCostController.clear();
    _photosTheVehicle.clear();
    notifyListeners();
  }

  void addPhoto(String imagePath) {
    _photosTheVehicle.add(imagePath);
    notifyListeners();
  }

  void removePhoto(String imagePath) {
    _photosTheVehicle.remove(imagePath);
    notifyListeners();
  }

  double _removeCurrencyFormatting(String value) {
    final cleanValue = value.replaceAll('R\$', '').trim();
    final numericValue = cleanValue.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(numericValue) ?? 0.0;
  }

  String _formatCurrency(double value) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatCurrency.format(value);
  }

  void clearFields() {
    _selectedBrand = null;
    _selectedModel = null;
    _brandController.clear();
    _modelController.clear();
    _vehicleBrands.clear();
    _vehicleModels.clear();
    notifyListeners();
  }
}

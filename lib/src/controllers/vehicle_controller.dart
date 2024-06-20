import 'package:flutter/material.dart';
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
  final _plateController = TextEditingController();
  final _yearManufactureController = TextEditingController();
  final _dailyRentalCostController = TextEditingController();
  final _photosTheVehicleController = TextEditingController();
  final _listVehicle = <VehicleModel>[];
  VehicleModel _vehicleCurrent = VehicleModel();
  final List<String> _types = ['cars', 'motorcycles', 'trucks'];
  List<VehicleBrandModel> _vehicleBrands = [];
  List<VehicleModelModel> _vehicleModels = [];
  String? _selectedType;
  VehicleBrandModel? _selectedBrand;
  VehicleModelModel? _selectedModel;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get plateController => _plateController;
  TextEditingController get yearManufactureController =>
      _yearManufactureController;
  TextEditingController get dailyRentalCostController =>
      _dailyRentalCostController;
  TextEditingController get photosTheVehicleController =>
      _photosTheVehicleController;
  List<VehicleModel> get listVehicle => _listVehicle;
  VehicleModel get vehicleCurrent => _vehicleCurrent;
  List<String> get types => _types;
  List<VehicleBrandModel> get vehicleBrands => _vehicleBrands;
  List<VehicleModelModel> get vehicleModels => _vehicleModels;
  VehicleBrandModel? get selectedBrand => _selectedBrand;
  VehicleModelModel? get selectedModel => _selectedModel;
  String? get selectedType => _selectedType;

  set selectedType(String? value) {
    _selectedType = value;
    _selectedBrand = null;
    _selectedModel = null;
    _vehicleBrands.clear();
    _vehicleModels.clear();
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

  Future<void> getVehicleBrands(String selectedType) async {
    try {
      _vehicleBrands = await vehicleRepository.getVehicleBrands(selectedType);
      notifyListeners();
    } on NotFoundException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVehicleModels(String brandCode) async {
    try {
      _vehicleModels = await vehicleRepository.getVehicleModels(brandCode);
      notifyListeners();
    } on NotFoundException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  Future<void> insert() async {
    final vehicle = VehicleModel(
      brand: _selectedBrand?.name,
      model: _selectedModel?.name,
      plate: plateController.text,
      yearManufacture: int.tryParse(yearManufactureController.text) ?? 0,
      dailyRentalCost: double.tryParse(dailyRentalCostController.text) ?? 0.0,
      photosTheVehicle: photosTheVehicleController.text,
    );

    await _controllerDataBase.insert(vehicle);

    _clearControllers();

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

  void populateVehicleInformation(VehicleModel vehicle) {
    _selectedBrand = _vehicleBrands
        .firstWhere((brand) => brand.name == vehicle.brand);
    _selectedModel = _vehicleModels
        .firstWhere((model) => model.name == vehicle.model);
    _plateController.text = vehicle.plate ?? '';
    _yearManufactureController.text = vehicle.yearManufacture?.toString() ?? '';
    _dailyRentalCostController.text = vehicle.dailyRentalCost?.toString() ?? '';
    _photosTheVehicleController.text = vehicle.photosTheVehicle ?? '';

    _vehicleCurrent = VehicleModel(
      id: vehicle.id,
      brand: vehicle.brand,
      model: vehicle.model,
      plate: vehicle.plate,
      yearManufacture: vehicle.yearManufacture,
      dailyRentalCost: vehicle.dailyRentalCost,
      photosTheVehicle: vehicle.photosTheVehicle,
    );
  }

  Future<void> update() async {
    final editedVehicle = VehicleModel(
      id: _vehicleCurrent.id,
      brand: _selectedBrand?.name,
      model: _selectedModel?.name,
      plate: plateController.text,
      yearManufacture: int.tryParse(yearManufactureController.text) ?? 0,
      dailyRentalCost: double.tryParse(dailyRentalCostController.text) ?? 0.0,
      photosTheVehicle: photosTheVehicleController.text,
    );

    await _controllerDataBase.update(editedVehicle);

    _vehicleCurrent = VehicleModel();
    _clearControllers();

    await load();
    notifyListeners();
  }

  void _clearControllers() {
    _selectedBrand = null;
    _selectedModel = null;
    _plateController.clear();
    _yearManufactureController.clear();
    _dailyRentalCostController.clear();
    _photosTheVehicleController.clear();
    notifyListeners();
  }
}

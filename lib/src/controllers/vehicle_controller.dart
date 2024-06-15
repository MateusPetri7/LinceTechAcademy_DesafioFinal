import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
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
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _yearManufactureController = TextEditingController();
  final _dailyRentalCostController = TextEditingController();
  final _photosTheVehicleController = TextEditingController();
  final _listVehicle = <VehicleModel>[];
  VehicleModel _vehicleCurrent = VehicleModel();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get brandController => _brandController;
  TextEditingController get modelController => _modelController;
  TextEditingController get plateController => _plateController;
  TextEditingController get yearManufactureController => _yearManufactureController;
  TextEditingController get dailyRentalCostController => _dailyRentalCostController;
  TextEditingController get photosTheVehicleController => _photosTheVehicleController;
  List<VehicleModel> get listVehicle => _listVehicle;
  VehicleModel get vehicleCurrent => _vehicleCurrent;

  Future<void> getVehiclesBrands() async {
    try {
      final vehiclesBrands = await vehicleRepository.getVehicleBrands();
      //_vehicleCurrent = vehiclesData;
      //notifyListeners();
    } on NotFoundException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVehicheModels() async {
    try {
      final vehiclesModels = await vehicleRepository.getVehicleModels();
      //_vehicleCurrent = vehiclesData;
      //notifyListeners();
    } on NotFoundException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  Future<void> insert() async {
    final vehicle = VehicleModel(
      brand: brandController.text,
      model: modelController.text,
      plate: plateController.text,
      yearManufacture: yearManufactureController.hashCode,
      dailyRentalCost: double.parse(dailyRentalCostController.text),
      photosTheVehicle: photosTheVehicleController.text,
    );

    await _controllerDataBase.insert(vehicle);

    brandController.clear();
    modelController.clear();
    plateController.clear();
    yearManufactureController.clear();
    dailyRentalCostController.clear();
    photosTheVehicleController.clear();

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

  void populateClientInformation(VehicleModel vehicle) {
    _brandController.text = vehicle.brand ?? '';
    _modelController.text = vehicle.model ?? '';
    _plateController.text = vehicle.plate ?? '';
    _yearManufactureController.value = (vehicle.yearManufacture ?? 0) as TextEditingValue;
    _dailyRentalCostController.value = (vehicle.dailyRentalCost ?? 0.0) as TextEditingValue;
    _photosTheVehicleController.text = vehicle.photosTheVehicle ?? '';

    _vehicleCurrent = VehicleModel(
      id: vehicle.id,
    );
  }

  Future<void> update() async {
    final editedVehicle = VehicleModel(
        id: _vehicleCurrent.id,
        brand: brandController.text,
        model: modelController.text,
        plate: plateController.text,
        yearManufacture: yearManufactureController.hashCode,
        dailyRentalCost: double.parse(dailyRentalCostController.text),
        photosTheVehicle: photosTheVehicleController.text
    );

    await _controllerDataBase.update(editedVehicle);

    _vehicleCurrent = VehicleModel();
    brandController.clear();
    modelController.clear();
    plateController.clear();
    yearManufactureController.clear();
    dailyRentalCostController.clear();
    photosTheVehicleController.clear();

    await load();
    notifyListeners();
  }
}

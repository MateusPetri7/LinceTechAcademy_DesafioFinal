//ignore_for_file:avoid_classes_with_only_static_members
import '../../models/vehicle_model.dart';

class VehicleTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $brand TEXT NOT NULL,
  $model TEXT NOT NULL,
  $plate TEXT NOT NULL,
  $yearManufacture INTEGER NOT NULL,
  $dailyRentalCost REAL NOT NULL
  $photosTheVehicle TEXT NOT NULL
  ); 
  ''';

  static const String tableName = 'Vehicle';
  static const String id = 'id';
  static const String brand = 'brand';
  static const String model = 'model';
  static const String plate = 'plate';
  static const String yearManufacture = 'yearManufacture';
  static const String dailyRentalCost = 'dailyRentalCost';
  static const String photosTheVehicle = 'photosTheVehicle';

  static Map<String, dynamic> toMap(VehicleModel vehicle) {
    final map = <String, dynamic>{};

    map[VehicleTable.id] = vehicle.id;
    map[VehicleTable.brand] = vehicle.brand;
    map[VehicleTable.model] = vehicle.model;
    map[VehicleTable.plate] = vehicle.plate;
    map[VehicleTable.yearManufacture] = vehicle.yearManufacture;
    map[VehicleTable.dailyRentalCost] = vehicle.dailyRentalCost;
    map[VehicleTable.photosTheVehicle] = vehicle.photosTheVehicle;

    return map;
  }
}
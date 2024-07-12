// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:convert';
import '../../models/vehicle_model.dart';

class VehicleTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $type TEXT NOT NULL,
  $brand TEXT NOT NULL,
  $model TEXT NOT NULL,
  $plate TEXT NOT NULL,
  $yearManufacture INTEGER NOT NULL,
  $state TEXT NOT NULL,
  $dailyRentalCost REAL NOT NULL,
  $photosTheVehicle TEXT NOT NULL
  ); 
  ''';

  static const String tableName = 'vehicle';
  static const String id = 'id';
  static const String type = 'type';
  static const String brand = 'brand';
  static const String model = 'model';
  static const String plate = 'plate';
  static const String yearManufacture = 'year_manufacture';
  static const String state = 'state';
  static const String dailyRentalCost = 'daily_rental_cost';
  static const String photosTheVehicle = 'photos_the_vehicle';

  static Map<String, dynamic> toMap(VehicleModel vehicle) {
    final map = <String, dynamic>{};

    map[VehicleTable.id] = vehicle.id;
    map[VehicleTable.type] = vehicle.type;
    map[VehicleTable.brand] = vehicle.brand;
    map[VehicleTable.model] = vehicle.model;
    map[VehicleTable.plate] = vehicle.plate;
    map[VehicleTable.yearManufacture] = vehicle.yearManufacture;
    map[VehicleTable.state] = vehicle.state;
    map[VehicleTable.dailyRentalCost] = vehicle.dailyRentalCost;
    map[VehicleTable.photosTheVehicle] = jsonEncode(vehicle.photosTheVehicle);

    return map;
  }

  static VehicleModel fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map[VehicleTable.id].toString(),
      type: map[VehicleTable.type],
      brand: map[VehicleTable.brand],
      model: map[VehicleTable.model],
      plate: map[VehicleTable.plate],
      yearManufacture: map[VehicleTable.yearManufacture],
      state: map[VehicleTable.state],
      dailyRentalCost: map[VehicleTable.dailyRentalCost],
      photosTheVehicle:
          List<String>.from(jsonDecode(map[VehicleTable.photosTheVehicle])),
    );
  }
}

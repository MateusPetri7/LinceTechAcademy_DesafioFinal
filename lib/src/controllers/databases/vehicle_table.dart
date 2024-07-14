// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:convert';
import '../../models/vehicle_model.dart';

/// A utility class for database operations related to vehicles.
class VehicleTable {
  /// SQL statement to create the vehicles table.
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

  /// Name of the vehicles table in the database.
  static const String tableName = 'vehicle';
  /// Column name for vehicle ID.
  static const String id = 'id';
  /// Column name for vehicle type.
  static const String type = 'type';
  /// Column name for vehicle brand.
  static const String brand = 'brand';
  /// Column name for vehicle model.
  static const String model = 'model';
  /// Column name for vehicle plate.
  static const String plate = 'plate';
  /// Column name for vehicle year of manufacture.
  static const String yearManufacture = 'year_manufacture';
  /// Column name for vehicle state.
  static const String state = 'state';
  /// Column name for vehicle daily rental cost.
  static const String dailyRentalCost = 'daily_rental_cost';
  /// Column name for vehicle photos.
  static const String photosTheVehicle = 'photos_the_vehicle';

  /// Converts a [VehicleModel] object into a map of database columns.
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

  /// Converts a database column map into a [VehicleModel] object.
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

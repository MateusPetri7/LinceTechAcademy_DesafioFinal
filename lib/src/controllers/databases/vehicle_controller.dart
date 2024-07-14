import '../../models/vehicle_model.dart';
import 'database_helper.dart';
import 'vehicle_table.dart';

/// Controller class for managing operations on [VehicleModel] in the database.
///
/// This class provides methods to insert, delete, update, and retrieve vehicles
/// from the database using [VehicleModel] objects.
class VehicleController {
  /// Inserts a new [vehicle] into the database.
  Future<void> insert(VehicleModel vehicle) async {
    final database = await getDatabase();
    final map = VehicleTable.toMap(vehicle);

    await database.insert(VehicleTable.tableName, map);
  }

  /// Deletes the given [vehicle] from the database.
  Future<void> delete(VehicleModel vehicle) async {
    final database = await getDatabase();

    await database.delete(
      VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [vehicle.id],
    );
  }

  /// Retrieves all vehicles from the database as a list of [VehicleModel].
  ///
  /// Returns an empty list if no vehicles are found.
  Future<List<VehicleModel>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      VehicleTable.tableName,
    );

    var list = <VehicleModel>[];
    for (final item in result) {
      list.add(VehicleTable.fromMap(item));
    }

    return list;
  }

  /// Updates the given [vehicle] in the database.
  Future<void> update(VehicleModel vehicle) async {
    final database = await getDatabase();

    var map = VehicleTable.toMap(vehicle);

    await database.update(
        VehicleTable.tableName,
        map,
        where: '${VehicleTable.id} = ?',
        whereArgs: [vehicle.id]
    );
  }

  /// Retrieves a vehicle from the database by [id].
  ///
  /// Returns `null` if no vehicle with the specified [id] is found.
  Future<VehicleModel?> getVehicleFromId(String id) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final item = result.first;
      return VehicleTable.fromMap(item);
    }

    return null;
  }

  /// Retrieves vehicles from the database filtered by [state].
  ///
  /// Returns an empty list if no vehicles match the [state] criteria.
  Future<List<VehicleModel>> getVehiclesFromState(String state) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      VehicleTable.tableName,
      where: '${VehicleTable.state} = ?',
      whereArgs: [state],
    );

    var list = <VehicleModel>[];
    if (result.isNotEmpty) {
      for (final item in result) {
        list.add(VehicleTable.fromMap(item));
      }
    }

    return list;
  }
}
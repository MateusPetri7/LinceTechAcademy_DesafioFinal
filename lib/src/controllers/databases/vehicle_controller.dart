import '../../models/vehicle_model.dart';
import 'database_helper.dart';
import 'vehicle_table.dart';

class VehicleController {
  Future<void> insert(VehicleModel vehicle) async {
    final database = await getDatabase();
    final map = VehicleTable.toMap(vehicle);

    await database.insert(VehicleTable.tableName, map);
  }

  Future<void> delete(VehicleModel vehicle) async {
    final database = await getDatabase();

    await database.delete(
      VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [vehicle.id],
    );
  }

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

  Future<void> update(VehicleModel vehicle) async {
    final database = await getDatabase();

    var map = VehicleTable.toMap(vehicle);

    print(map);

    await database.update(
        VehicleTable.tableName,
        map,
        where: '${VehicleTable.id} = ?',
        whereArgs: [vehicle.id]
    );
  }

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
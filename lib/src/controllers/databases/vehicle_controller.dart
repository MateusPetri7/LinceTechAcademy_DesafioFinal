import '../../models/vehicle_model.dart';
import 'database_helper.dart';
import 'vehicle_table.dart';

class VehicleController {
  Future<void> insert(VehicleModel client) async {
    final database = await getDatabase();
    final map = VehicleTable.toMap(client);

    await database.insert(VehicleTable.tableName, map);

    return;
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
      list.add(
        VehicleModel(
          id: item[VehicleTable.id].toString(),
          brand: item[VehicleTable.brand],
          model: item[VehicleTable.model],
          plate: item[VehicleTable.plate],
          yearManufacture: item[VehicleTable.yearManufacture],
          dailyRentalCost: item[VehicleTable.dailyRentalCost],
          photosTheVehicle: item[VehicleTable.photosTheVehicle],
        ),
      );
    }

    return list;
  }

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
}
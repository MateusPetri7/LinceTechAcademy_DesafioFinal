import '../../models/rent_model.dart';
import 'database_helper.dart';
import 'rent_table.dart';

/// Controller class for managing operations on [RentModel] in the database.
///
/// This class provides methods to insert, delete, update, and retrieve rents
/// from the database using [RentModel] objects.
class RentController {
  /// Inserts a new [rent] into the database.
  ///
  /// Returns the ID of the newly inserted rent.
  Future<int> insert(RentModel rent) async {
    final database = await getDatabase();
    final map = RentTable.toMap(rent);

    return await database.insert(RentTable.tableName, map);
  }

  /// Deletes the given [rent] from the database.
  Future<void> delete(RentModel rent) async {
    final database = await getDatabase();

    await database.delete(
      RentTable.tableName,
      where: '${RentTable.id} = ?',
      whereArgs: [rent.id],
    );
  }

  /// Retrieves all rents from the database as a list of [RentModel].
  ///
  /// Returns an empty list if no rents are found.
  Future<List<RentModel>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      RentTable.tableName,
    );

    var list = <RentModel>[];
    for (final item in result) {
      list.add(RentTable.fromMap(item));
    }

    return list;
  }

  /// Updates the given [rent] in the database.
  Future<void> update(RentModel rent) async {
    final database = await getDatabase();

    var map = RentTable.toMap(rent);

    await database.update(
        RentTable.tableName,
        map,
        where: '${RentTable.id} = ?',
        whereArgs: [rent.id]
    );
  }

  /// Retrieves a rent from the database by [id].
  ///
  /// Returns `null` if no rent with the specified [id] is found.
  Future<RentModel?> getRentFromId(String id) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      RentTable.tableName,
      where: '${RentTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final item = result.first;
      return RentTable.fromMap(item);
    }

    return null;
  }

  /// Retrieves rents from the database filtered by [vehicleId].
  ///
  /// Returns an empty list if no rents match the [vehicleId] criteria.
  Future<List<RentModel>> getRentsFromVehicle(String vehicleId) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      RentTable.tableName,
      where: '${RentTable.vehicleId} = ?',
      whereArgs: [vehicleId],
    );

    var list = <RentModel>[];
    if (result.isNotEmpty) {
      for (final item in result) {
        list.add(RentTable.fromMap(item));
      }
    }

    return list;
  }
}
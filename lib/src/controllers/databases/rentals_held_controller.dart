import '../../models/rentals_held_model.dart';
import 'database_helper.dart';
import 'rentals_held_table.dart';

class RentalsHeldController {
  Future<int> insert(RentalsHeldModel rentalsHeld) async {
    final database = await getDatabase();
    final map = RentalsHeldTable.toMap(rentalsHeld);

    return await database.insert(RentalsHeldTable.tableName, map);
  }

  Future<void> delete(RentalsHeldModel rentalsHeld) async {
    final database = await getDatabase();

    await database.delete(
      RentalsHeldTable.tableName,
      where: '${RentalsHeldTable.id} = ?',
      whereArgs: [rentalsHeld.id],
    );
  }

  Future<List<RentalsHeldModel>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      RentalsHeldTable.tableName,
    );

    var list = <RentalsHeldModel>[];
    for (final item in result) {
      list.add(RentalsHeldTable.fromMap(item));
    }

    return list;
  }

  Future<void> update(RentalsHeldModel rentalsHeld) async {
    final database = await getDatabase();

    var map = RentalsHeldTable.toMap(rentalsHeld);

    await database.update(
        RentalsHeldTable.tableName,
        map,
        where: '${RentalsHeldTable.id} = ?',
        whereArgs: [rentalsHeld.id]
    );
  }

  Future<RentalsHeldModel?> getRentalsFromId(String id) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      RentalsHeldTable.tableName,
      where: '${RentalsHeldTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final item = result.first;
      return RentalsHeldTable.fromMap(item);
    }

    return null;
  }
}
import '../../models/rent_model.dart';
import 'database_helper.dart';
import 'rent_table.dart';

class RentController {
  Future<int> insert(RentModel rent) async {
    final database = await getDatabase();
    final map = RentTable.toMap(rent);

    return await database.insert(RentTable.tableName, map);
  }

  Future<void> delete(RentModel rent) async {
    final database = await getDatabase();

    await database.delete(
      RentTable.tableName,
      where: '${RentTable.id} = ?',
      whereArgs: [rent.id],
    );
  }

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

  Future<RentModel?> getRentsFromId(String id) async {
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
}
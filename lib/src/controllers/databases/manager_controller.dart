import '../../models/manager_model.dart';
import 'database_helper.dart';
import 'manager_table.dart';

class ManagerController {
  Future<void> insert(ManagerModel manager) async {
    final database = await getDatabase();
    final map = ManagerTable.toMap(manager);

    await database.insert(ManagerTable.tableName, map);
  }

  Future<void> delete(ManagerModel manager) async {
    final database = await getDatabase();

    await database.delete(
      ManagerTable.tableName,
      where: '${ManagerTable.id} = ?',
      whereArgs: [manager.id],
    );
  }

  Future<List<ManagerModel>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ManagerTable.tableName,
    );

    var list = <ManagerModel>[];
    for (final item in result) {
      list.add(ManagerTable.fromMap(item));
    }

    return list;
  }

  Future<void> update(ManagerModel manager) async {
    final database = await getDatabase();

    var map = ManagerTable.toMap(manager);

    await database.update(ManagerTable.tableName, map,
        where: '${ManagerTable.id} = ?', whereArgs: [manager.id]);
  }

  Future<List<ManagerModel>> getManagersFromState(String state) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ManagerTable.tableName,
      where: '${ManagerTable.state} = ?',
      whereArgs: [state],
    );

    final managers = <ManagerModel>[];
    if (result.isNotEmpty) {
      for (var item in result) {
        managers.add(ManagerTable.fromMap(item));
      }
    }

    return managers;
  }

  Future<ManagerModel?> getManagerFromId(String id) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ManagerTable.tableName,
      where: '${ManagerTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final item = result.first;
      return ManagerTable.fromMap(item);
    }

    return null;
  }
}

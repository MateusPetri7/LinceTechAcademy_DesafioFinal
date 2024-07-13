import '../../models/manager_model.dart';
import 'database_helper.dart';
import 'manager_table.dart';

/// Controller class for managing operations on [ManagerModel] in the database.
///
/// This class provides methods to insert, delete, update, and retrieve managers
/// from the database using [ManagerModel] objects.
class ManagerController {
  /// Inserts a new [manager] into the database.
  Future<void> insert(ManagerModel manager) async {
    final database = await getDatabase();
    final map = ManagerTable.toMap(manager);

    await database.insert(ManagerTable.tableName, map);
  }

  /// Deletes the given [manager] from the database.
  Future<void> delete(ManagerModel manager) async {
    final database = await getDatabase();

    await database.delete(
      ManagerTable.tableName,
      where: '${ManagerTable.id} = ?',
      whereArgs: [manager.id],
    );
  }

  /// Retrieves all managers from the database as a list of [ManagerModel].
  ///
  /// Returns an empty list if no managers are found.
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

  /// Updates the given [manager] in the database.
  Future<void> update(ManagerModel manager) async {
    final database = await getDatabase();

    var map = ManagerTable.toMap(manager);

    await database.update(ManagerTable.tableName, map,
        where: '${ManagerTable.id} = ?', whereArgs: [manager.id]);
  }

  /// Retrieves managers from the database filtered by [state].
  ///
  /// Returns an empty list if no managers match the [state] criteria.
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

  /// Retrieves a manager from the database by [id].
  ///
  /// Returns `null` if no manager with the specified [id] is found.
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

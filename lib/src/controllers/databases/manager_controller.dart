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
      list.add(
        ManagerModel(
          id: item[ManagerTable.id].toString(),
          name: item[ManagerTable.name],
          individualTaxpayerRegistry:
              item[ManagerTable.individualTaxpayerRegistry],
          state: item[ManagerTable.state],
          telephone: item[ManagerTable.telephone],
          commissionPercentage: item[ManagerTable.commissionPercentage],
        ),
      );
    }

    return list;
  }

  Future<void> update(ManagerModel manager) async {
    final database = await getDatabase();

    var map = ManagerTable.toMap(manager);

    await database.update(ManagerTable.tableName, map,
        where: '${ManagerTable.id} = ?', whereArgs: [manager.id]);
  }
}

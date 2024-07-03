import '../../models/client_model.dart';
import 'client_table.dart';
import 'database_helper.dart';

class ClientController {
  Future<void> insert(ClientModel client) async {
    final database = await getDatabase();
    final map = ClientTable.toMap(client);

    await database.insert(ClientTable.tableName, map);
  }

  Future<void> delete(ClientModel client) async {
    final database = await getDatabase();

    await database.delete(
      ClientTable.tableName,
      where: '${ClientTable.id} = ?',
      whereArgs: [client.id],
    );
  }

  Future<List<ClientModel>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ClientTable.tableName,
    );

    var list = <ClientModel>[];
    for (final item in result) {
      list.add(ClientTable.fromMap(item));
    }

    return list;
  }

  Future<void> update(ClientModel client) async {
    final database = await getDatabase();

    var map = ClientTable.toMap(client);

    await database.update(ClientTable.tableName, map,
        where: '${ClientTable.id} = ?', whereArgs: [client.id]);
  }

  Future<List<ClientModel>> getClientsFromState(String state) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ClientTable.tableName,
      where: '${ClientTable.state} = ?',
      whereArgs: [state],
    );

    var list = <ClientModel>[];
    if (result.isNotEmpty) {
      for (final item in result) {
        list.add(ClientTable.fromMap(item));
      }
    }

    return list;
  }

  Future<ClientModel?> getClientFromId(String id) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      ClientTable.tableName,
      where: '${ClientTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final item = result.first;
      return ClientTable.fromMap(item);
    }

    return null;
  }
}

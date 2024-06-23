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
      list.add(
        ClientModel(
          id: item[ClientTable.id].toString(),
          name: item[ClientTable.name],
          telephone: item[ClientTable.telephone],
          city: item[ClientTable.city],
          state: item[ClientTable.state],
          companyRegistrationNumber:
              item[ClientTable.companyRegistrationNumber],
          managerId: item[ClientTable.manager_id],
        ),
      );
    }

    return list;
  }

  Future<void> update(ClientModel client) async {
    final database = await getDatabase();

    var map = ClientTable.toMap(client);

    await database.update(ClientTable.tableName, map,
        where: '${ClientTable.id} = ?', whereArgs: [client.id]);
  }
}

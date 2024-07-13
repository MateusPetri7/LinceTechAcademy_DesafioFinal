import '../../models/client_model.dart';
import 'client_table.dart';
import 'database_helper.dart';

/// Controller class for managing operations on [ClientModel] in the database.
///
/// This class provides methods to insert, delete, update, and retrieve clients
/// from the database using [ClientModel] objects.
class ClientController {
  /// Inserts a new [client] into the database.
  Future<void> insert(ClientModel client) async {
    final database = await getDatabase();
    final map = ClientTable.toMap(client);

    await database.insert(ClientTable.tableName, map);
  }

  /// Deletes the given [client] from the database.
  Future<void> delete(ClientModel client) async {
    final database = await getDatabase();

    await database.delete(
      ClientTable.tableName,
      where: '${ClientTable.id} = ?',
      whereArgs: [client.id],
    );
  }

  /// Retrieves all clients from the database as a list of [ClientModel].
  ///
  /// Returns an empty list if no client are found.
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

  /// Updates the given [client] in the database.
  Future<void> update(ClientModel client) async {
    final database = await getDatabase();

    var map = ClientTable.toMap(client);

    await database.update(ClientTable.tableName, map,
        where: '${ClientTable.id} = ?', whereArgs: [client.id]);
  }

  /// Retrieves clients from the database filtered by [state].
  ///
  /// Returns an empty list if no clients match the [state] criteria.
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

  /// Retrieves a client from the database by [id].
  ///
  /// Returns `null` if no client with the specified [id] is found.
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

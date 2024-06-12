import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/client_model.dart';

Future<Database> getDatabase() async {
  final path = join(await getDatabasesPath(), 'ss_automoveis.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ClientTable.createTable);
    },
    version: 1,
  );
}

class ClientTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $name TEXT NOT NULL,
  $telephone TEXT NOT NULL,
  $city TEXT NOT NULL,
  $state TEXT NOT NULL,
  $tin TEXT NOT NULL
  ); 
  ''';

  static const String tableName = 'Client';
  static const String id = 'id';
  static const String name = 'name';
  static const String telephone = 'telephone';
  static const String city = 'city';
  static const String state = 'state';
  static const String tin = 'tin';

  static Map<String, dynamic> toMap(ClientModel client) {
    final map = <String, dynamic>{};

    map[ClientTable.id] = client.id;
    map[ClientTable.name] = client.name;
    map[ClientTable.telephone] = client.telephone;
    map[ClientTable.city] = client.city;
    map[ClientTable.state] = client.state;
    map[ClientTable.tin] = client.tin;

    return map;
  }
}

class ClientController {
  Future<void> insert(ClientModel client) async {
    final database = await getDatabase();
    final map = ClientTable.toMap(client);

    await database.insert(ClientTable.tableName, map);

    return;
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
          tin: item[ClientTable.tin],
        ),
      );
    }

    return list;
  }

  Future<void> update(ClientModel client) async {
    final database = await getDatabase();

    var map = ClientTable.toMap(client);

    await database.update(
      ClientTable.tableName,
      map,
      where: '${ClientTable.id} = ?',
      whereArgs: [client.id]
    );
  }
}

import 'package:lincetechacademy_ss_automoveis_app/src/models/client_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
}

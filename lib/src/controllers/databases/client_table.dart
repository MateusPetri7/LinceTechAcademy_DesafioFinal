//ignore_for_file:avoid_classes_with_only_static_members
import '../../models/client_model.dart';

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
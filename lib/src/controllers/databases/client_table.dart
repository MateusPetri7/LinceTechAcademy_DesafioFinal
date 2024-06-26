// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/client_model.dart';

class ClientTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $name TEXT NOT NULL,
  $telephone TEXT NOT NULL,
  $city TEXT NOT NULL,
  $state TEXT NOT NULL,
  $companyRegistrationNumber TEXT NOT NULL,
  $manager_id INTEGER,
  FOREIGN KEY (manager_id) REFERENCES Manager(id)
  ); 
  ''';

  static const String tableName = 'Client';
  static const String id = 'id';
  static const String name = 'name';
  static const String telephone = 'telephone';
  static const String city = 'city';
  static const String state = 'state';
  static const String companyRegistrationNumber = 'companyRegistrationNumber';
  static const String manager_id = 'manager_id';

  static Map<String, dynamic> toMap(ClientModel client) {
    final map = <String, dynamic>{};

    map[ClientTable.id] = client.id;
    map[ClientTable.name] = client.name;
    map[ClientTable.telephone] = client.telephone;
    map[ClientTable.city] = client.city;
    map[ClientTable.state] = client.state;
    map[ClientTable.companyRegistrationNumber] =
        client.companyRegistrationNumber;
    map[ClientTable.manager_id] = client.managerId;

    return map;
  }

  static ClientModel fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map[ClientTable.id].toString(),
      name: map[ClientTable.name],
      telephone: map[ClientTable.telephone],
      city: map[ClientTable.city],
      state: map[ClientTable.state],
      companyRegistrationNumber: map[ClientTable.companyRegistrationNumber],
      managerId: map[ClientTable.manager_id].toString(),
    );
  }
}

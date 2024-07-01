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
  $managerId INTEGER,
  FOREIGN KEY ($managerId) REFERENCES manager(id)
  ); 
  ''';

  static const String tableName = 'client';
  static const String id = 'id';
  static const String name = 'name';
  static const String telephone = 'telephone';
  static const String city = 'city';
  static const String state = 'state';
  static const String companyRegistrationNumber = 'company_registration_number';
  static const String managerId = 'manager_id';

  static Map<String, dynamic> toMap(ClientModel client) {
    final map = <String, dynamic>{};

    map[ClientTable.id] = client.id;
    map[ClientTable.name] = client.name;
    map[ClientTable.telephone] = client.telephone;
    map[ClientTable.city] = client.city;
    map[ClientTable.state] = client.state;
    map[ClientTable.companyRegistrationNumber] =
        client.companyRegistrationNumber;
    map[ClientTable.managerId] = client.managerId;

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
      managerId: map[ClientTable.managerId]?.toString(),
    );
  }
}

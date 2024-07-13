// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/client_model.dart';

/// A utility class for database operations related to clients.
class ClientTable {
  /// SQL statement to create the clients table.
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

  /// Name of the clients table in the database.
  static const String tableName = 'client';
  /// Column name for client ID.
  static const String id = 'id';
  /// Column name for client name.
  static const String name = 'name';
  /// Column name for client telephone.
  static const String telephone = 'telephone';
  /// Column name for client city.
  static const String city = 'city';
  /// Column name for client state.
  static const String state = 'state';
  /// Column name for client company registration number.
  static const String companyRegistrationNumber = 'company_registration_number';
  /// Column name for client manager ID.
  static const String managerId = 'manager_id';

  /// Converts a [ClientModel] object into a map of database columns.
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

  /// Converts a database column map into a [ClientModel] object.
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

import '../../models/manager_model.dart';

class ManagerTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $name TEXT NOT NULL,
  $individualTaxpayerRegistry TEXT NOT NULL,
  $state TEXT NOT NULL,
  $telephone TEXT NOT NULL,
  $commissionPercentage TEXT NOT NULL
  ); 
  ''';

  static const String tableName = 'Manager';
  static const String id = 'id';
  static const String name = 'name';
  static const String individualTaxpayerRegistry = 'individualTaxpayerRegistry';
  static const String state = 'state';
  static const String telephone = 'telephone';
  static const String commissionPercentage = 'commissionPercentage';

  static Map<String, dynamic> toMap(ManagerModel manager) {
    final map = <String, dynamic>{};

    map[ManagerTable.id] = manager.id;
    map[ManagerTable.name] = manager.name;
    map[ManagerTable.individualTaxpayerRegistry] = manager.individualTaxpayerRegistry;
    map[ManagerTable.state] = manager.state;
    map[ManagerTable.telephone] = manager.telephone;
    map[ManagerTable.commissionPercentage] = manager.commissionPercentage;

    return map;
  }
}

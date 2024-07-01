// ignore_for_file: avoid_classes_with_only_static_members
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

  static const String tableName = 'manager';
  static const String id = 'id';
  static const String name = 'name';
  static const String individualTaxpayerRegistry = 'individual_taxpayer_registry';
  static const String state = 'state';
  static const String telephone = 'telephone';
  static const String commissionPercentage = 'commission_percentage';

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

  static ManagerModel fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      id: map[ManagerTable.id].toString(),
      name: map[ManagerTable.name],
      individualTaxpayerRegistry: map[ManagerTable.individualTaxpayerRegistry],
      state: map[ManagerTable.state],
      telephone: map[ManagerTable.telephone],
      commissionPercentage: map[ManagerTable.commissionPercentage],
    );
  }
}

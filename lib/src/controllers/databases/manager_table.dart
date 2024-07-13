// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/manager_model.dart';

/// A utility class for managing operations related to managers in the database.
class ManagerTable {
  /// SQL statement to create the managers table.
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

  /// Name of the managers table in the database.
  static const String tableName = 'manager';

  /// Column name for manager ID.
  static const String id = 'id';

  /// Column name for manager name.
  static const String name = 'name';

  /// Column name for manager individual taxpayer registry.
  static const String individualTaxpayerRegistry =
      'individual_taxpayer_registry';

  /// Column name for manager state.
  static const String state = 'state';

  /// Column name for manager telephone.
  static const String telephone = 'telephone';

  /// Column name for manager commission percentage.
  static const String commissionPercentage = 'commission_percentage';

  /// Converts a [ManagerModel] object into a map of database columns.
  static Map<String, dynamic> toMap(ManagerModel manager) {
    final map = <String, dynamic>{};

    map[ManagerTable.id] = manager.id;
    map[ManagerTable.name] = manager.name;
    map[ManagerTable.individualTaxpayerRegistry] =
        manager.individualTaxpayerRegistry;
    map[ManagerTable.state] = manager.state;
    map[ManagerTable.telephone] = manager.telephone;
    map[ManagerTable.commissionPercentage] = manager.commissionPercentage;

    return map;
  }

  /// Converts a database column map into a [ManagerModel] object.
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

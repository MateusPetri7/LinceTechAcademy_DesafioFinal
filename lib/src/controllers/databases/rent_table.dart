// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/rent_model.dart';


/// A utility class for database operations related to rent.
class RentTable {
  /// SQL statement to create the rent table.
  static const String createTable = '''
  CREATE TABLE $tableName (
    $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $rentState TEXT NOT NULL,
    $clientId INTEGER NOT NULL,
    $vehicleId INTEGER NOT NULL,
    $startDate TEXT NOT NULL,
    $endDate TEXT NOT NULL,
    $numberOfDays INTEGER NOT NULL,
    $totalAmountPayable REAL NOT NULL,
    $percentageManagerCommission TEXT NOT NULL,
    $managerCommissionValue REAL NOT NULL,
    FOREIGN KEY ($clientId) REFERENCES client(id),
    FOREIGN KEY ($vehicleId) REFERENCES vehicle(id)
  );
  ''';

  /// Name of the rent table in the database.
  static const String tableName = 'rent';
  /// Column name for rent ID.
  static const String id = 'id';
  /// Column name for rent state.
  static const String rentState = 'rent_state';
  /// Column name for client ID associated with the rent.
  static const String clientId = 'client_id';
  /// Column name for vehicle ID associated with the rent.
  static const String vehicleId = 'vehicle_id';
  /// Column name for rent start date.
  static const String startDate = 'start_date';
  /// Column name for rent end date.
  static const String endDate = 'end_date';
  /// Column name for number of days the rent lasted.
  static const String numberOfDays = 'number_of_days';
  /// Column name for total amount payable for the rent.
  static const String totalAmountPayable = 'total_amount_payable';
  /// Column name for percentage of manager commission applied.
  static const String percentageManagerCommission =
      'percentage_manager_commission';
  /// Column name for manager commission value earned.
  static const String managerCommissionValue = 'manager_commission_value';

  /// Converts a [RentModel] object into a map of database columns.
  static Map<String, dynamic> toMap(RentModel rent) {
    final map = <String, dynamic>{};

    map[RentTable.id] = rent.id;
    map[RentTable.rentState] = rent.rentState;
    map[RentTable.clientId] = rent.clientId;
    map[RentTable.vehicleId] = rent.vehicleId;
    map[RentTable.startDate] = rent.startDate?.toIso8601String();
    map[RentTable.endDate] = rent.endDate?.toIso8601String();
    map[RentTable.numberOfDays] = rent.numberOfDays;
    map[RentTable.totalAmountPayable] = rent.totalAmountPayable;
    map[RentTable.percentageManagerCommission] =
        rent.percentageManagerCommission;
    map[RentTable.managerCommissionValue] =
        rent.managerCommissionValue;

    return map;
  }

  /// Converts a database column map into a [RentModel] object.
  static RentModel fromMap(Map<String, dynamic> map) {
    return RentModel(
      id: map[RentTable.id].toString(),
      rentState: map[RentTable.rentState],
      clientId: map[RentTable.clientId]?.toString(),
      vehicleId: map[RentTable.vehicleId]?.toString(),
      startDate: DateTime.parse(map[RentTable.startDate]),
      endDate: DateTime.parse(map[RentTable.endDate]),
      numberOfDays: map[RentTable.numberOfDays],
      totalAmountPayable: map[RentTable.totalAmountPayable],
      percentageManagerCommission:
          map[RentTable.percentageManagerCommission],
      managerCommissionValue: map[RentTable.managerCommissionValue],
    );
  }
}

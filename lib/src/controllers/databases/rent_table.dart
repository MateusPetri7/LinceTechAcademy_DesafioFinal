// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/rent_model.dart';


/// A utility class for database operations related to rent.
class RentTable {
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

  static const String tableName = 'rent';
  static const String id = 'id';
  static const String rentState = 'rent_state';
  static const String clientId = 'client_id';
  static const String vehicleId = 'vehicle_id';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String numberOfDays = 'number_of_days';
  static const String totalAmountPayable = 'total_amount_payable';
  static const String percentageManagerCommission =
      'percentage_manager_commission';
  static const String managerCommissionValue = 'manager_commission_value';

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

// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/rentals_held_model.dart';

class RentalsHeldTable {
  static const String createTable = '''
  CREATE TABLE $tableName (
    $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $rentalState TEXT NOT NULL,
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

  static const String tableName = 'rentals_held';
  static const String id = 'id';
  static const String rentalState = 'rental_state';
  static const String clientId = 'client_id';
  static const String vehicleId = 'vehicle_id';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String numberOfDays = 'number_of_days';
  static const String totalAmountPayable = 'total_amount_payable';
  static const String percentageManagerCommission =
      'percentage_manager_commission';
  static const String managerCommissionValue = 'manager_commission_value';

  static Map<String, dynamic> toMap(RentalsHeldModel rentalsHeld) {
    final map = <String, dynamic>{};

    map[RentalsHeldTable.id] = rentalsHeld.id;
    map[RentalsHeldTable.rentalState] = rentalsHeld.rentalState;
    map[RentalsHeldTable.clientId] = rentalsHeld.clientId;
    map[RentalsHeldTable.vehicleId] = rentalsHeld.vehicleId;
    map[RentalsHeldTable.startDate] = rentalsHeld.startDate?.toIso8601String();
    map[RentalsHeldTable.endDate] = rentalsHeld.endDate?.toIso8601String();
    map[RentalsHeldTable.numberOfDays] = rentalsHeld.numberOfDays;
    map[RentalsHeldTable.totalAmountPayable] = rentalsHeld.totalAmountPayable;
    map[RentalsHeldTable.percentageManagerCommission] =
        rentalsHeld.percentageManagerCommission;
    map[RentalsHeldTable.managerCommissionValue] =
        rentalsHeld.managerCommissionValue;

    return map;
  }

  static RentalsHeldModel fromMap(Map<String, dynamic> map) {
    return RentalsHeldModel(
      id: map[RentalsHeldTable.id].toString(),
      rentalState: map[RentalsHeldTable.rentalState],
      clientId: map[RentalsHeldTable.clientId]?.toString(),
      vehicleId: map[RentalsHeldTable.vehicleId]?.toString(),
      startDate: DateTime.parse(map[RentalsHeldTable.startDate]),
      endDate: DateTime.parse(map[RentalsHeldTable.endDate]),
      numberOfDays: map[RentalsHeldTable.numberOfDays],
      totalAmountPayable: map[RentalsHeldTable.totalAmountPayable],
      percentageManagerCommission:
          map[RentalsHeldTable.percentageManagerCommission],
      managerCommissionValue: map[RentalsHeldTable.managerCommissionValue],
    );
  }
}

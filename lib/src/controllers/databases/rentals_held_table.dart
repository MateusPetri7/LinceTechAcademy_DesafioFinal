// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/rentals_held_model.dart';

class RentalsHeldTable {
  static const String createTable = '''
  CREATE TABLE $tableName (
    $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $clientId INTEGER NOT NULL,
    $startDate TEXT NOT NULL,
    $endDate TEXT NOT NULL,
    $numberOfDays INTEGER NOT NULL,
    $totalAmountPayable REAL NOT NULL,
    FOREIGN KEY ($clientId) REFERENCES client(id)
  );
  ''';

  static const String tableName = 'rentals_held';
  static const String id = 'id';
  static const String clientId = 'client_id';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String numberOfDays = 'number_of_days';
  static const String totalAmountPayable = 'total_amount_payable';

  static Map<String, dynamic> toMap(RentalsHeldModel rentalsHeld) {
    final map = <String, dynamic>{};

    map[RentalsHeldTable.id] = rentalsHeld.id;
    map[RentalsHeldTable.clientId] = rentalsHeld.clientId;
    map[RentalsHeldTable.startDate] = rentalsHeld.startDate?.toIso8601String();
    map[RentalsHeldTable.endDate] = rentalsHeld.endDate?.toIso8601String();
    map[RentalsHeldTable.numberOfDays] = rentalsHeld.numberOfDays;
    map[RentalsHeldTable.totalAmountPayable] = rentalsHeld.totalAmountPayable;

    return map;
  }

  static RentalsHeldModel fromMap(Map<String, dynamic> map) {
    return RentalsHeldModel(
      id: map[RentalsHeldTable.id].toString(),
      clientId: map[RentalsHeldTable.clientId]?.toString(),
      startDate: DateTime.parse(map[RentalsHeldTable.startDate]),
      endDate: DateTime.parse(map[RentalsHeldTable.endDate]),
      numberOfDays: map[RentalsHeldTable.numberOfDays],
      totalAmountPayable: map[RentalsHeldTable.totalAmountPayable],
    );
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'client_table.dart';
import 'manager_table.dart';
import 'rentals_held_table.dart';
import 'vehicle_table.dart';

Future<Database> getDatabase() async {
  final path = join(await getDatabasesPath(), 'ss_automoveis.db');

  return openDatabase(
    path,
    version: 6,
    onCreate: (db, version) async {
      await db.execute(ClientTable.createTable);
      await db.execute(ManagerTable.createTable);
      await db.execute(VehicleTable.createTable);
      await db.execute(RentalsHeldTable.createTable);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(ManagerTable.createTable);
      }
      if (oldVersion < 3) {
        await db.execute(
            'ALTER TABLE ${ClientTable.tableName} RENAME COLUMN tin TO companyRegistrationNumber');
        await db.execute(
            'ALTER TABLE ${ClientTable.tableName} ADD COLUMN ${ClientTable.managerId} INTEGER');
      }
      if (oldVersion < 4) {
        await db.execute(VehicleTable.createTable);
      }
      if (oldVersion < 5) {
        await db.execute(
            'ALTER TABLE ${VehicleTable.tableName} ADD COLUMN ${VehicleTable.type} TEXT');
      }
      if (oldVersion < 6) {
        await db.execute('ALTER TABLE Client RENAME TO client');
        await db.execute('ALTER TABLE Manager RENAME TO manager');
        await db.execute('ALTER TABLE Vehicle RENAME TO vehicle');

        await db.execute(
            'ALTER TABLE client RENAME COLUMN companyRegistrationNumber TO company_registration_number');

        await db.execute(
            'ALTER TABLE manager RENAME COLUMN individualTaxpayerRegistry TO individual_taxpayer_registry');
        await db.execute(
            'ALTER TABLE manager RENAME COLUMN commissionPercentage TO commission_percentage');

        await db.execute(
            'ALTER TABLE vehicle RENAME COLUMN yearManufacture TO year_manufacture');
        await db.execute(
            'ALTER TABLE vehicle RENAME COLUMN dailyRentalCost TO daily_rental_cost');
        await db.execute(
            'ALTER TABLE vehicle RENAME COLUMN photosTheVehicle TO photos_the_vehicle');

        await db.execute(RentalsHeldTable.createTable);
      }
    },
  );
}

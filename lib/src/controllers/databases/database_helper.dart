import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'client_table.dart';
import 'manager_table.dart';
import 'vehicle_table.dart';

Future<Database> getDatabase() async {
  final path = join(await getDatabasesPath(), 'ss_automoveis.db');

  return openDatabase(
    path,
    version: 5,
    onCreate: (db, version) async {
      await db.execute(ClientTable.createTable);
      await db.execute(ManagerTable.createTable);
      await db.execute(VehicleTable.createTable);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(ManagerTable.createTable);
      }
      if (oldVersion < 3) {
        await db.execute(
            'ALTER TABLE ${ClientTable.tableName} RENAME COLUMN tin TO companyRegistrationNumber');
        await db.execute(
            'ALTER TABLE ${ClientTable.tableName} ADD COLUMN ${ClientTable.manager_id} INTEGER');
      }
      if (oldVersion < 4) {
        await db.execute(VehicleTable.createTable);
      }
      if (oldVersion < 5) {
        await db.execute(
            'ALTER TABLE ${VehicleTable.tableName} ADD COLUMN ${VehicleTable.type} TEXT');
      }
    },
  );
}

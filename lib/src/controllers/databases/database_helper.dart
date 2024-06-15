import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'client_table.dart';
import 'manager_table.dart';

Future<Database> getDatabase() async {
  final path = join(await getDatabasesPath(), 'ss_automoveis.db');

  return openDatabase(
    path,
    version: 2,
    onCreate: (db, version) async {
      await db.execute(ClientTable.createTable);
      await db.execute(ManagerTable.createTable);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(ManagerTable.createTable);
      }
    },
  );
}

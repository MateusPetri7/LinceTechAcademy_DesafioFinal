import '../../models/pdf_model.dart';
import 'database_helper.dart';
import 'pdf_table.dart';

class PdfController {
  Future<int> insert(PdfModel pdf) async {
    final database = await getDatabase();
    final map = PdfTable.toMap(pdf);

    final id = await database.insert(PdfTable.tableName, map);
    return id;
  }

  Future<void> delete(PdfModel pdf) async {
    final database = await getDatabase();

    await database.delete(
      PdfTable.tableName,
      where: '${PdfTable.id} = ?',
      whereArgs: [pdf.id],
    );
  }

  Future<List<PdfModel>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      PdfTable.tableName,
    );

    var list = <PdfModel>[];
    for (final item in result) {
      list.add(PdfTable.fromMap(item));
    }

    return list;
  }

  Future<PdfModel?> getPdfFromId(String id) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      PdfTable.tableName,
      where: '${PdfTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final item = result.first;
      return PdfTable.fromMap(item);
    }

    return null;
  }
}

import '../../models/pdf_model.dart';
import 'database_helper.dart';
import 'pdf_table.dart';

class PdfController {
  Future<void> insert(PDFModel pdf) async {
    final database = await getDatabase();
    final map = PDFTable.toMap(pdf);

    await database.insert(PDFTable.tableName, map);
  }

  Future<void> delete(PDFModel pdf) async {
    final database = await getDatabase();

    await database.delete(
      PDFTable.tableName,
      where: '${PDFTable.id} = ?',
      whereArgs: [pdf.id],
    );
  }

  Future<List<PDFModel>> select() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> result = await database.query(
      PDFTable.tableName,
    );

    var list = <PDFModel>[];
    for (final item in result) {
      list.add(PDFTable.fromMap(item));
    }

    return list;
  }

  // Future<void> update(PDFModel pdf) async {
  //   final database = await getDatabase();
  //   var map = PDFTable.toMap(pdf);
  //
  //   await database.update(PDFTable.tableName, map,
  //       where: '${PDFTable.id} = ?', whereArgs: [pdf.id]);
  // }
  //
  // Future<PDFModel?> getPdfById(int id) async {
  //   final database = await getDatabase();
  //
  //   final List<Map<String, dynamic>> result = await database.query(
  //     PDFTable.tableName,
  //     where: '${PDFTable.id} = ?',
  //     whereArgs: [id],
  //     limit: 1,
  //   );
  //
  //   if (result.isNotEmpty) {
  //     final item = result.first;
  //     return PDFTable.fromMap(item);
  //   }
  //
  //   return null;
  // }
}

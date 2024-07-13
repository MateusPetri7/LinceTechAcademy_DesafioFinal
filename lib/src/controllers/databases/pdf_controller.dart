import '../../models/pdf_model.dart';
import 'database_helper.dart';
import 'pdf_table.dart';

/// Controller class for managing operations on [PdfModel] in the database.
///
/// This class provides methods to insert, delete, select, and retrieve
/// PDF models from the database using [PdfModel] objects.
class PdfController {
  /// Inserts a new [pdf] into the database.
  ///
  /// Returns the ID of the inserted record.
  Future<int> insert(PdfModel pdf) async {
    final database = await getDatabase();
    final map = PdfTable.toMap(pdf);

    return await database.insert(PdfTable.tableName, map);
  }

  /// Deletes the given [pdf] from the database.
  Future<void> delete(PdfModel pdf) async {
    final database = await getDatabase();

    await database.delete(
      PdfTable.tableName,
      where: '${PdfTable.id} = ?',
      whereArgs: [pdf.id],
    );
  }

  /// Retrieves all PDF models from the database as a list of [PdfModel].
  ///
  /// Returns an empty list if no PDFs are found.
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

  Future<void> update(PdfModel pdf) async {
    final database = await getDatabase();

    var map = PdfTable.toMap(pdf);

    await database.update(PdfTable.tableName, map,
        where: '${PdfTable.id} = ?', whereArgs: [pdf.id]);
  }

  /// Retrieves a PDF model from the database by [id].
  ///
  /// Returns `null` if no PDF with the specified [id] is found.
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

// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/pdf_model.dart';

/// A utility class for database operations related to PDF files.
class PdfTable {
  /// SQL statement to create the PDF table.
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $filePath TEXT NOT NULL
  ); 
  ''';

  /// Name of the PDF table in the database.
  static const String tableName = 'pdf';
  /// Column name for PDF ID.
  static const String id = 'id';
  /// Column name for PDF file path.
  static const String filePath = 'file_path';

  /// Converts a [PdfModel] object into a map of database columns.
  static Map<String, dynamic> toMap(PdfModel pdf) {
    final map = <String, dynamic>{};

    map[PdfTable.id] = pdf.id;
    map[PdfTable.filePath] = pdf.filePath;

    return map;
  }

  /// Converts a database column map into a [PdfModel] object.
  static PdfModel fromMap(Map<String, dynamic> map) {
    return PdfModel(
      id: map[PdfTable.id].toString(),
      filePath: map[PdfTable.filePath],
    );
  }
}

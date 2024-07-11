// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/pdf_model.dart';

class PdfTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $filePath TEXT NOT NULL
  ); 
  ''';

  static const String tableName = 'pdf';
  static const String id = 'id';
  static const String filePath = 'file_path';

  static Map<String, dynamic> toMap(PdfModel pdf) {
    final map = <String, dynamic>{};

    map[PdfTable.id] = pdf.id;
    map[PdfTable.filePath] = pdf.filePath;

    return map;
  }

  static PdfModel fromMap(Map<String, dynamic> map) {
    return PdfModel(
      id: map[PdfTable.id].toString(),
      filePath: map[PdfTable.filePath],
    );
  }
}

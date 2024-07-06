// ignore_for_file: avoid_classes_with_only_static_members
import '../../models/pdf_model.dart';

class PDFTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $filePath TEXT NOT NULL
  ); 
  ''';

  static const String tableName = 'pdf';
  static const String id = 'id';
  static const String filePath = 'file_path';

  static Map<String, dynamic> toMap(PDFModel documentPDF) {
    final map = <String, dynamic>{};

    map[PDFTable.id] = documentPDF.id;
    map[PDFTable.filePath] = documentPDF.filePath;

    return map;
  }

  static PDFModel fromMap(Map<String, dynamic> map) {
    return PDFModel(
      id: map[PDFTable.id].toString(),
      filePath: map[PDFTable.filePath],
    );
  }
}

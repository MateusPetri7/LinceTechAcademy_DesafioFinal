/// A model class representing a PDF file.
class PdfModel {
  /// The unique identifier for the PDF file.
  final String? id;

  /// The file path where the PDF is stored.
  final String? filePath;

  /// Creates a [PdfModel] instance with the given properties.
  ///
  /// Both parameters are optional.
  PdfModel({this.id, this.filePath});
}

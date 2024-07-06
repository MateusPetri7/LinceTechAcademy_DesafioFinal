import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/pdf_model.dart';
import 'databases/pdf_controller.dart' as database;

class PdfController extends ChangeNotifier {
  PdfController() {
    load();
  }

  final _controllerDataBase = database.PdfController();
  String? _filePath;
  final _listPdf = <PDFModel>[];
  PDFModel _currentPdf = PDFModel();

  String? get filePath => _filePath;

  List<PDFModel> get listPdf => _listPdf;

  PDFModel get currentPdf => _currentPdf;

  Future<void> insert(PDFModel pdf) async {
    //final pdf = PDFModel(filePath: _filePath);

    await _controllerDataBase.insert(pdf);

    _clearFields();

    await load();
    notifyListeners();
  }

  Future<void> delete(PDFModel pdf) async {
    await _controllerDataBase.delete(pdf);
    await load();

    notifyListeners();
  }

  Future<List<PDFModel>?> load() async {
    final list = await _controllerDataBase.select();

    _listPdf.clear();
    _listPdf.addAll(list);

    notifyListeners();
  }

  Future<void> createPdf(String content) async {
    final pdf = pw.Document();
    final font = await rootBundle.load('assets/fonts/Rubik-Regular.ttf');
    final ttf = pw.Font.ttf(font);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            'pdf teste',
            style: pw.TextStyle(font: ttf, fontSize: 20),
          ),
        ),
      ),
    );


    final output = await getApplicationSupportDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    _filePath = file.path;
    await insert(PDFModel(filePath: _filePath));

    _clearFields();
    _currentPdf = PDFModel(filePath: _filePath);
    await load();
    notifyListeners();
  }

  Future<void> viewPdf(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await Printing.layoutPdf(
          onLayout: (format) async => file.readAsBytesSync());
    } else {
      throw Exception('PDF file not found');
    }
  }

  Future<void> exportPdf(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await Printing.sharePdf(bytes: await file.readAsBytes(), filename: 'example.pdf');
    } else {
      throw Exception('PDF file not found');
    }
  }

  // void populatePdfInformation(PDFModel pdf) {
  //   _fileNameController.text = pdf.filePath ?? '';
  //   _currentPdf = PDFModel(id: pdf.id);
  // }
  //
  // Future<void> update() async {
  //   final editedPdf =
  //       PDFModel(id: _currentPdf.id, filePath: _fileNameController.text);
  //
  //   await _databaseController.update(editedPdf);
  //
  //   _currentPdf = PDFModel();
  //   _clearFields();
  //
  //   await load();
  //   notifyListeners();
  // }

  void _clearFields() {
    _filePath = '';
  }
}

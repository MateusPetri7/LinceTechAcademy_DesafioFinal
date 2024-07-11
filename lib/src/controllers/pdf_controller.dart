import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/client_model.dart';
import '../models/pdf_model.dart';
import '../models/vehicle_model.dart';
import 'databases/manager_controller.dart' as database_manager;
import 'databases/pdf_controller.dart' as database;

class PdfController extends ChangeNotifier {
  PdfController() {
    load();
  }

  final _controllerDataBase = database.PdfController();
  final _managerControllerDataBase = database_manager.ManagerController();
  String? _filePath;
  final _listPdf = <PdfModel>[];
  PdfModel _currentPdf = PdfModel();

  String? get filePath => _filePath;

  List<PdfModel> get listPdf => _listPdf;

  PdfModel get currentPdf => _currentPdf;

  Future<int> insert(PdfModel pdf) async {
    //final pdf = PDFModel(filePath: _filePath);

    final id = await _controllerDataBase.insert(pdf);

    _clearFields();

    await load();
    notifyListeners();
    return id;
  }

  Future<void> delete(PdfModel pdf) async {
    await _controllerDataBase.delete(pdf);
    await load();

    notifyListeners();
  }

  Future<List<PdfModel>?> load() async {
    final list = await _controllerDataBase.select();

    _listPdf.clear();
    _listPdf.addAll(list);

    notifyListeners();
  }

  Future<PdfModel> getPdfFromId(String id) async {
    final pdf = await _controllerDataBase.getPdfFromId(id);
    return pdf!;
  }

  Future<void> createPdf(ClientModel client, VehicleModel vehicle) async {
    final pdf = pw.Document();
    final font = await rootBundle.load('assets/fonts/Rubik-Regular.ttf');
    final ttf = pw.Font.ttf(font);

    final manager = await _managerControllerDataBase
        .getManagerFromId(client.managerId.toString());

    // Carregar as fotos do veículo
    List<pw.Widget> vehiclePhotosWidgets = [];
    if (vehicle.photosTheVehicle != null) {
      for (var photoPath in vehicle.photosTheVehicle!) {
        final photoFile = File(photoPath);
        if (await photoFile.exists()) {
          final photo = pw.MemoryImage(photoFile.readAsBytesSync());
          vehiclePhotosWidgets.add(pw.Image(photo, width: 100, height: 100));
        }
      }
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Cabeçalho com o nome da empresa
            pw.Center(
              child: pw.Text(
                'SS Automóveis',
                style: pw.TextStyle(font: ttf, fontSize: 24),
              ),
            ),
            // Espaçamento entre o cabeçalho e o conteúdo
            pw.SizedBox(height: 20),
            // Texto com a data da geração do comprovante
            pw.Text(
              'Data de geração: ${DateTime.now().toLocal()}',
              style: pw.TextStyle(font: ttf, fontSize: 14),
            ),
            pw.SizedBox(height: 20),
            // Seção do Cliente
            pw.Text(
              'Informações do Cliente:',
              style: pw.TextStyle(
                  font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Nome: ${client.name}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Telefone: ${client.telephone}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Cidade: ${client.city}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Estado: ${client.state}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('CNPJ: ${client.companyRegistrationNumber}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.SizedBox(height: 20),
            // Seção do Gerente
            pw.Text(
              'Informações do Gerente:',
              style: pw.TextStyle(
                  font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Nome: ${manager!.name}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('CPF: ${manager.individualTaxpayerRegistry}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Estado: ${manager.state}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Telefone: ${manager.telephone}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Percentual de Comissão: ${manager.commissionPercentage}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.SizedBox(height: 20),
            // Seção do Veículo
            pw.Text(
              'Informações do Veículo:',
              style: pw.TextStyle(
                  font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Tipo: ${vehicle.type}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Marca: ${vehicle.brand}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Modelo: ${vehicle.model}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Placa: ${vehicle.plate}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Ano de Fabricação: ${vehicle.yearManufacture}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Text('Custo Diário de Aluguel: R\$${vehicle.dailyRentalCost}',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.SizedBox(height: 20),
            // Seção das Fotos do Veículo
            pw.Text(
              'Fotos do Veículo:',
              style: pw.TextStyle(
                  font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Wrap(
              spacing: 10,
              // Espaçamento horizontal entre as fotos
              runSpacing: 10,
              // Espaçamento vertical entre as linhas de fotos
              children: vehiclePhotosWidgets,
            ),
          ],
        ),
      ),
    );

    final output = await getApplicationSupportDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    _filePath = file.path;
    final id = await insert(PdfModel(filePath: _filePath));

    _currentPdf = await getPdfFromId(id.toString());

    _clearFields();
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
      await Printing.sharePdf(
          bytes: await file.readAsBytes(), filename: 'example.pdf');
    } else {
      throw Exception('PDF file not found');
    }
  }

  void _clearFields() {
    _filePath = '';
  }
}

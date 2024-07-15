import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pdf_controller.dart';
import '../models/pdf_model.dart';

class PdfView extends StatelessWidget {
  final PdfModel pdf;

  const PdfView({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    final pdfController = Provider.of<PdfController>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await pdfController.viewPdf(pdf.filePath!);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error viewing PDF')),
                  );
                }
              },
              child: Text('Visualizar PDF'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await pdfController
                      .exportPdf(pdfController.currentPdf.filePath!);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error exporting PDF')),
                  );
                }
              },
              child: Text('Exportar PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

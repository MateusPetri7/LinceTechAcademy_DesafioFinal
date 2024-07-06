import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pdf_controller.dart';

class PdfView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pdfController = Provider.of<PdfController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await pdfController.createPdf("Hello, Flutter!");
              },
              child: Text('Create PDF'),
            ),
            Text('PDF saved at: ${pdfController.filePath}'),
            ElevatedButton(
              onPressed: () async {
                try {
                  await pdfController.viewPdf(pdfController.currentPdf.filePath!);
                } catch (e) {
                  print('Error viewing PDF: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error viewing PDF')),
                  );
                }
              },
              child: Text('Open PDF'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await pdfController.exportPdf(pdfController.currentPdf.filePath!);
                } catch (e) {
                  print('Error exporting PDF: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error exporting PDF')),
                  );
                }
              },
              child: Text('Export PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/pdf_controller.dart';
import 'manager_edit.dart';

class RegisteredPDF extends StatelessWidget {
  const RegisteredPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<PdfController>(builder: (context, state, _) {
              return ListView.builder(
                itemCount: state.listPdf.length,
                itemBuilder: (context, index) {
                  final pdf = state.listPdf[index];
                  return ListTile(
                    title: Text('Id: ${pdf.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Caminho: ${pdf.filePath}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // IconButton(
                        //   icon: const Icon(Icons.edit),
                        //   onPressed: () {
                        //     Navigator.pushNamed(
                        //       context,
                        //       AppRoutes.editRentals,
                        //       arguments: rentals,
                        //     );
                        //   },
                        // ),
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () {
                            state.viewPdf(pdf.filePath!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            state.exportPdf(pdf.filePath!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

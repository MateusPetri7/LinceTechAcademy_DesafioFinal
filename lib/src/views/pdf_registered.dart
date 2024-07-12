import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pdf_controller.dart';

class RegisteredPDF extends StatelessWidget {
  const RegisteredPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<PdfController>(context, listen: false).load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Ocorreu um erro ao carregar os dados'),
            );
          } else {
            return Column(
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
            );
          }
        },
      ),
    );
  }
}

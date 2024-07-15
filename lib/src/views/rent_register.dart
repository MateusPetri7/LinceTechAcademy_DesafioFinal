import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/pdf_controller.dart';
import '../controllers/rent_controller.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/rent_form_field.dart';

class RegisterRent extends StatelessWidget {
  const RegisterRent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = context.read<RentController>().formKey;
    final state = Provider.of<RentController>(context, listen: false);

    return BaseScaffold(
      title: AppLocalizations.of(context)!.rentRegister,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PdfController>(
          builder: (context, pdfState, _) {
            return RentFormFields(
              formKey: formKey,
              buttonText: AppLocalizations.of(context)!.registerRent,
              buttonIcon: Icons.add,
              onButtonPressed: () async {
                if (formKey.currentState!.validate()) {
                  final startDate = DateTime.parse(state.startDateController.text.split('/').reversed.join('-'));
                  final endDate = DateTime.parse(state.endDateController.text.split('/').reversed.join('-'));
                  var isValidRange = true;

                  for (var i = startDate; i.isBefore(endDate.add(const Duration(days: 1))); i = i.add(const Duration(days: 1))) {
                    if (state.occupiedDates.contains(i)) {
                      isValidRange = false;
                      break;
                    }
                  }

                  if (isValidRange) {
                    await state.insert();
                    await pdfState.createPdf(
                      state.selectedClient!,
                      state.selectedVehicle!,
                      state.rentCurrent!,
                    );
                    state.clearControllers();
                    Navigator.pushNamed(
                      context,
                      AppRoutes.pdfView,
                      arguments: pdfState.currentPdf,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Intervalo de datas inválido'),
                          content: const Text('Selecione um intervalo de datas contínuo e livre.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            );
          },
        ),
      ),
      onIconPressed: (index) {
        state.clearControllers();
        switch (index) {
          case 0:
            Navigator.pop(context);
            break;
          case 1:
            Navigator.pushNamed(context, AppRoutes.home);
            break;
        }
      },
    );
  }
}


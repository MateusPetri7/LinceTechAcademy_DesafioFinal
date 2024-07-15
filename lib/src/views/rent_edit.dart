import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/pdf_controller.dart';
import '../controllers/rent_controller.dart';
import '../models/rent_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/rent_form_field.dart';

class EditRent extends StatefulWidget {
  final RentModel rent;

  const EditRent({Key? key, required this.rent});

  @override
  _EditRentState createState() => _EditRentState();
}

class _EditRentState extends State<EditRent> {
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = context.read<RentController>().generateFormKey();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = Provider.of<RentController>(context, listen: false);
      await state.populateRentInformation(widget.rent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RentController>(context, listen: false);

    return BaseScaffold(
      title: AppLocalizations.of(context)!.rentEdit,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PdfController>(
          builder: (context, pdfState, _) {
            return RentFormFields(
              formKey: formKey,
              buttonText: AppLocalizations.of(context)!.editRent,
              buttonIcon: Icons.edit,
              onButtonPressed: () async {
                if (formKey.currentState!.validate()) {
                  final startDate =
                  DateTime.parse(state.startDateController.text.split('/').reversed.join('-'));
                  final endDate =
                  DateTime.parse(state.endDateController.text.split('/').reversed.join('-'));
                  var isValidRange = true;

                  for (var i = startDate;
                  i.isBefore(endDate.add(const Duration(days: 1)));
                  i = i.add(const Duration(days: 1))) {
                    if (state.occupiedDates.contains(i)) {
                      isValidRange = false;
                      break;
                    }
                  }

                  if (isValidRange) {
                    await state.update();
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Selecione um intervalo de datas contínuo e livre.',
                        ),
                      ),
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

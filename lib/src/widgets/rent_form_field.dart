import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/pdf_controller.dart';
import '../controllers/rent_controller.dart';
import '../models/client_model.dart';
import '../models/vehicle_model.dart';
import '../widgets/custom_dropdown_form_field.dart';
import '../widgets/custom_style_button.dart';
import '../widgets/custom_text_form_field.dart';

class RentFormFields extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onButtonPressed;
  final GlobalKey<FormState> formKey;

  const RentFormFields({
    Key? key,
    required this.buttonText,
    required this.buttonIcon,
    required this.onButtonPressed,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rentState = Provider.of<RentController>(context, listen: false);
    final pdfState = Provider.of<PdfController>(context, listen: false);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            CustomDropdownButtonFormField(
              labelText: 'Selecione o estado de locação',
              icon: Icons.location_city,
              items: rentState.states,
              onChanged: (value) async {
                rentState.selectedState = value;
                if (value != null) {
                  await rentState.loadVehicles(value);
                }
              },
              value: rentState.selectedState,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Estado é obrigatório.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            CustomDropdownButtonFormField(
              labelText: 'Selecione o cliente',
              icon: Icons.person,
              items: rentState.listClient
                  .map((ClientModel client) => client.name!)
                  .toList(),
              onChanged: (String? value) {
                rentState.selectedClient = rentState.listClient
                    .firstWhere((client) => client.name == value);
              },
              value: rentState.selectedClient?.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cliente é obrigatório.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            CustomDropdownButtonFormField(
              labelText: 'Selecione o veículo',
              icon: Icons.directions_car,
              items: rentState.listVehicle
                  .map((vehicle) =>
              '${vehicle.brand!} - ${vehicle.model!}')
                  .toList(),
              onChanged: (value) {
                rentState.selectedVehicle = rentState.listVehicle
                    .firstWhere((vehicle) =>
                '${vehicle.brand!} - ${vehicle.model!}' == value);
              },
              value: rentState.selectedVehicle != null
                  ? '${rentState.selectedVehicle!.brand!} -'
                  ' ${rentState.selectedVehicle!.model!}'
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veículo é obrigatório.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              labelText: 'Data de Início',
              icon: Icons.calendar_today,
              controller: rentState.startDateController,
              readOnly: true,
              onTapCallback: () => rentState.selectDate(
                context,
                rentState.startDateController,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Data de Início é obrigatória.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              labelText: 'Data de Término',
              icon: Icons.calendar_today,
              controller: rentState.endDateController,
              readOnly: true,
              onTapCallback: () => rentState.selectDate(
                context,
                rentState.endDateController,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Data de Término é obrigatória.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              labelText: 'Número de Dias',
              icon: Icons.calendar_today,
              controller: rentState.numberOfDaysController,
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              labelText: 'Valor Total a Pagar',
              icon: Icons.monetization_on,
              controller: rentState.totalAmountPayableController,
              keyboardType: TextInputType.number,
              readOnly: true,
              isCurrency: true,
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              labelText: 'Percentual de comissão do gerente',
              icon: Icons.person,
              controller:
              rentState.percentageManagerCommissionController,
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              labelText: 'Valor comissão do gerente',
              icon: Icons.monetization_on,
              controller: rentState.managerCommissionValueController,
              keyboardType: TextInputType.number,
              readOnly: true,
              isCurrency: true,
            ),
            const SizedBox(height: 20.0),
            CustomStyledButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final startDate = DateTime.parse(rentState
                      .startDateController.text
                      .split('/')
                      .reversed
                      .join('-'));
                  final endDate = DateTime.parse(rentState
                      .endDateController.text
                      .split('/')
                      .reversed
                      .join('-'));
                  var isValidRange = true;

                  for (var i = startDate;
                  i.isBefore(endDate.add(const Duration(days: 1)));
                  i = i.add(const Duration(days: 1))) {
                    if (rentState.occupiedDates.contains(i)) {
                      isValidRange = false;
                      break;
                    }
                  }

                  if (isValidRange) {
                    await rentState.insert();
                    await pdfState.createPdf(
                      rentState.selectedClient!,
                      rentState.selectedVehicle!,
                      rentState.rentCurrent!,
                    );
                    rentState.clearControllers();
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
              icon: Icon(buttonIcon),
              label: buttonText,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

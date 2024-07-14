import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/rent_controller.dart';
import '../models/client_model.dart';
import '../models/rent_model.dart';
import '../models/vehicle_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_text_form_field.dart';

class DetailsRent extends StatelessWidget {
  final RentModel rent;

  const DetailsRent({Key? key, required this.rent});

  @override
  Widget build(BuildContext context) {
    final rentState = Provider.of<RentController>(context, listen: false);

    return BaseScaffold(
      title: AppLocalizations.of(context)!.clientEdit,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<RentController>(
          builder: (context, rentState, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    labelText: 'Cliente',
                    icon: Icons.person,
                    controller: TextEditingController(
                        text: rentState.selectedClient!.name),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Veículo',
                    icon: Icons.directions_car,
                    controller: TextEditingController(
                        text:
                            '${rentState.selectedVehicle!.brand} -'
                                ' ${rentState.selectedVehicle!.model}'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Data de Início',
                    icon: Icons.calendar_today,
                    controller: TextEditingController(
                        text: rentState.startDateController.text),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Data de Término',
                    icon: Icons.calendar_today,
                    controller: TextEditingController(
                        text: rentState.endDateController.text),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Número de Dias',
                    icon: Icons.calendar_today,
                    controller: TextEditingController(
                        text: rentState.numberOfDaysController.text),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Valor Total a Pagar',
                    icon: Icons.monetization_on,
                    controller: TextEditingController(
                        text: rentState.totalAmountPayableController.text),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    isCurrency: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Percentual de comissão do gerente',
                    icon: Icons.person,
                    controller: TextEditingController(
                        text: rentState
                            .percentageManagerCommissionController.text),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Valor comissão do gerente',
                    icon: Icons.monetization_on,
                    controller: TextEditingController(
                        text: rentState.managerCommissionValueController.text),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    isCurrency: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      onIconPressed: (index) {
        rentState.clearControllers();
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

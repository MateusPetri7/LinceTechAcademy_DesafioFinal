import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/pdf_controller.dart';
import '../controllers/rentals_held_controller.dart';
import '../models/client_model.dart';
import '../models/vehicle_model.dart';

class RegisterRentalsHeld extends StatelessWidget {
  const RegisterRentalsHeld({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<RentalsHeldController, PdfController>(
          builder: (context, rentalsState, pdfState, _) {
            return Form(
              key: rentalsState.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: rentalsState.selectedState,
                    hint: const Text('Selecione o estado de locação'),
                    items: rentalsState.states
                        .map<DropdownMenuItem<String>>((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (String? value) async {
                      rentalsState.selectedState = value;
                      if (value != null) {
                        await rentalsState.loadVehicles(value);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estado é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<ClientModel>(
                    value: rentalsState.selectedClient,
                    hint: const Text('Selecione o cliente'),
                    items: rentalsState.listClient
                        .map<DropdownMenuItem<ClientModel>>(
                            (ClientModel client) {
                      return DropdownMenuItem<ClientModel>(
                        value: client,
                        child: Text(client.name!),
                      );
                    }).toList(),
                    onChanged: (ClientModel? value) {
                      rentalsState.selectedClient = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Cliente é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<VehicleModel>(
                    value: rentalsState.selectedVehicle,
                    hint: const Text('Selecione o veículo'),
                    items: rentalsState.listVehicle
                        .map<DropdownMenuItem<VehicleModel>>(
                            (VehicleModel vehicle) {
                      return DropdownMenuItem<VehicleModel>(
                        value: vehicle,
                        child: Text('${vehicle.brand!} - ${vehicle.model!}'),
                      );
                    }).toList(),
                    onChanged: (VehicleModel? value) {
                      rentalsState.selectedVehicle = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veículo é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: rentalsState.startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data de Início',
                    ),
                    onTap: () => rentalsState.selectDate(
                        context, rentalsState.startDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Data de Início é obrigatória.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: rentalsState.endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data de Término',
                    ),
                    onTap: () => rentalsState.selectDate(
                        context, rentalsState.endDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Data de Término é obrigatória.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: rentalsState.numberOfDaysController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Número de Dias',
                    ),
                  ),
                  TextFormField(
                    controller: rentalsState.totalAmountPayableController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Valor Total a Pagar',
                    ),
                  ),
                  TextFormField(
                    controller:
                        rentalsState.percentageManagerCommissionController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Pencentual de comissão do gerente',
                    ),
                  ),
                  TextFormField(
                    controller: rentalsState.managerCommissionValueController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Valor comissão do gerente',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (rentalsState.formKey.currentState!.validate()) {
                        await rentalsState.insert();
                        await pdfState.createPdf(
                            rentalsState.selectedClient!,
                            rentalsState.selectedVehicle!,
                            rentalsState.rentalsCurrent!);
                        rentalsState.clearControllers();
                        Navigator.pushNamed(
                          context,
                          AppRoutes.pdfView,
                          arguments: pdfState.currentPdf,
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Cadastrar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/pdf_controller.dart';
import '../controllers/rent_controller.dart';
import '../models/client_model.dart';
import '../models/vehicle_model.dart';

class RegisterRent extends StatelessWidget {
  const RegisterRent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<RentController, PdfController>(
          builder: (context, rentState, pdfState, _) {
            return Form(
              key: rentState.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: rentState.selectedState,
                    hint: const Text('Selecione o estado de locação'),
                    items: rentState.states
                        .map<DropdownMenuItem<String>>((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (String? value) async {
                      rentState.selectedState = value;
                      if (value != null) {
                        await rentState.loadVehicles(value);
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
                    value: rentState.selectedClient,
                    hint: const Text('Selecione o cliente'),
                    items: rentState.listClient
                        .map<DropdownMenuItem<ClientModel>>(
                            (ClientModel client) {
                      return DropdownMenuItem<ClientModel>(
                        value: client,
                        child: Text(client.name!),
                      );
                    }).toList(),
                    onChanged: (ClientModel? value) {
                      rentState.selectedClient = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Cliente é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<VehicleModel>(
                    value: rentState.selectedVehicle,
                    hint: const Text('Selecione o veículo'),
                    items: rentState.listVehicle
                        .map<DropdownMenuItem<VehicleModel>>(
                            (VehicleModel vehicle) {
                      return DropdownMenuItem<VehicleModel>(
                        value: vehicle,
                        child: Text('${vehicle.brand!} - ${vehicle.model!}'),
                      );
                    }).toList(),
                    onChanged: (VehicleModel? value) {
                      rentState.selectedVehicle = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veículo é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: rentState.startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data de Início',
                    ),
                    onTap: () => rentState.selectDate(
                        context, rentState.startDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Data de Início é obrigatória.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: rentState.endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data de Término',
                    ),
                    onTap: () => rentState.selectDate(
                        context, rentState.endDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Data de Término é obrigatória.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: rentState.numberOfDaysController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Número de Dias',
                    ),
                  ),
                  TextFormField(
                    controller: rentState.totalAmountPayableController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Valor Total a Pagar',
                    ),
                  ),
                  TextFormField(
                    controller: rentState.percentageManagerCommissionController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Pencentual de comissão do gerente',
                    ),
                  ),
                  TextFormField(
                    controller: rentState.managerCommissionValueController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Valor comissão do gerente',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (rentState.formKey.currentState!.validate()) {
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
                              rentState.rentCurrent!);
                          rentState.clearControllers();
                          Navigator.pushNamed(
                            context,
                            AppRoutes.pdfView,
                            arguments: pdfState.currentPdf,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Selecione um intervalo de datas contínuo e livre.')));
                        }
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

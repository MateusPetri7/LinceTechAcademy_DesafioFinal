import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/vehicle_controller.dart';

class RegisterVehicle extends StatelessWidget {
  const RegisterVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<VehicleController>(
          builder: (context, state, _) {
            return Form(
              key: state.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: state.brandController,
                    decoration: InputDecoration(labelText: 'Marca'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //if (state.tinContro.text.isNotEmpty) {
                        state.getVehiclesBrands();
                        state.getVehicheModels();
                      //   state.populateClientInformation(state.clientCurrent);
                      // }
                    },
                    child: Text('Buscar dados'),
                  ),
                  TextFormField(
                    controller: state.modelController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Modelo',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Modelo é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.plateController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Placa é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.yearManufactureController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Ano de fabricação',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ano de fabricação é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.dailyRentalCostController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Custo da diária de aluguel',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Custo da diária de aluguel é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.photosTheVehicleController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'fotos do veículo',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'fotos do veículo.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (state.formKey.currentState!.validate()) {
                        await state.insert();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Cadastrar'),
                    style: ElevatedButton.styleFrom(),
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

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/image_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../models/vehicle_brand_model.dart';
import '../models/vehicle_model_model.dart';

class RegisterVehicle extends StatelessWidget {
  const RegisterVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<VehicleController, ImageController>(
          builder: (context, vehicleState, imageState, _) {
            return Form(
              key: vehicleState.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<String>(
                    value: vehicleState.selectedType,
                    hint: Text('Selecione o tipo'),
                    items: vehicleState.types
                        .map<DropdownMenuItem<String>>((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      vehicleState.selectedType = value;
                      if(value != null) {
                        vehicleState.getVehicleBrands(value);
                      }
                    },
                  ),
                  DropdownButton<VehicleBrandModel>(
                    value: vehicleState.selectedBrand,
                    hint: const Text('Selecione a marca'),
                    items: vehicleState.vehicleBrands
                        .map<DropdownMenuItem<VehicleBrandModel>>(
                            (VehicleBrandModel brand) {
                          return DropdownMenuItem<VehicleBrandModel>(
                            value: brand,
                            child: Text(brand.name),
                          );
                        }).toList(),
                    onChanged: (VehicleBrandModel? value) {
                      vehicleState.selectedBrand = value;
                      if (value != null) {
                        vehicleState.getVehicleModels(value.code);
                      }
                    },
                  ),
                  DropdownButton<VehicleModelModel>(
                    value: vehicleState.selectedModel,
                    hint: const Text('Selecione o modelo'),
                    items: vehicleState.vehicleModels
                        .map<DropdownMenuItem<VehicleModelModel>>(
                            (VehicleModelModel model) {
                          return DropdownMenuItem<VehicleModelModel>(
                            value: model,
                            child: Text(model.name),
                          );
                        }).toList(),
                    onChanged: (VehicleModelModel? value) {
                      vehicleState.selectedModel = value;
                    },
                  ),
                  TextFormField(
                    controller: vehicleState.plateController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Placa',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Placa é obrigatória.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: vehicleState.yearManufactureController,
                    keyboardType: TextInputType.number,
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
                    controller: vehicleState.dailyRentalCostController,
                    keyboardType: TextInputType.number,
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
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            imageState.pickImage(ImageSource.gallery),
                        child: const Text('Selecionar imagem da galeria'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            imageState.pickImage(ImageSource.camera),
                        child: const Text('Tirar foto'),
                      ),
                      if (imageState.selectedImage != null)
                        Image.file(
                          imageState.selectedImage!,
                          height: 200,
                          width: 200,
                        ),
                    ],
                  ),
                  TextFormField(
                    controller: vehicleState.photosTheVehicleController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Fotos do veículo',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fotos do veículo são obrigatórias.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (vehicleState.formKey.currentState!.validate()) {
                        await vehicleState.insert();
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

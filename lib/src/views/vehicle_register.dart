import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
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
                        if (value != null) {
                          vehicleState.getVehicleBrands(value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tipo do veículo é obrigatório.';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<VehicleBrandModel>(
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
                      validator: (value) {
                        if (value == null) {
                          return 'Marca do veículo é obrigatória.';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<VehicleModelModel>(
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
                      validator: (value) {
                        if (value == null) {
                          return 'Madelo do veículo é obrigatório.';
                        }
                        return null;
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ano de fabricação é obrigatório.';
                        }
                        if (value.length != 4) {
                          return 'Ano de fabricação inválido.';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: vehicleState.selectedState,
                      hint: const Text('Selecione o estado'),
                      items: vehicleState.states
                          .map<DropdownMenuItem<String>>((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        vehicleState.selectedState = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Estado é obrigatório.';
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(
                          moeda: true,
                        ),
                      ],
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
                          onPressed: () async {
                            await imageState.pickImage(ImageSource.gallery,
                                vehicleState.plateController.text.toString());
                            if (imageState.selectedImage != null) {
                              vehicleState
                                  .addPhoto(imageState.selectedImage!.path);
                            }
                          },
                          child: const Text('Selecionar imagem da galeria'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await imageState.pickImage(ImageSource.camera,
                                vehicleState.plateController.text.toString());
                            if (imageState.selectedImage != null) {
                              vehicleState
                                  .addPhoto(imageState.selectedImage!.path);
                            }
                          },
                          child: const Text('Tirar foto'),
                        ),
                        Wrap(
                          children: vehicleState.photosTheVehicle
                              .map((imagePath) => Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.file(
                                          File(imagePath),
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () {
                                            vehicleState.removePhoto(imagePath);
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ],
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
              ),
            );
          },
        ),
      ),
    );
  }
}

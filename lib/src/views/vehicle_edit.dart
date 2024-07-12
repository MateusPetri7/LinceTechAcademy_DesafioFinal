import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/image_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../models/vehicle_model.dart';

class EditVehicle extends StatefulWidget {
  final VehicleModel vehicle;

  const EditVehicle({super.key, required this.vehicle});

  @override
  _EditVehicleState createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vehicleState = Provider.of<VehicleController>(context, listen: false);
      vehicleState.populateVehicleInformation(widget.vehicle);
    });
  }

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
                    TextFormField(
                      controller: vehicleState.typeController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Tipo',
                      ),
                    ),
                    TextFormField(
                      controller: vehicleState.brandController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Marca',
                      ),
                    ),
                    TextFormField(
                      controller: vehicleState.modelController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Modelo',
                      ),
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
                            await imageState.pickImage(
                                ImageSource.gallery, vehicleState.plateController.text.toString());
                            if (imageState.selectedImage != null) {
                              vehicleState.addPhoto(imageState.selectedImage!.path);
                            }
                          },
                          child: const Text('Selecionar imagem da galeria'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await imageState.pickImage(
                                ImageSource.camera, vehicleState.plateController.text.toString());
                            if (imageState.selectedImage != null) {
                              vehicleState.addPhoto(imageState.selectedImage!.path);
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
                                  icon: const Icon(Icons.close, color: Colors.red),
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
                          await vehicleState.update();
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
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

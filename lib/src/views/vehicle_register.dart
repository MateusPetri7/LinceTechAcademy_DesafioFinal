import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/image_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../models/vehicle_brand_model.dart';
import '../models/vehicle_model_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_dropdown_form_field.dart';
import '../widgets/custom_image_field.dart';
import '../widgets/custom_style_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_vehicle_dropdow_form_field.dart';

class RegisterVehicle extends StatelessWidget {
  const RegisterVehicle({Key? key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VehicleController>(context, listen: false);
    final imageState = Provider.of<ImageController>(context, listen: false);

    return BaseScaffold(
      title: AppLocalizations.of(context)!.clientRegister,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Consumer<VehicleController>(
            builder: (context, vehicleState, _) {
              return Form(
                key: vehicleState.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20.0),
                    CustomVehicleDropdownFormField(
                      labelText: 'Selecione o tipo',
                      icon: Icons.category,
                      items: vehicleState.types,
                      value: vehicleState.selectedType,
                      onChanged: (dynamic value) {
                        vehicleState.selectedType = value as String?;
                        if (value != null) {
                          vehicleState.getVehicleBrands(value as String);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tipo do veículo é obrigatório.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomVehicleDropdownFormField(
                      labelText: 'Selecione a marca',
                      icon: Icons.branding_watermark,
                      items: vehicleState.vehicleBrands,
                      value: vehicleState.selectedBrand,
                      onChanged: (dynamic value) {
                        vehicleState.selectedBrand = value as VehicleBrandModel?;
                        if (value != null) {
                          vehicleState.getVehicleModels((value).code);
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Marca do veículo é obrigatória.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomVehicleDropdownFormField(
                      labelText: 'Selecione o modelo',
                      icon: Icons.model_training,
                      items: vehicleState.vehicleModels,
                      value: vehicleState.selectedModel,
                      onChanged: (dynamic value) {
                        vehicleState.selectedModel = value as VehicleModelModel?;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Modelo do veículo é obrigatório.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: 'Placa',
                      icon: Icons.directions_car,
                      controller: vehicleState.plateController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Placa é obrigatória.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: 'Ano de fabricação',
                      icon: Icons.date_range,
                      controller: vehicleState.yearManufactureController,
                      keyboardType: TextInputType.number,
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
                    const SizedBox(height: 20.0),
                    CustomDropdownButtonFormField(
                      labelText: AppLocalizations.of(context)!.state,
                      icon: Icons.location_on,
                      items: state.states,
                      value: state.selectedState,
                      onChanged: (value) {
                        state.selectedState = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.stateRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: 'Custo da diária de aluguel',
                      icon: Icons.attach_money,
                      controller: vehicleState.dailyRentalCostController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Custo da diária de aluguel é obrigatório.';
                        }
                        return null;
                      },
                      isCurrency: true,
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomImageField(
                          onImageSourceSelected: (source) async {
                            await imageState.pickImage(
                              source,
                              vehicleState.plateController.text.toString(),
                            );
                            if (imageState.selectedImage != null) {
                              vehicleState.addPhoto(imageState.selectedImage!.path);
                            }
                          },
                          imagePaths: vehicleState.photosTheVehicle,
                          onRemoveImage: vehicleState.removePhoto,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    CustomStyledButton(
                      onPressed: () async {
                        if (vehicleState.formKey.currentState!.validate()) {
                          await vehicleState.insert();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: 'Cadastrar',
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              );
            },
          ),
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

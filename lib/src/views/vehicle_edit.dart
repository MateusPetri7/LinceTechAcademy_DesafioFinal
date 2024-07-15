import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/image_controller.dart';
import '../controllers/vehicle_controller.dart';
import '../models/vehicle_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_dropdown_form_field.dart';
import '../widgets/custom_image_field.dart';
import '../widgets/custom_style_button.dart';
import '../widgets/custom_text_form_field.dart';

class EditVehicle extends StatefulWidget {
  final VehicleModel vehicle;

  const EditVehicle({Key? key, required this.vehicle}) : super(key: key);

  @override
  _EditVehicleState createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  late VehicleController vehicleState;
  late ImageController imageState;

  @override
  void initState() {
    super.initState();
    vehicleState = Provider.of<VehicleController>(context, listen: false);
    imageState = Provider.of<ImageController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vehicleState.populateVehicleInformation(widget.vehicle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: AppLocalizations.of(context)!.vehicleEdit,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: vehicleState.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: 'Tipo',
                  icon: Icons.category,
                  controller: vehicleState.typeController,
                  readOnly: true,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: 'Marca',
                  icon: Icons.branding_watermark,
                  controller: vehicleState.brandController,
                  readOnly: true,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: 'Modelo',
                  icon: Icons.model_training,
                  controller: vehicleState.modelController,
                  readOnly: true,
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
                  labelText: 'Selecione o estado',
                  icon: Icons.location_on,
                  items: vehicleState.states,
                  value: vehicleState.selectedState,
                  onChanged: (value) {
                    setState(() {
                      vehicleState.selectedState = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Estado é obrigatório.';
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
                          setState(() {
                            vehicleState.addPhoto(imageState.selectedImage!.path);
                          });
                        }
                      },
                      imagePaths: vehicleState.photosTheVehicle,
                      onRemoveImage: (imagePath) {
                        setState(() {
                          vehicleState.removePhoto(imagePath);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CustomStyledButton(
                  onPressed: () async {
                    if (vehicleState.formKey.currentState!.validate()) {
                      await vehicleState.update();
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: AppLocalizations.of(context)!.editVehicle,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
      onIconPressed: (index) {
        vehicleState.clearControllers();
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

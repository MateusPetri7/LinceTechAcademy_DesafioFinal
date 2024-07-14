import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/vehicle_controller.dart';
import '../models/vehicle_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_image_field_details.dart';
import '../widgets/custom_text_form_field.dart';

class DetailsVehicle extends StatelessWidget {
  final VehicleModel vehicle;

  const DetailsVehicle({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VehicleController>(context, listen: false);
    return BaseScaffold(
      title: 'Detalhes do Veículo',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<VehicleController>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    labelText: 'Tipo',
                    icon: Icons.category,
                    controller: TextEditingController(text: vehicle.type),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Marca',
                    icon: Icons.branding_watermark,
                    controller: TextEditingController(text: vehicle.brand),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Modelo',
                    icon: Icons.model_training,
                    controller: TextEditingController(text: vehicle.model),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Placa',
                    icon: Icons.directions_car,
                    controller: TextEditingController(text: vehicle.plate),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Ano de Fabricação',
                    icon: Icons.date_range,
                    controller: TextEditingController(
                        text: vehicle.yearManufacture.toString()),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Estado',
                    icon: Icons.location_on,
                    controller: TextEditingController(text: vehicle.state),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Custo da Diária de Aluguel',
                    icon: Icons.attach_money,
                    controller: TextEditingController(
                        text: vehicle.dailyRentalCost.toString()),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomImageFieldDetails(
                        imagePaths: vehicle.photosTheVehicle!,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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

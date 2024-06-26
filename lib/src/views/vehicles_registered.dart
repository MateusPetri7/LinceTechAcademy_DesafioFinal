import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/vehicle_controller.dart';

class RegisteredVehicles extends StatelessWidget {
  const RegisteredVehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<VehicleController>(builder: (context, state, _) {
              return ListView.builder(
                itemCount: state.listVehicle.length,
                itemBuilder: (context, index) {
                  final vehicle = state.listVehicle[index];
                  return ListTile(
                    title: Text('Marca: ${vehicle.brand}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Modelo: ${vehicle.model}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.editVehicle,
                              arguments: vehicle,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            state.delete(vehicle);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

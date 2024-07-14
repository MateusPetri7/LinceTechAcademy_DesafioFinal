import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/vehicle_controller.dart';
import '../widgets/base_scaffold_floating_button.dart';
import '../widgets/custom_list_view.dart';

class RegisteredVehicles extends StatelessWidget {
  const RegisteredVehicles({Key? key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFloatingButton(
      title: 'Veiculos',
      buttonText: 'Novo Veículo',
      buttonRoute: AppRoutes.registerVehicle,
      body: FutureBuilder(
        future: Provider.of<VehicleController>(context, listen: false).load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Ocorreu um erro ao carregar os dados'),
            );
          } else {
            return Consumer<VehicleController>(
              builder: (context, state, _) {
                if (state.listVehicle.isEmpty) {
                  return const Center(
                    child: Text('Nenhum veículo encontrado'),
                  );
                }
                return CustomListView(
                  items: state.listVehicle,
                  getTitle: (vehicle) => 'Marca: ${vehicle.brand}',
                  getSubtitle: (vehicle) => 'Modelo: ${vehicle.model}',
                  onEdit: (vehicle) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editVehicle,
                      arguments: vehicle,
                    );
                  },
                  onDelete: (vehicle) async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text('Confirmação'),
                          ),
                          content: const Text(
                              'Tem certeza que deseja deletar este veículo?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Não'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Sim'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmDelete == true) {
                      state.delete(vehicle);
                    }
                  },
                  onTap: (vehicle) {
                    Provider.of<VehicleController>(context, listen: false)
                        .populateVehicleInformation(vehicle);

                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailsVehicle,
                      arguments: vehicle,
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

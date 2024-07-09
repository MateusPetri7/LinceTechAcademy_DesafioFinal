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
            child: FutureBuilder(
              future:
                  Provider.of<VehicleController>(context, listen: false).load(),
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
                                    print(vehicle.photosTheVehicle!.first
                                        .toString());
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.editVehicle,
                                      arguments: vehicle,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirmDelete =
                                        await showDialog<bool>(
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: const Text('Não'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
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
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

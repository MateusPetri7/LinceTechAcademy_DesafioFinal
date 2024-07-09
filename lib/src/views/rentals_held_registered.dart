import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/rentals_held_controller.dart';

class RegisteredRentalsHeld extends StatelessWidget {
  const RegisteredRentalsHeld({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Provider.of<RentalsHeldController>(context, listen: false)
                  .load(),
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
                  return Consumer<RentalsHeldController>(
                    builder: (context, state, _) {
                      if (state.listRentalsHeld.isEmpty) {
                        return const Center(
                          child: Text('Nenhum aluguel encontrado'),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.listRentalsHeld.length,
                        itemBuilder: (context, index) {
                          final rentals = state.listRentalsHeld[index];
                          return ListTile(
                            title: Text('Cliente: ${rentals.clientId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Valor total: ${rentals.totalAmountPayable}'),
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
                                      AppRoutes.editRentals,
                                      arguments: rentals,
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
                                              'Tem certeza que deseja deletar este aluguel?'),
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
                                      state.delete(rentals);
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

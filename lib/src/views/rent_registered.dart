import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/rent_controller.dart';
import '../widgets/base_scaffold_floating_button.dart';
import '../widgets/custom_list_view.dart';

class RegisteredRent extends StatelessWidget {
  const RegisteredRent({Key? key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFloatingButton(
      title: 'Aluguéis',
      buttonText: 'Novo Aluguel',
      buttonRoute: AppRoutes.registerRent,
      body: FutureBuilder(
        future: Provider.of<RentController>(context, listen: false).load(),
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
            return Consumer<RentController>(
              builder: (context, state, _) {
                if (state.listRent.isEmpty) {
                  return const Center(
                    child: Text('Nenhum aluguel encontrado'),
                  );
                }
                return CustomListView(
                  items: state.listRent,
                  getTitle: (rent) => 'Cliente: ${rent.clientId}',
                  getSubtitle: (rent) =>
                  'Valor total: ${rent.totalAmountPayable!.toStringAsFixed(2)}',
                  onEdit: (rent) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editRent,
                      arguments: rent,
                    );
                  },
                  onDelete: (rent) async {
                    final confirmDelete = await showDialog<bool>(
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
                      state.delete(rent);
                    }
                  },
                  onTap: (rent) async {
                    await Provider.of<RentController>(context, listen: false)
                        .populateRentInformation(rent);

                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailsRent,
                      arguments: rent,
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

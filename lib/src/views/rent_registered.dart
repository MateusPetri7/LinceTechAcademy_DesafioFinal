import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/rent_controller.dart';
import '../widgets/base_scaffold_floating_button.dart';

class RegisteredRent extends StatelessWidget {
  const RegisteredRent({Key? key});

  Future<String> _getClientName(BuildContext context, String clientId) async {
    return await Provider.of<RentController>(context, listen: false)
            .getNameClientFromId(clientId) ??
        'Cliente Desconhecido';
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFloatingButton(
      title: AppLocalizations.of(context)!.rents,
      buttonText: AppLocalizations.of(context)!.newRent,
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
                return ListView.builder(
                  itemCount: state.listRent.length,
                  itemBuilder: (context, index) {
                    final rent = state.listRent[index];
                    return FutureBuilder(
                      future: _getClientName(context, rent.clientId!),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Carregando...'),
                            subtitle: Text(
                                'Valor total: ${rent.totalAmountPayable!.toStringAsFixed(2)}'),
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text('Erro ao carregar nome do cliente'),
                            subtitle: Text(
                                'Valor total: ${rent.totalAmountPayable!.toStringAsFixed(2)}'),
                          );
                        } else {
                          return Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            child: ListTile(
                              title: Text('Cliente: ${snapshot.data}'),
                              subtitle: Text(
                                  'Valor total: ${rent.totalAmountPayable!.toStringAsFixed(2)}'),
                              onTap: () async {
                                await Provider.of<RentController>(context,
                                        listen: false)
                                    .populateRentInformation(rent);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.detailsRent,
                                  arguments: rent,
                                );
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.editRent,
                                        arguments: rent,
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
                                        state.delete(rent);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
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

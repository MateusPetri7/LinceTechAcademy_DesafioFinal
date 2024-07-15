import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/client_controller.dart';
import '../widgets/base_scaffold_floating_button.dart';
import '../widgets/custom_list_view.dart';

class RegisteredClients extends StatelessWidget {
  const RegisteredClients({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFloatingButton(
      title: AppLocalizations.of(context)!.clients,
      buttonText: AppLocalizations.of(context)!.newClient,
      buttonRoute: AppRoutes.registerClient,
      body: FutureBuilder(
        future: Provider.of<ClientController>(context, listen: false).load(),
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
            return Consumer<ClientController>(
              builder: (context, state, _) {
                return CustomListView(
                  items: state.listClient,
                  getTitle: (client) => 'Nome: ${client.name}',
                  getSubtitle: (client) => 'CNPJ: ${client.companyRegistrationNumber}',
                  onEdit: (client) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editClient,
                      arguments: client,
                    );
                  },
                  onDelete: (client) async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text('Confirmação'),
                          ),
                          content: const Text('Tem certeza que deseja deletar este cliente?'),
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
                      await state.delete(client);
                    }
                  },
                  onTap: (client) async {
                    await Provider.of<ClientController>(context, listen: false)
                        .populateClientInformation(client);

                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailsClient,
                      arguments: client,
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

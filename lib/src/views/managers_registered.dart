import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/manager_controller.dart';
import '../widgets/base_scaffold_floating_button.dart';
import '../widgets/custom_list_view.dart';

class RegisteredManagers extends StatelessWidget {
  const RegisteredManagers({Key? key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFloatingButton(
      title: AppLocalizations.of(context)!.managers,
      buttonText: AppLocalizations.of(context)!.newManager,
      buttonRoute: AppRoutes.registerManager,
      body: FutureBuilder(
        future: Provider.of<ManagerController>(context, listen: false).load(),
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
            return Consumer<ManagerController>(
              builder: (context, state, _) {
                if (state.listManager.isEmpty) {
                  return const Center(
                    child: Text('Nenhum gerente encontrado'),
                  );
                }
                return CustomListView(
                  items: state.listManager,
                  getTitle: (manager) => 'Nome: ${manager.name}',
                  getSubtitle: (manager) => 'CPF: ${manager.individualTaxpayerRegistry}',
                  onEdit: (manager) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editManager,
                      arguments: manager,
                    );
                  },
                  onDelete: (manager) async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text('Confirmação'),
                          ),
                          content: const Text('Tem certeza que deseja deletar este gerente?'),
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
                      state.delete(manager);
                    }
                  },
                  onTap: (manager) {
                    Provider.of<ManagerController>(context, listen: false)
                        .populateManagerInformation(manager);

                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailsManager,
                      arguments: manager,
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

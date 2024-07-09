import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/manager_controller.dart';

class RegisteredManagers extends StatelessWidget {
  const RegisteredManagers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future:
                  Provider.of<ManagerController>(context, listen: false).load(),
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
                      return ListView.builder(
                        itemCount: state.listManager.length,
                        itemBuilder: (context, index) {
                          final manager = state.listManager[index];
                          return ListTile(
                            title: Text('Nome: ${manager.name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'CPF: ${manager.individualTaxpayerRegistry}'),
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
                                      AppRoutes.editManager,
                                      arguments: manager,
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
                                              'Tem certeza que deseja deletar este gerente?'),
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
                                      state.delete(manager);
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

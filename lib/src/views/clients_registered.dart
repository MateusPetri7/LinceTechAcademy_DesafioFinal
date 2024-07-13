import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/client_controller.dart';
import '../widgets/base_scaffold.dart';

class RegisteredClients extends StatelessWidget {
  const RegisteredClients({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Clientes',
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future:
                  Provider.of<ClientController>(context, listen: false).load(),
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
                      if (state.listClient.isEmpty) {
                        return const Center(
                          child: Text('Nenhum cliente encontrado'),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.listClient.length,
                        itemBuilder: (context, index) {
                          final client = state.listClient[index];
                          return ListTile(
                            title: Text('Nome: ${client.name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'CNPJ: ${client.companyRegistrationNumber}'),
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
                                      AppRoutes.editClient,
                                      arguments: client,
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
                                              'Tem certeza que deseja deletar este cliente?'),
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
                                      state.delete(client);
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

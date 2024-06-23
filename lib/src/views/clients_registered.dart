import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/client_controller.dart';
import 'client_edit.dart';

class RegisteredClients extends StatelessWidget {
  const RegisteredClients({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<ClientController>(builder: (context, state, _) {
              return ListView.builder(
                itemCount: state.listClient.length,
                itemBuilder: (context, index) {
                  final client = state.listClient[index];
                  return ListTile(
                    title: Text('Nome: ${client.name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CNPJ: ${client.companyRegistrationNumber}'),
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
                          onPressed: () {
                            state.delete(client);
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

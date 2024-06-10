import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/controllers/client_controller.dart';
import 'package:provider/provider.dart';

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
                  print(client.name);
                  return ListTile(
                    title: Text('Nome: ${client.name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CNPJ: ${client.tin}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/manager_controller.dart';
import 'manager_edit.dart';

class RegisteredManagers extends StatelessWidget {
  const RegisteredManagers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<ManagerController>(builder: (context, state, _) {
              return ListView.builder(
                itemCount: state.listManager.length,
                itemBuilder: (context, index) {
                  final manager = state.listManager[index];
                  return ListTile(
                    title: Text('Nome: ${manager.name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CPF: ${manager.individualTaxpayerRegistry}'),
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
                          onPressed: () {
                            state.delete(manager);
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

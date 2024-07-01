import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/rentals_held_controller.dart';
import 'manager_edit.dart';

class RegisteredRentalsHeld extends StatelessWidget {
  const RegisteredRentalsHeld({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<RentalsHeldController>(builder: (context, state, _) {
              return ListView.builder(
                itemCount: state.listRentalsHeld.length,
                itemBuilder: (context, index) {
                  final rentals = state.listRentalsHeld[index];
                  return ListTile(
                    title: Text('Cliente: ${rentals.clientId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Valor total: ${rentals.totalAmountPayable}'),
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
                          onPressed: () {
                            state.delete(rentals);
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

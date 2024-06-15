import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/manager_controller.dart';

class RegisterManager extends StatelessWidget {
  const RegisterManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ManagerController>(
          builder: (context, state, _) {
            return Form(
              key: state.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: state.nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório.';
                      }
                      if (value.length < 3) {
                        return 'Nome precisa ter pelo menos 3 letras.';
                      }
                      if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                        return 'Nome precisa começar com letra maiúscula.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.telephoneController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      hintText: '(XX) XXXXX-XXXX',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telefone é obrigatório.';
                      }
                      if (value.length < 10) {
                        return 'Número inválido.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.individualTaxpayerRegistryController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CPF é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.stateController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estado é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.commissionPercentageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Porcetagem de Comissão",
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Porcetagem de Comissão obrigatória.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (state.formKey.currentState!.validate()) {
                        await state.insert();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Cadastrar'),
                    style: ElevatedButton.styleFrom(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

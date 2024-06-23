import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/manager_controller.dart';
import '../models/manager_model.dart';

class EditManager extends StatelessWidget {
  final ManagerModel manager;

  const EditManager({super.key, required this.manager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ManagerController>(
          builder: (context, state, _) {
            state.populateManagerInformation(manager);
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
                  DropdownButton<String>(
                    value: state.selectedState,
                    hint: const Text('Selecione o estado'),
                    items: state.states
                        .map<DropdownMenuItem<String>>((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      state.selectedState = value;
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
                        await state.update();
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Alterar dados'),
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

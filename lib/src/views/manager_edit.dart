import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/manager_controller.dart';
import '../models/manager_model.dart';

class EditManager extends StatefulWidget {
  final ManagerModel manager;

  const EditManager({super.key, required this.manager});

  @override
  _EditManagerState createState() => _EditManagerState();
}

class _EditManagerState extends State<EditManager> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<ManagerController>(context, listen: false);
      state.populateManagerInformation(widget.manager);
    });
  }

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
                    decoration: const InputDecoration(
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
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
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
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                    ),
                  ),
                  DropdownButtonFormField<String>(
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
                      print('Selected state: $value'); // Log for debugging
                      state.selectedState = value;
                    },
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
                      labelText: "Porcentagem de Comissão",
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Porcentagem de Comissão obrigatória.";
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

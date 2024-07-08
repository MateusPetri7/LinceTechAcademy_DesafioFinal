import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/client_controller.dart';
import '../models/client_model.dart';
import '../models/manager_model.dart';

class EditClient extends StatelessWidget {
  final ClientModel client;

  const EditClient({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<void>(
          future: Provider.of<ClientController>(context, listen: false)
              .populateClientInformation(client),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Ocorreu um erro'),
              );
            } else {
              return Consumer<ClientController>(
                builder: (context, state, _) {
                  return Form(
                    key: state.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: state.companyRegistrationNumberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'CNPJ',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                String? cnpj = state
                                    .companyRegistrationNumberController.text
                                    .replaceAll(RegExp(r'\D'), '');
                                if (cnpj.isNotEmpty) {
                                  await state.getClientData(cnpj);
                                  state.populateClientInformationAtRegistration(
                                      state.clientCurrent);
                                }
                              },
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CnpjInputFormatter(),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CNPJ é obrigatório.';
                            }
                            if (!CNPJValidator.isValid(value)) {
                              return 'CNPJ inválido.';
                            }
                            return null;
                          },
                        ),
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
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: state.telephoneController,
                          keyboardType: TextInputType.phone,
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
                          controller: state.cityController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Cidade',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cidade é obrigatório.';
                            }
                            return null;
                          },
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
                            state.selectedState = value;
                            state.getManagersFromState(state.selectedState!);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Estado é obrigatório.';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<ManagerModel>(
                          value: state.selectedManager,
                          hint: const Text('Selecione o gerente'),
                          items: state.listManager
                              .map<DropdownMenuItem<ManagerModel>>(
                                  (final manager) {
                                return DropdownMenuItem<ManagerModel>(
                                  value: manager,
                                  child: Text(manager.name!),
                                );
                              }).toList(),
                          onChanged: (final value) {
                            if (value != null) {
                              state.selectedManager = value;
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Gerente é obrigatório.';
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
              );
            }
          },
        ),
      ),
    );
  }
}

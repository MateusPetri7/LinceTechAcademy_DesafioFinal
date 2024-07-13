import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../controllers/client_controller.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../widgets/custom_style_button.dart';
import '../widgets/custom_text_form_field.dart';

class RegisterClient extends StatelessWidget {
  const RegisterClient({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Cadastro de Clientes',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<ClientController>(
          builder: (context, state, _) {
            return Form(
              key: state.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'CNPJ',
                            icon: Icons.business,
                            controller:
                                state.companyRegistrationNumberController,
                            keyboardType: TextInputType.number,
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
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                String? cnpj = state
                                    .companyRegistrationNumberController.text
                                    .replaceAll(RegExp(r'\D'), '');
                                if (cnpj.isNotEmpty) {
                                  try {
                                    await state.getClientData(cnpj);
                                    await state
                                        .populateClientInformationAtRegistration(
                                            state.clientCurrent);
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Erro'),
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'Nome',
                            icon: Icons.person,
                            controller: state.nameController,
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
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'Telefone',
                            icon: Icons.phone,
                            controller: state.telephoneController,
                            keyboardType: TextInputType.phone,
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
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'Cidade',
                            icon: Icons.location_city,
                            controller: state.cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cidade é obrigatório.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: CustomDropdownButtonFormField(
                            labelText: 'Estado',
                            icon: Icons.location_on,
                            items: state.states,
                            value: state.selectedState,
                            onChanged: (value) {
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
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: CustomDropdownButtonFormField(
                            labelText: 'Gerente',
                            icon: Icons.person,
                            items: state.listManager
                                .map((manager) => manager.name!)
                                .toList(),
                            value: state.selectedManager?.name,
                            onChanged: (value) {
                              if (value != null) {
                                state.selectedManager = state.listManager
                                    .firstWhere(
                                        (manager) => manager.name == value);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Gerente é obrigatório.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  CustomStyledButton(
                    onPressed: () async {
                      if (state.formKey.currentState!.validate()) {
                        await state.insert();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: 'Registrar Cliente',
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

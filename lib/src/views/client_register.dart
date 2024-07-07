import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../controllers/client_controller.dart';

class RegisterClient extends StatelessWidget {
  const RegisterClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ClientController>(
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
                            await state.populateClientInformationAtRegistration(
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
                      state.getManagerFromState(state.selectedState!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estado é obrigatório.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.managerController,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Gerente',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Gerente é obrigatório.';
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
                    label: Text(AppLocalizations.of(context)!.helloWorld),
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

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
      title: AppLocalizations.of(context)!.clientRegister,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<ClientController>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Form(
                key: state.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: AppLocalizations.of(context)!
                          .companyRegistrationNumber,
                      icon: Icons.business,
                      controller: state.companyRegistrationNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CnpjInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .companyRegistrationNumberRequired;
                        }
                        if (!CNPJValidator.isValid(value)) {
                          return AppLocalizations.of(context)!
                              .companyRegistrationNumberInvalid;
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          if (state.companyRegistrationNumberController.text
                              .isNotEmpty) {
                            try {
                              await state.getClientData(
                                  state.companyRegistrationNumberController);
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
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: AppLocalizations.of(context)!.name,
                      icon: Icons.person,
                      controller: state.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.nameRequired;
                        }
                        if (value.length < 3) {
                          return AppLocalizations.of(context)!.incompleteName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: AppLocalizations.of(context)!.telephone,
                      icon: Icons.phone,
                      controller: state.telephoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .telephoneRequired;
                        }
                        if (value.length < 10) {
                          return AppLocalizations.of(context)!
                              .invalidPhoneNumber;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextFormField(
                      labelText: AppLocalizations.of(context)!.city,
                      icon: Icons.location_city,
                      controller: state.cityController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.cityRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomDropdownButtonFormField(
                      labelText: AppLocalizations.of(context)!.state,
                      icon: Icons.location_on,
                      items: state.states,
                      value: state.selectedState,
                      onChanged: (value) {
                        state.selectedState = value;
                        state.getManagersFromState(state.selectedState!);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.stateRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomDropdownButtonFormField(
                      labelText: AppLocalizations.of(context)!.manager,
                      icon: Icons.person,
                      items: state.listManager
                          .map((manager) => manager.name!)
                          .toList(),
                      value: state.selectedManager?.name,
                      onChanged: (value) {
                        if (value != null) {
                          state.selectedManager = state.listManager
                              .firstWhere((manager) => manager.name == value);
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.managerRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomStyledButton(
                      onPressed: () async {
                        if (state.formKey.currentState!.validate()) {
                          await state.insert();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: AppLocalizations.of(context)!.registerClient,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

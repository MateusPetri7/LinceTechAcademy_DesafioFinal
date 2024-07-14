import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/manager_controller.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../widgets/custom_style_button.dart';
import '../widgets/custom_text_form_field.dart';

class ManagerFormFields extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onButtonPressed;
  final GlobalKey<FormState> formKey;

  const ManagerFormFields({
    Key? key,
    required this.buttonText,
    required this.buttonIcon,
    required this.onButtonPressed,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerController>(
      builder: (context, state, _) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'Nome',
                icon: Icons.person,
                controller: state.nameController,
                keyboardType: TextInputType.text,
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
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'Telefone',
                icon: Icons.phone,
                controller: state.telephoneController,
                keyboardType: TextInputType.text,
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
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'CPF',
                icon: Icons.badge,
                controller: state.individualTaxpayerRegistryController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CPF é obrigatório.';
                  }
                  if (!CPFValidator.isValid(value)) {
                    return 'CPF inválido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              CustomDropdownButtonFormField(
                labelText: 'Selecione o estado',
                icon: Icons.location_on,
                items: state.states,
                value: state.selectedState,
                onChanged: (value) {
                  state.selectedState = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Estado é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'Porcentagem de Comissão',
                icon: Icons.attach_money,
                controller: state.commissionPercentageController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Porcentagem de Comissão é obrigatória.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              CustomStyledButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await state.insert();
                  }
                },
                icon: const Icon(Icons.add),
                label: buttonText,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }
}

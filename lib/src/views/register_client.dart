import 'package:flutter/material.dart';
import 'package:lincetechacademy_ss_automoveis_app/src/controllers/client_controller.dart';
import 'package:provider/provider.dart';

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
                      labelText: "Telefone",
                      hintText: '(XX) XXXXX-XXXX',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Telefone é obrigatório.";
                      }
                      if (value.length < 11) {
                        return "Número inválido.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.cityController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Cidade",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cidade é obrigatório.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.stateController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Estado",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Estado é obrigatório.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: state.tinController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "CNPJ",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "CNPJ é obrigatório.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await state.insert();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Cadastrar'),
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

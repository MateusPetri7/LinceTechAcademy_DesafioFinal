import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/client_controller.dart';
import '../models/client_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_text_form_field.dart';

class DetailsClient extends StatelessWidget {
  final ClientModel client;

  const DetailsClient({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ClientController>(context, listen: false);
    return BaseScaffold(
      title: 'Detalhes do Cliente',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<ClientController>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    labelText: 'CNPJ',
                    icon: Icons.business,
                    controller: TextEditingController(
                        text: client.companyRegistrationNumber),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Nome',
                    icon: Icons.person,
                    controller: TextEditingController(text: client.name),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Telefone',
                    icon: Icons.phone,
                    controller: TextEditingController(text: client.telephone),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Cidade',
                    icon: Icons.location_city,
                    controller: TextEditingController(text: client.city),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Estado',
                    icon: Icons.location_on,
                    controller: TextEditingController(text: client.state),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextFormField(
                    labelText: 'Gerente',
                    icon: Icons.person,
                    controller: TextEditingController(
                        text: state.selectedManager?.name ?? ''),
                    readOnly: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      onIconPressed: (index) {
        state.clearControllers();
        switch (index) {
          case 0:
            Navigator.pop(context);
            break;
          case 1:
            Navigator.pushNamed(context, AppRoutes.home);
            break;
        }
      },
    );
  }
}

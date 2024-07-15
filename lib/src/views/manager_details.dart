import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/manager_controller.dart';
import '../models/manager_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/custom_text_form_field.dart';

class DetailsManager extends StatelessWidget {
  final ManagerModel manager;

  const DetailsManager({Key? key, required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ManagerController>(context, listen: false);

    return BaseScaffold(
      title: AppLocalizations.of(context)!.dataManager,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                labelText: 'Nome',
                icon: Icons.person,
                controller: TextEditingController(text: manager.name),
                readOnly: true,
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'Telefone',
                icon: Icons.phone,
                controller: TextEditingController(text: manager.telephone),
                readOnly: true,
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'CPF',
                icon: Icons.person_outline,
                controller: TextEditingController(
                    text: manager.individualTaxpayerRegistry),
                readOnly: true,
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'Estado',
                icon: Icons.location_on,
                controller: TextEditingController(text: manager.state),
                readOnly: true,
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                labelText: 'Porcentagem de Comissão',
                icon: Icons.attach_money,
                controller: TextEditingController(
                    text: manager.commissionPercentage.toString()),
                readOnly: true,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/client_controller.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/client_form_fields.dart';

class RegisterClient extends StatelessWidget {
  const RegisterClient({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = context.read<ClientController>().generateFormKey();
    final state = Provider.of<ClientController>(context, listen: false);

    return BaseScaffold(
      title: AppLocalizations.of(context)!.clientRegister,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ClientFormFields(
            formKey: formKey,
            buttonText: AppLocalizations.of(context)!.registerClient,
            buttonIcon: Icons.add,
            onButtonPressed: () async {
              if (formKey.currentState!.validate()) {
                await state.insert();
              }
            },
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

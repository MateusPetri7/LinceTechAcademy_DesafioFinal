import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/manager_controller.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/manager_form_field.dart';

class RegisterManager extends StatelessWidget {
  const RegisterManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = context.read<ManagerController>().generateFormKey();
    final state = Provider.of<ManagerController>(context, listen: false);

    return BaseScaffold(
      title: AppLocalizations.of(context)!.registerManager,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ManagerFormFields(
            formKey: formKey,
            buttonText: AppLocalizations.of(context)!.registerManager,
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

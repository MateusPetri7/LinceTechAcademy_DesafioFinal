import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/manager_controller.dart';
import '../models/manager_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/manager_form_field.dart';

class EditManager extends StatefulWidget {
  final ManagerModel manager;

  const EditManager({Key? key, required this.manager}) : super(key: key);

  @override
  _EditManagerState createState() => _EditManagerState();
}

class _EditManagerState extends State<EditManager> {
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = context.read<ManagerController>().generateFormKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<ManagerController>(context, listen: false);
      state.populateManagerInformation(widget.manager);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ManagerController>(context, listen: false);
    return BaseScaffold(
      title: AppLocalizations.of(context)!.clientEdit,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ManagerFormFields(
            formKey: formKey,
            buttonText: 'Alterar dados',
            buttonIcon: Icons.edit,
            onButtonPressed: () async {
              if (formKey.currentState!.validate()) {
                await state.update();
                Navigator.pop(context);
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../controllers/client_controller.dart';
import '../models/client_model.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/client_form_fields.dart';

class EditClient extends StatefulWidget {
  final ClientModel client;

  const EditClient({super.key, required this.client});

  @override
  _EditClientState createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = context.read<ClientController>().generateFormKey();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = Provider.of<ClientController>(context, listen: false);
      await state.populateClientInformation(widget.client);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ClientController>(context, listen: false);
    return BaseScaffold(
      title: AppLocalizations.of(context)!.clientEdit,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: ClientFormFields(
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

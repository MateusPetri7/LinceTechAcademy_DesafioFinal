// import 'package:brasil_fields/brasil_fields.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../controllers/rent_controller.dart';
// import '../models/client_model.dart';
// import '../models/rent_model.dart';
// import '../models/vehicle_model.dart';
//
// class EditRentalsHeld extends StatelessWidget {
//   final RentalsHeldModel rentals;
//
//   const EditRentalsHeld({super.key, required this.rentals});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: FutureBuilder<void>(
//           future: Provider.of<RentalsHeldController>(context, listen: false)
//               .populateRentalInformation(rentals),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return const Center(
//                 child: Text('Ocorreu um erro'),
//               );
//             } else {
//               return Consumer<RentalsHeldController>(
//                 builder: (context, state, _) {
//                   return Form(
//                     key: state.formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         DropdownButtonFormField<String>(
//                           value: rentalsState.selectedState,
//                           hint: const Text('Selecione o estado de locação'),
//                           items: rentalsState.states
//                               .map<DropdownMenuItem<String>>((String state) {
//                             return DropdownMenuItem<String>(
//                               value: state,
//                               child: Text(state),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) async {
//                             rentalsState.selectedState = value;
//                             if (value != null) {
//                               await rentalsState.loadVehicles(value);
//                             }
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Estado é obrigatório.';
//                             }
//                             return null;
//                           },
//                         ),
//                         DropdownButtonFormField<ClientModel>(
//                           value: state.selectedClient,
//                           hint: const Text('Selecione o cliente'),
//                           items: state.listClient
//                               .map<DropdownMenuItem<ClientModel>>(
//                                   (ClientModel client) {
//                             return DropdownMenuItem<ClientModel>(
//                               value: client,
//                               child: Text(client.name!),
//                             );
//                           }).toList(),
//                           onChanged: (ClientModel? value) {
//                             state.selectedClient = value;
//                           },
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Cliente é obrigatório.';
//                             }
//                             return null;
//                           },
//                         ),
//                         DropdownButtonFormField<VehicleModel>(
//                           value: state.selectedVehicle,
//                           hint: const Text('Selecione o veículo'),
//                           items: state.listVehicle
//                               .map<DropdownMenuItem<VehicleModel>>(
//                                   (VehicleModel vehicle) {
//                             return DropdownMenuItem<VehicleModel>(
//                               value: vehicle,
//                               child:
//                                   Text('${vehicle.brand!} - ${vehicle.model!}'),
//                             );
//                           }).toList(),
//                           onChanged: (VehicleModel? value) {
//                             state.selectedVehicle = value;
//                           },
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Veículo é obrigatório.';
//                             }
//                             return null;
//                           },
//                         ),
//                         TextFormField(
//                           controller: state.startDateController,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: 'Data de Início',
//                           ),
//                           onTap: () => state.selectDate(
//                               context, state.startDateController),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Data de Início é obrigatória.';
//                             }
//                             return null;
//                           },
//                         ),
//                         TextFormField(
//                           controller: state.endDateController,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: 'Data de Término',
//                           ),
//                           onTap: () => state.selectDate(
//                               context, state.endDateController),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Data de Término é obrigatória.';
//                             }
//                             return null;
//                           },
//                         ),
//                         TextFormField(
//                           controller: state.numberOfDaysController,
//                           keyboardType: TextInputType.number,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: 'Número de Dias',
//                           ),
//                         ),
//                         TextFormField(
//                           controller: state.totalAmountPayableController,
//                           keyboardType: TextInputType.number,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: 'Valor Total a Pagar',
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                         ElevatedButton.icon(
//                           onPressed: () async {
//                             if (state.formKey.currentState!.validate()) {
//                               await state.update();
//                             }
//                           },
//                           icon: const Icon(Icons.add),
//                           label: const Text('Alterar dados'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

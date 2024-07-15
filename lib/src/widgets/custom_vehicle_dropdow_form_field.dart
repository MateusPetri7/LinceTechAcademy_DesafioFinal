import 'package:flutter/material.dart';
import '../models/vehicle_brand_model.dart';
import '../models/vehicle_model_model.dart';

class CustomVehicleDropdownFormField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final List<dynamic> items;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final FormFieldValidator<dynamic>? validator;

  const CustomVehicleDropdownFormField({
    Key? key,
    required this.labelText,
    required this.icon,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FormField<dynamic>(
        builder: (FormFieldState<dynamic> state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.deepPurple,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Colors.deepPurple,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Colors.deepPurpleAccent,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              errorText: state.errorText,
            ),
            isEmpty: value == null || items.isEmpty,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                value: value,
                isDense: true,
                isExpanded: true,
                onChanged: (dynamic newValue) {
                  state.didChange(newValue);
                  if (onChanged != null) {
                    onChanged!(newValue);
                  }
                },
                items: items.map<DropdownMenuItem<dynamic>>((dynamic item) {
                  if (item is VehicleBrandModel) {
                    return DropdownMenuItem<dynamic>(
                      value: item,
                      child: Text(item.name),
                    );
                  } else if (item is VehicleModelModel) {
                    return DropdownMenuItem<dynamic>(
                      value: item,
                      child: Text(item.name),
                    );
                  }
                  return DropdownMenuItem<dynamic>(
                    value: item,
                    child: Text(item.toString()),
                  );
                }).toList(),
              ),
            ),
          );
        },
        validator: validator,
      ),
    );
  }
}

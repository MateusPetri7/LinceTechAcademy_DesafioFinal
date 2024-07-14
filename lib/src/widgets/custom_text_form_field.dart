import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool isCurrency; // Novo parâmetro para indicar se é um campo de moeda
  final VoidCallback? onTapCallback; // Callback para o evento onTap

  CustomTextFormField({
    required this.labelText,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.suffixIcon,
    this.readOnly = false,
    this.isCurrency = false, // Valor padrão: não é campo de moeda
    this.onTapCallback, // Adicione o parâmetro para o callback
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: isCurrency ? [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            final numValue = num.tryParse(newValue.text);
            if (numValue == null) return oldValue;
            final formattedValue = currencyFormatter.format(numValue / 100);
            return TextEditingValue(
              text: formattedValue,
              selection: TextSelection.collapsed(offset: formattedValue.length),
            );
          }),
        ] : inputFormatters,
        validator: validator,
        readOnly: readOnly,
        onTap: onTapCallback, // Atribua o callback ao evento onTap
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
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
            color: Colors.deepPurple[200],
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
        ),
        cursorColor: Colors.deepPurple,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

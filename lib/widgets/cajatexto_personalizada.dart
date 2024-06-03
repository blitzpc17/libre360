import 'package:flutter/material.dart';

class CajaTextoPersonalizada extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final IconData? icono, iconoPrefix;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  

  const CajaTextoPersonalizada(
      {super.key,
      this.label,
      this.hint,
      this.errorMessage,
      this.obscureText = false,
      this.onChanged,
      this.validator,
      this.icono,
      this.iconoPrefix,
      this.controller,
      this.textInputType
      });

  @override
  Widget build(BuildContext context) {
    //final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black45),
        borderRadius: BorderRadius.circular(10));

    return TextFormField(  
      keyboardType: textInputType??TextInputType.text,
      controller: controller,   
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      autocorrect: false,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.black45)),
        errorBorder:
            border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        focusedErrorBorder:
            border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        isDense: true,
        label: label != null ? Text(label!) : null,
        labelStyle: const TextStyle(
            color: Colors.black45, fontWeight: FontWeight.normal),
        hintText: hint,
        errorText: errorMessage,
        focusColor: Colors.black,
        suffixIcon: icono == null ? Container() : Icon(icono),        
        //prefix: iconoPrefix == null ? Container() : Icon(iconoPrefix)
      ),
    );
  }
}

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
  final Color? color;
  

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
      this.textInputType,
      this.color
      });

  @override
  Widget build(BuildContext context) {
    //final colors = Theme.of(context).colorScheme;


    final border = OutlineInputBorder(
        borderSide: BorderSide(color: color??Colors.black45),
        borderRadius: BorderRadius.circular(10));

    return TextFormField(  
      keyboardType: textInputType??TextInputType.text,
      controller: controller,   
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      autocorrect: false,
      style: TextStyle(color: color??Colors.black45),
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(color: color==null?Colors.black45:Colors.amber),
        hintStyle: TextStyle(color: color==null?Colors.grey:Colors.amber[100]),
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide: BorderSide(color: color == null?Colors.black45: Colors.amber)),
            hoverColor: color == null? Colors.black45:Colors.amber,            
        errorBorder:
            border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        focusedErrorBorder:
            border.copyWith(borderSide: BorderSide(color: Colors.red.shade800)),
        isDense: true,
        label: label != null ? Text(label!) : null,
        labelStyle: TextStyle(
            color: color??Colors.black45, fontWeight: FontWeight.normal),
        hintText: hint,
        errorText: errorMessage,
        focusColor: color==null?Colors.black:Colors.amber,
        suffixIcon: icono == null ? Container() : Icon(icono),      
        suffixIconColor: color==null?Colors.grey: Colors.amber 
        //prefix: iconoPrefix == null ? Container() : Icon(iconoPrefix)
      ),
    );
  }
}

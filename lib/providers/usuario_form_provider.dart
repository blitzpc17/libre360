import 'package:flutter/material.dart';

class UsuarioFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();


  bool isValidForm(){
    return formKey.currentState?.validate()??false;
  }

}
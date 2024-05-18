import 'package:flutter/material.dart';
import 'package:taxi_app/modelo/models.dart';

class SelectOptions extends ChangeNotifier{


  static final List<Option> ListaPerfiles = [
    Option(label: "Usuario", value: "U"),
    Option(label: "Conductor", value: "C")
  ];


}
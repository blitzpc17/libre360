import 'dart:convert';

import 'package:flutter/material.dart';
import '../modelo/models.dart';
import 'package:http/http.dart' as http;

class ViajeService extends ChangeNotifier{
  final String _baseUrl = 'prueba23-edf7e-default-rtdb.firebaseio.com';
  final List<Viaje>viajes = [];

  bool isLoading = true;

  ViajeService(){
    loadViajes();
  }

  Future<List<Viaje>> loadViajes()async{
    final url = Uri.https(_baseUrl, 'Viajes.json');
    final resp = await http.get(url);

    final Map<String, dynamic>viajesMap = json.decode(resp.body);
    viajesMap.forEach((key, value){
      final tempViaje = Viaje.fromMap(value);
      tempViaje.id = key;
      viajes.add(tempViaje);
    });

    //isLoading=false;
    notifyListeners();

    return viajes;
  }



}
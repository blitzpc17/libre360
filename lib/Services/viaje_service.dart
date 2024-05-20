import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../modelo/models.dart';
import 'package:http/http.dart' as http;

class ViajeService extends ChangeNotifier{
  final String _baseUrl = 'prueba23-edf7e-default-rtdb.firebaseio.com';
  final List<Viaje>viajes = [];
  final storage = new FlutterSecureStorage();

  bool isLoading = true;

  ViajeService(){
   // loadViajes();
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

  Future<Ruta?> obtenerRutaViaje() async {
    String? jsonRuta = await storage.read(key: 'ruta');
     if (jsonRuta != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonRuta);
      return Ruta.fromJson(jsonMap);
    }
    return null;
  }

Future<void>saveRutaViaje( Ruta data)async {
   String jsonRuta = json.encode(data.toJson());
  await storage.write(key: 'ruta', value: jsonRuta);
}




}
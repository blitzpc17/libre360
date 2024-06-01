import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../modelo/models.dart';
import 'package:http/http.dart' as http;

class ViajeService extends ChangeNotifier{
  final String _baseUrl = 'https://libre360-228bb-default-rtdb.firebaseio.com/';//'prueba23-edf7e-default-rtdb.firebaseio.com';
  final List<Viaje>viajes = [];
  final storage = FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = true;

  late Viaje viajeCurso;

  ViajeService(){
   // loadViajes();
  }

  Future<List<Viaje>> loadViajes()async{
    final url = Uri.https(_baseUrl, 'viajes.json');
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


  Future saveOrCreateUsuario(Viaje viaje, String? edo) async {
    isSaving = true;
    notifyListeners();

    if(viaje.id == null){
      await createViaje(viaje);
    }else{
      //update
    }

    isSaving = false;
    notifyListeners();
  }


  Future<String>createViaje(Viaje viaje) async{
    
        final tokenCrud = await storage.read(key: 'token');
        final url = Uri.https( _baseUrl, 'viajes.json',{
          'auth': tokenCrud
        });
        viaje.fechaSolicitud = DateTime.now().toString();
        viaje.estado="P";//PENDIENTE
        final resp = await http.post( url, body: viaje.toJson() );
        final decodedData = json.decode( resp.body );
        viaje.id = decodedData['name'];
        viajeCurso = viaje;
        await storage.write(key: 'viajecurso', value: viaje.toJson());
        return viaje.id!;
        //el viaje id se va a mandar en la notificacion para que cuando el chofer lo acepte se pegue ese id al hacer update.
  }


  //crear el de modificar para cambiar el estado del viaje y agregar a que chofer se le asigno, en folio ponerle el id del registro
  Future<bool>updateViaje(Viaje viaje) async {
  
   return false;
  }

  Future<Viaje?>ObtenerViaje(String id) async {

    final String? token = await storage.read(key: 'token');
    final url = Uri.https(_baseUrl, 'viajes/$id.json', {
      'auth':token
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Viaje.fromJson(response.body);  //jsonDecode(response.body);
    } else {
      print('Error getting record: ${response.statusCode}');
      return null;
    }
  }

  Future<LatLng> convertirStringToLatLng(String ubicacionStr) async {
  // Eliminar 'LatLng(' y ')'
  ubicacionStr = ubicacionStr.replaceAll('LatLng(', '').replaceAll(')', '');
  
  // Dividir la cadena en latitud y longitud
  List<String> latLngStr = ubicacionStr.split(', ');
  
  // Convertir a double
  double lat = double.parse(latLngStr[0]);
  double lng = double.parse(latLngStr[1]);
  
  // Crear y retornar instancia de LatLng
  return LatLng(lat, lng);
}

 




}
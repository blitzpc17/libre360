import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ruta {
  final LatLng? origen;
  final LatLng? destino;

  Ruta({this.origen, this.destino});

  // Método para convertir un mapa JSON a una instancia de Ruta
  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
      origen: json['origen'] != null
          ? LatLng(json['origen'][0], json['origen'][1])
          : null,
      destino: json['destino'] != null
          ? LatLng(json['destino'][0], json['destino'][1])
          : null,
    );
  }

  // Método para convertir una instancia de Ruta a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'origen': origen != null ? [origen!.latitude, origen!.longitude] : null,
      'destino': destino != null ? [destino!.latitude, destino!.longitude] : null,
    };
  }
}
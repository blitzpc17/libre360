import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/modelo/models.dart';
import 'package:taxi_app/screens/screens.dart';

class MapaScreen extends StatefulWidget {
  static String name = "mapa_screen";
  final bool origen;

  const MapaScreen({super.key, required this.origen});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  LatLng? _origenPosition;
  StreamSubscription<Position>? _positionStream;


  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(18.4624477, -97.3953397),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Obtener la ubicación actual al iniciar
  }

  Future<void> _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
         _currentPosition = LatLng(position.latitude, position.longitude);        
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ));
    }
  }
/*
  Future<void> _moveCameraToCurrentPosition() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ));
    }
  }*/

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final viajeService = Provider.of<ViajeService>(context); 

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (CameraPosition position) {
              setState(() {
                _currentPosition = position.target;
              });
            },
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              size: 50.0,
              color: Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.my_location),
            onPressed: () {
              _getCurrentLocation(); // Mover el mapa a la ubicación actual
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.check),
            onPressed: () async{
              if (_currentPosition != null) {
                // Realizar la acción deseada con la ubicación seleccionada
                print('Ubicación seleccionada: $_currentPosition');
                _origenPosition = _currentPosition;

                Ruta? coordenadas = await viajeService.obtenerRutaViaje();

                Ruta? coordenadasAux = Ruta(origen: widget.origen?_origenPosition:coordenadas?.origen, destino: !widget.origen?_origenPosition:coordenadas?.destino);

            
                 viajeService.saveRutaViaje( coordenadasAux);

                context.pushNamed(
                  SolicitarViajeScreen.name,
                //  extra: {'posicion': _origenPosition, 'origen':widget.origen}
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapaScreen extends StatefulWidget {
  static String name = "mapa_screen";
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  final LatLng _posicionInicial = LatLng(18.4624477, -97.3953397);

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(18.4624477, -97.3953397), // Cambiar por la ubicación del usuario
    zoom: 14,
  );

  final List<Marker> myMarker = [];
  final List<Marker> markerList = [
    const Marker(
      markerId: MarkerId('First'),
      position: LatLng(18.4624477, -97.3953397),
      infoWindow: InfoWindow(title: "Parque Juarez"),
    ),
    const Marker(
      markerId: MarkerId('Second'),
      position: LatLng(18.4658727, -97.3985141),
      infoWindow: InfoWindow(title: "SSA"),
    ),
  ];

  @override
  void initState() {
    super.initState();
    myMarker.addAll(markerList);
    _getCurrentLocation(); // Obtener la ubicación actual al iniciar
  }

  Future<void> _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {});
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: () async {
          if (_currentPosition != null) {
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 14,
              ),
            ));
            setState(() {});
          }
        },
      ),
    );
  }
}

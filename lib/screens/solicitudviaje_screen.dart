import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/modelo/models.dart';
import 'package:taxi_app/screens/screens.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SolicitarViajeScreen extends StatefulWidget {
  
  static String name = "solicitudviaje_screen";

  const SolicitarViajeScreen({super.key});

  @override
  State<SolicitarViajeScreen> createState() => _SolicitarViajeScreenState();
}

class _SolicitarViajeScreenState extends State<SolicitarViajeScreen> {
  
  var editando = false;
  var viajeEncontrado = false;
  late Size _pantalla;
  LatLng? initialLocation;
  LatLng? finalLocation;
  final Completer<GoogleMapController> _controller = Completer();
  String? nombreorigen = "Seleccione el lugar de origen.";
  String? nombreDestino = "Seleccione el lugar de destino.";
  LatLng? _currentPosition;
  final String _apiKey = "AIzaSyB_z4OF-_0p0T3GNJtaakJiljud-8cCHMM";
  double? _tarifa;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(18.4624477, -97.3953397),
    zoom: 14,
  );

  List<String> images = [
    'assets/origen.png',
    'assets/llegada.png'
  ];

  final List<Marker> myMarkers = [];

   Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

      _getCurrentLocation(); 

      WidgetsBinding.instance.addPostFrameCallback((_) async {

      Ruta? ruta = await Provider.of<ViajeService>(context, listen: false).obtenerRutaViaje();

        if(ruta!=null){
          initialLocation = ruta.origen;
          finalLocation = ruta.destino;
        }       

        if(initialLocation!=null ){
          _getAddressFromLatLng(LatLng(initialLocation!.latitude, initialLocation!.longitude), true );
        }

         if(finalLocation!=null ){
          _getAddressFromLatLng(LatLng(finalLocation!.latitude, finalLocation!.longitude), false );
        }

        if(initialLocation!=null && finalLocation!=null){
          _TrazarRuta(initialLocation as LatLng, finalLocation as LatLng);
        }

    });

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

  Future<void> _setPolyline(LatLng origen, LatLng destino) async{

    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origen.latitude},${origen.longitude}&destination=${destino.latitude},${destino.longitude}&key=${_apiKey}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      List<LatLng> polylineCoordinates = _decodePolyline(points);
      await _calcularTarifa(origen, destino);

       setState(() {
        polylines.add(Polyline(
          polylineId: const PolylineId('Ruta del viaje'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        )); 

        print(_tarifa);       
       });
      
    } else {
      throw Exception('Failed to load directions');
    } 
    
  }

   Future<void>_calcularTarifa(LatLng origen, LatLng destino)async {
    final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${origen.latitude},${origen.longitude}',
      'destination': '${destino.latitude},${destino.longitude}',
      'key': _apiKey,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      double _distancia;
      final decodedResponse = json.decode(response.body);
      final distancia = decodedResponse['routes'][0]['legs'][0]['distance']['value'];
      _distancia =  distancia.toDouble() / 1000; // Convertir a kilómetros
      const double precioBase = 60.00;
      
      if(_distancia>1){
        final double calculoKmExtra = (_distancia - 1) * 14.00;
        _tarifa = calculoKmExtra + precioBase;
      }else{
        _tarifa = precioBase;
      }

    } else {
      throw Exception('Error al calcular la distancia');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }

  Future<Uint8List> getImagesFromMarkers(String path, int width) async {
    print(path);
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);

    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _TrazarRuta(LatLng origen, LatLng destino) async{

    final Uint8List iconMarkerOrigen =  await  getImagesFromMarkers(images[0], 90);
    final Uint8List iconMarkerDestino =  await  getImagesFromMarkers(images[1], 90);

    myMarkers.add(
      Marker(
        markerId: const MarkerId("origen"),
        position: origen,
        icon: BitmapDescriptor.fromBytes(iconMarkerOrigen),
        infoWindow: const InfoWindow(
          title: "¡Te encuentras aquí!"
        )
      )
    );

     myMarkers.add(
      Marker(
        markerId: const MarkerId("destino"),
        position: destino,
        icon: BitmapDescriptor.fromBytes(iconMarkerDestino),
        infoWindow: const InfoWindow(
          title: "¡Tu destino!"
        )
      )
    );

    _setPolyline(origen, destino);

  }

  Future<void> _getAddressFromLatLng(LatLng position, bool origen) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        if(origen){
          nombreorigen =
            "${place.street}, ${place.postalCode}, ${place.locality}";
        }else{
          nombreDestino =
            "${place.street}, ${place.postalCode}, ${place.locality}";
        }
       
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _pantalla = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Colors.black, Colors.black38]),
            ),
          ),
        ),
        drawer: const Menulateral(),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(myMarkers),
              polylines: polylines,
            ),
            SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.10,
                      child: const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "Solicitar Viaje",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.0005,
                      color: Colors.black54,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: viajeEncontrado ? 10 : 5),
                      width: constraints.maxWidth,
                      height: viajeEncontrado
                          ? ((constraints.maxHeight * 0.80) +
                              constraints.maxHeight * 0.098)
                          : constraints.maxHeight * 0.80,
                      child: LayoutBuilder(builder: (context, constraints5) {
                        return Stack(children: [
                          SizedBox(
                            width: constraints.maxWidth,
                            height: constraints5.maxHeight,
                          ),
                          SizedBox(
                            width: constraints5.maxWidth,
                            height: constraints5.maxHeight * 0.25,
                            child: LayoutBuilder(
                                builder: (context, constraints11) {
                              return Column(
                                children: [
                                  BotonPersonalizado(
                                      ancho: constraints11.maxWidth,
                                      alto: constraints11.maxHeight * 0.35,
                                      color: Colors.black,
                                      altoIconos: 0.50,
                                      anchoIconos: 0.10,
                                      deshabFondoIconos: true,
                                      colorIconos: Colors.grey,
                                      icono: FontAwesomeIcons.locationDot,
                                      texto:
                                          nombreorigen, //"Selecciona dirección de origen",
                                      iconoAux:
                                          FontAwesomeIcons.shareFromSquare,
                                      onChanged: () async {
                                        await context.pushNamed(
                                            SeleccionUbicacionScreen.name,
                                            extra: {"textoTitulo":"Indicanos tu ubicación de partida.", 'origen':true});
                                      }),
                                  SizedBox(
                                    height: constraints11.maxHeight * 0.05,
                                  ),
                                  BotonPersonalizado(
                                      ancho: constraints11.maxWidth,
                                      alto: constraints11.maxHeight * 0.35,
                                      color: Colors.black,
                                      altoIconos: 0.50,
                                      anchoIconos: 0.10,
                                      colorIconos: Colors.grey,
                                      deshabFondoIconos: true,
                                      icono: FontAwesomeIcons.flag,
                                      iconoAux:
                                          FontAwesomeIcons.shareFromSquare,
                                      texto:
                                          nombreDestino,
                                      onChanged: ()async {
                                         await context.pushNamed(
                                            SeleccionUbicacionScreen.name,
                                            extra: {"textoTitulo":"Indicanos tu ubicación de destino.", 'origen':false});       
                                      })
                                ],
                              );
                            }),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: constraints5.maxWidth * 0.75,
                              height: constraints5.maxHeight * 0.18,
                              child: viajeEncontrado
                                  ? _TarjetaChoferAsignado(
                                      ancho: constraints5.maxWidth * 0.60,
                                      alto: constraints5.maxHeight * 0.32)
                                  : _TarjetaTipoViaje(
                                     costo:  (_tarifa ?? 0).toStringAsFixed(2),
                                      ancho: constraints5.maxWidth * 0.60,
                                      alto: constraints5.maxHeight * 0.25),
                            ),
                          )
                        ]);
                      }),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        width: constraints.maxWidth,
                        height: viajeEncontrado
                            ? constraints.maxHeight * 0
                            : constraints.maxHeight * 0.098,
                        child: LayoutBuilder(
                          builder: (context, constraints12) {
                            return BotonPersonalizado(
                                ancho: constraints12.maxWidth * 0.10,
                                alto: constraints12.maxHeight * 0.35,
                                color: Colors.black,
                                icono: FontAwesomeIcons.circleCheck,
                                texto: "Solicitar viaje",
                                onChanged: () async {
                                  if(initialLocation==null || finalLocation==null ){
                                      NotificationsService.showSnackbar("No ha terminado de seleccionar la ruta.", Colors.amber, Icons.warning);
                                    return;
                                  }
                                  //crear viaje
                                  Viaje objViaje = Viaje(
                                    claveUsuarioConfirmo: "", 
                                    estado: "", 
                                    fechaSolicitud: "", 
                                    folio: "", 
                                    precio: _tarifa!.toStringAsFixed(2), 
                                    ubicacionOrigen: initialLocation.toString(), 
                                    ubicacionDestino: finalLocation.toString());

                                  await Provider.of<ViajeService>(context, listen: false).createViaje(objViaje);
                                  //mandar notificacion de momento se va a anclar ek primer chofer que este libre ordenado por orden
                                  //agregar campos orden y en estado se va a amplear

                                  await _mostrarAlertaBuscandoChofer();
                                   // await _mostrarAlertaCalificarViaje();
                                });
                               
                        },
                        ))
                  ],
                );
              }),
            )
          ],
        ),
      
      ),
    );
  }

  _mostrarAlertaBuscandoChofer() async {
    return await showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            width: _pantalla.width,
            height: _pantalla.height * 0.18,
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(10)),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.black, Colors.black38])),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.40,
                    child: const Center(
                      child: Text(
                        "Estamos buscando un chofer para emprender tu viaje...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.25,
                    height: constraints.maxHeight * 0.60,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  _mostrarAlertaCalificarViaje() async {
    return await showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            width: _pantalla.width,
            height: _pantalla.height * 0.25,
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(10)),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.black, Colors.black38])),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.40,
                    child: const Center(
                      child: Text(
                        "Califica el viaje realizado",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.40,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.25,
                    height: constraints.maxHeight * 0.60,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }
}

class _TarjetaTipoViaje extends StatelessWidget {
  final double ancho;
  final double alto;
  final String costo;

  const _TarjetaTipoViaje({required this.ancho, required this.alto, required this.costo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      height: alto,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
        
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                    child: CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      AssetImage("assets/imgbackgrounds/bg_solicitarviaje.png"),
                )),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                        child: Text(
                          "Viaje Estándar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "\$ ${costo}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaChoferAsignado extends StatelessWidget {
  final double ancho;
  final double alto;
  const _TarjetaChoferAsignado(
      {super.key, required this.ancho, required this.alto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      height: alto,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[Colors.black, Colors.black38],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.25,
                child: Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.20,
                      height: constraints.maxHeight,
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/driver.png'),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.05,
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.55,
                      height: constraints.maxHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Tu chofer",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                          Text(
                            "Nombre del Chofer",
                            style: TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.05,
              ),
              SizedBox(
                width: constraints.maxWidth * 0.75,
                height: constraints.maxHeight * 0.25,
                child: const Center(
                  child: Text(
                    "El chofer asignado llegará en breve.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TipoViajeBoton extends StatelessWidget {
  final String texto;
  final IconData icono;
  const TipoViajeBoton(
      {super.key, required this.texto, required this.icono});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Icon(icono, color: Colors.black, size: 30),
        ),
        const SizedBox(height: 5),
        Text(
          texto,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    );
  }
}

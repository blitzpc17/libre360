import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/modelo/models.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeChoferScreen extends StatefulWidget {

  static String name = 'home_chofer_screen';
  final Map<String,dynamic>? data;
  
  const HomeChoferScreen({super.key, this.data});

  @override
  State<HomeChoferScreen> createState() => _HomeChoferScreenState();
}

class _HomeChoferScreenState extends State<HomeChoferScreen> {
  
  var editando = false;
  var viajeEncontrado = false;
  late Size _pantalla;
  LatLng? initialLocation;
  LatLng? finalLocation;
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  final String _apiKey = "AIzaSyCjK6yYspK8d81TwsjbZkr3quq59iHRmbw";
  double? _tarifa;
  Viaje? objViajeSolicitado;
  final storage = FlutterSecureStorage();
  String? costo;
  String? NombreDestino;
  String? NombreOrigen;

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
  void initState()  {
    super.initState();

      _getCurrentLocation(); 

      WidgetsBinding.instance.addPostFrameCallback((_) async {

      if(widget.data!=null && widget.data!.isNotEmpty){
        objViajeSolicitado = await  Provider.of<ViajeService>(context, listen: false).ObtenerViaje(widget.data!["viajeid"]);
        if(objViajeSolicitado!=null){
          initialLocation = await Provider.of<ViajeService>(context, listen:false ).convertirStringToLatLng(objViajeSolicitado!.ubicacionOrigen);
          finalLocation = await Provider.of<ViajeService>(context, listen:false ).convertirStringToLatLng(objViajeSolicitado!.ubicacionDestino as String);
        
          if(initialLocation!=null ){
            _getAddressFromLatLng(LatLng(initialLocation!.latitude, initialLocation!.longitude), true );
          }

          if(finalLocation!=null ){
            _getAddressFromLatLng(LatLng(finalLocation!.latitude, finalLocation!.longitude), false );
          }

          if(initialLocation!=null && finalLocation!=null){
            _TrazarRuta(initialLocation as LatLng, finalLocation as LatLng);
          }

        }       
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
          NombreOrigen = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
        }else{
          NombreDestino = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
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
            FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: (objViajeSolicitado==null || objViajeSolicitado!= null &&objViajeSolicitado!.estado=='P')?null:(){print("perreo");}, 
                    child: Icon(Icons.map),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15)
                    )),
                ),
              ),
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
                          "",
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
                                        alto: constraints5.maxHeight * 0.32,
                                      )
                                    : _TarjetaTipoViaje(
                                        NombreDestino: (objViajeSolicitado!=null?NombreDestino:"-"),
                                        NombreOrigen: (objViajeSolicitado!=null?NombreOrigen:"-"),
                                        costo: (objViajeSolicitado != null ? objViajeSolicitado!.precio : "0.00"),
                                        ancho: constraints5.maxWidth * 0.60,
                                        alto: constraints5.maxHeight * 0.25,
                                      ),
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
                                texto: "Aceptar viaje",
                                onChanged:(initialLocation==null || finalLocation==null )?null: () async {
                                  
                                  //modificar estado viaje
                                  if(objViajeSolicitado!.estado=='P'){
                                    objViajeSolicitado!.estado = 'A';
                                    objViajeSolicitado!.tokenChofer = await storage.read(key: 'tknotif');
                                    objViajeSolicitado!.ubicacionChofer = _currentPosition as String;
                                    objViajeSolicitado!.claveUsuarioConfirmo = await  Provider.of<UsuarioService>(context, listen: false).objUsuarioSesion.id;
                                  }else if (objViajeSolicitado!.estado=='A'){
                                    objViajeSolicitado!.estado = 'R';
                                  }else if (objViajeSolicitado!.estado=='R'){
                                    objViajeSolicitado!.estado = 'T';
                                  }else if (objViajeSolicitado!.estado=='T'){
                                    objViajeSolicitado!.estado = 'F';
                                  }
                                  await Provider.of<ViajeService>(context, listen: false).updateViaje(objViajeSolicitado!);
                                  //acciones despues de modificar el viaje
                                  if(objViajeSolicitado!.estado=='A'){
                                    //notificar cliente que va en camino
                                    Map<String, dynamic> dataNotif = {
                                      "title":"¡Viaje aceptado!", 
                                      "body":"El conductor viene en camino...",
                                      "tokendestino":objViajeSolicitado!.tokenCliente,
                                      "data":{"viajeid":objViajeSolicitado!.id}//mandar data del conductor
                                    };
                                    await PushNotificationService.createNotification(dataNotif);

                                    //pintar linea del chofer al cliente


                                  }else if(objViajeSolicitado!.estado=='F'){
                                    //limpiar pantalla home para un nuevo viaje
                                  }
                                  
                                  //notificar al cliente que va en camino
                                 

                                  //await _mostrarAlertaBuscandoChofer();
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
  final String? costo;
  final String? NombreOrigen;
  final String? NombreDestino;


  const _TarjetaTipoViaje({
    required this.ancho, 
    required this.alto, 
    required this.NombreOrigen,
    required this.NombreDestino,
    required this.costo
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      height: alto,
      padding: const EdgeInsets.all(12),
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
               /* const Expanded(
                    child: CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      AssetImage("assets/imgbackgrounds/bg_solicitarviaje.png"),
                )),*/
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                        child: Text(
                          "Viaje Estándar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 5),
                       Expanded(
                        child: Text(
                          "Origen: ${NombreOrigen}",
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          textAlign: TextAlign.start
                        )),
                         Expanded(
                        child: Text(
                          "Destino: ${NombreDestino}",
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          textAlign: TextAlign.start,
                        )),
                      Expanded(
                        child: Text(
                          "\$ ${costo}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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


/*
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
*/
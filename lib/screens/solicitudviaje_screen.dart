import 'dart:async';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxi_app/screens/screens.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SolicitarViajeScreen extends StatefulWidget {
  const SolicitarViajeScreen({super.key});
  static  String name ="solicitudviaje_screen";

  @override
  State<SolicitarViajeScreen> createState() => _SolicitarViajeScreenState();
}

class _SolicitarViajeScreenState extends State<SolicitarViajeScreen> {
  var editando = false;
  var viajeEncontrado = false;
  late Size _pantalla;
  final Completer<GoogleMapController> _controller = Completer();

  //agregar ubicacion del usuario para ponerla en el btn pintado arriba pro defualt

  static const CameraPosition _initialPosition = CameraPosition(
    target: const LatLng(18.4624477,-97.3953397),
    zoom: 14
  );

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
          children: 
          [
           GoogleMap(
            initialCameraPosition: _initialPosition,
            mapType: MapType.normal,
            //markers,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
          
          SafeArea(child: Container(
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
                          child:
                              LayoutBuilder(builder: (context, constraints11) {
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
                                    texto: "Selecciona dirección de origen",
                                    iconoAux: FontAwesomeIcons.shareFromSquare,
                                    onChanged: (){
                                      final result = context.pushNamed(SeleccionUbicacionScreen.name, extra: "Ubicación origen");
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
                                    iconoAux: FontAwesomeIcons.shareFromSquare,
                                    texto: "Selecciona dirección de destino",
                                    onChanged: null)
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
                              texto: "Pedir viaje",
                              onChanged: () async =>
                                  //_mostrarAlertaBuscandoChofer(),
                                  await _mostrarAlertaCalificarViaje());
                        },
                      ))
                ],
              );
            }),
          ))],
        ),
         floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 200),
           child: FloatingActionButton(
              child: const Icon(Icons.location_searching),
              onPressed: () async {
                GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: LatLng(18.4624477,-97.3953397),
                    zoom: 14
                    )
                ));
                setState(() {
                  
                });
              }
            ),
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
            height: _pantalla.height * 0.30,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.20,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[Colors.black, Colors.black38])),
                    child: const Center(
                      child: Text(
                        "Calificar viaje",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.60,
                    child: const Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(
                                      "https://static.wikia.nocookie.net/logopedia/images/3/3a/1024x1024bb.jpg"),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 6,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Conductor: Felix Rodriguez Montiel",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "Unidad: Nissan Tida",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "Modelo: 2015",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "Placas: N908YA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.20,
                    child: Align(
                        alignment: Alignment.center,
                        child: RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemSize: 25,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        )),
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

  const _TarjetaTipoViaje({required this.ancho, required this.alto});

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
      child: const Column(
        children: [
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(value: true, onChanged: null))),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
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
                      Expanded(
                        child: Text(
                          "Clásico",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Viajes ecónomicos y seguros.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    "\$ --",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.end,
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

  const _TarjetaChoferAsignado({required this.ancho, required this.alto});

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
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.black, Colors.black38])),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Pedro Ramirez Perez",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                    child: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                            "https://static.wikia.nocookie.net/logopedia/images/3/3a/1024x1024bb.jpg"))),
                Expanded(
                  flex: 4,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Text(
                                "Unidad: Nissan Tida",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                "Modelo: 2015",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                "Placas: N908YA",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemSize: 25,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ))
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

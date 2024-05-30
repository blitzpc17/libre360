import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViajesChoferScreen extends StatefulWidget {
  static String name = 'viajeschofer_screen';
  const ViajesChoferScreen({super.key});

  @override
  State<ViajesChoferScreen> createState() => _ViajesChoferScreenState();
}

class _ViajesChoferScreenState extends State<ViajesChoferScreen> {
  var editando = false;
  var viajeAceptado = false;
  late Size _pantalla;

  @override
  Widget build(BuildContext context) {
    _pantalla = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)?.settings.arguments??"No data";

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
          body: SafeArea(child: Container(
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
                        "Viajes",
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
                        horizontal: 15, vertical: viajeAceptado ? 10 : 5),
                    width: constraints.maxWidth,
                    height: viajeAceptado
                        ? ((constraints.maxHeight * 0.80) +
                            constraints.maxHeight * 0.098)
                        : constraints.maxHeight * 0.80,
                    child: LayoutBuilder(builder: (context, constraints5) {
                      return Stack(children: [
                        SizedBox(
                          width: constraints.maxWidth,
                          height: constraints5.maxHeight,
                          child: Center(
                            child: Text("Mapa args: $args"),
                          ),
                        ),
                        SizedBox(
                          width: constraints5.maxWidth,
                          height: constraints5.maxHeight * 0.18,
                          child: const Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Expanded(
                                    child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      "https://static.wikia.nocookie.net/logopedia/images/3/3a/1024x1024bb.jpg"),
                                )),
                              )
                            ],
                          ),
                        ),
                        viajeAceptado
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: _tarjetaViajeAceptado(
                                    ancho: constraints5.maxWidth * 0.90,
                                    alto: constraints5.maxHeight * 0.22))
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    width: constraints.maxWidth,
                                    height: viajeAceptado
                                        ? constraints.maxHeight * 0
                                        : constraints.maxHeight * 0.098,
                                    child: LayoutBuilder(
                                      builder: (context, constraints12) {
                                        return BotonPersonalizado(
                                            ancho:
                                                constraints12.maxWidth * 0.10,
                                            alto:
                                                constraints12.maxHeight * 0.35,
                                            color: Colors.black,
                                            icono: FontAwesomeIcons.circleCheck,
                                            texto: "Aceptar",
                                            onChanged: () =>
                                                _mostrarAlertaDetallesViaje());
                                      },
                                    )),
                              ),
                      ]);
                    }),
                  ),
                  viajeAceptado
                      ? Container()
                      : Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.0995,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              color: Colors.black),
                          child: LayoutBuilder(
                            builder: (context, constraints12) {
                              return const Center(
                                child: Text(
                                  "Pulsa el botón para comenzar a aceptar viajes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ))
                ],
              );
            }),
          ))),
    );
  }

  _mostrarAlertaDetallesViaje() async {
    return await showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10),
            width: _pantalla.width,
            height: _pantalla.height * 0.22,
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(10)),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.white, Colors.white])),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Expanded(
                                  child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://static.wikia.nocookie.net/logopedia/images/3/3a/1024x1024bb.jpg"),
                              )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Daniel Gustavo Ramirez Valdes",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Origen: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Av. Los laureles #90, Col. Centro, Tehuacán.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Destino: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Calle miguel hidalgo #234, Col. Los Cipreses, Tehuacán..",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            BotonPersonalizado(
                                ancho: constraints.maxWidth * 0.70,
                                alto: constraints.maxHeight * 0.25,
                                color: Colors.black,
                                icono: FontAwesomeIcons.car,
                                texto: "Aceptar",
                                onChanged: () {
                                  setState(() {
                                    viajeAceptado = true;
                                  });
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      )
                    ],
                  )
                ],
              );
            }),
          );
        });
  }

  _tarjetaViajeAceptado({ancho, alto}) {
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
                  flex: 3,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                        flex: 8,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Origen: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Av. Los laureles #90, Col. Centro, Tehuacán.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Destino: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Calle miguel hidalgo #234, Col. Los Cipreses, Tehuacán..",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 10,
                          child:
                              LayoutBuilder(builder: (context, constraints34) {
                            return BotonPersonalizado(
                                ancho: constraints34.maxWidth * 0.80,
                                alto: constraints34.maxHeight * 0.80,
                                color: Colors.black,
                                icono: FontAwesomeIcons.xmark,
                                texto: "Cancelar",
                                onChanged: () {
                                  setState(() {
                                    viajeAceptado = false;
                                  });
                                });
                          }))
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

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/screens/screens.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class SeleccionUbicacionScreen extends StatefulWidget {
  final String textoTitulo;
  final bool origen;
  static String name = "seleccionubicacion_screen";

  const SeleccionUbicacionScreen({super.key, required this.textoTitulo, required this.origen});

  @override
  State<SeleccionUbicacionScreen> createState() =>
      _SeleccionUbicacionScreenState();
}

class _SeleccionUbicacionScreenState extends State<SeleccionUbicacionScreen> {
  var editando = false;
  var viajeEncontrado = false;
  late Size _pantalla;
  String tokenForSession = '37465';
  var uuid = Uuid();
  List<dynamic> listPlaces = [];
  final TextEditingController _controller = TextEditingController();

  void makeSuggestion(String input) async {
    String googlePlacesApiKey = 'AIzaSyCjK6yYspK8d81TwsjbZkr3quq59iHRmbw';//'AIzaSyB_z4OF-_0p0T3GNJtaakJiljud-8cCHMM';
    String groundUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundUrl?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession&components=country:mx&locality:Tehuacan';

    var responseResult = await http.get(Uri.parse(request));
    var Resultdata = responseResult.body.toString();

    print('Result Data: $Resultdata');

    if (responseResult.statusCode == 200) {
      setState(() {
        listPlaces = jsonDecode(responseResult.body.toString())['predictions'];
      });
    } else {
      throw Exception('Showing data failed, try again');
    }
  }

  void onModify(){
    if(tokenForSession==null)
    {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }

    makeSuggestion(_controller.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    
    _controller.addListener(() {
      onModify();
    });
  }

  @override
  Widget build(BuildContext context) {
    _pantalla = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.10,
                  child: LayoutBuilder(
                    builder: (context, constraints1) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              context.pop('/solicitudviaje');
                            },
                            child: Container(
                              height: constraints1.maxHeight,
                              width: constraints1.maxWidth * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.angleLeft,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: constraints1.maxWidth * 0.05,
                          ),
                          SizedBox(
                            height: constraints1.maxHeight,
                            width: constraints1.maxWidth * 0.70,
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                widget.textoTitulo,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                   /* List<Map<String, dynamic>> s = [
                      {
                        "ubicacion": "Av. Reforma",
                        "ubicacionCompleta":
                            "Av. Reforma Centro #90, Tehuacán Pue."
                      },
                      {
                        "ubicacion": "Av. Reforma",
                        "ubicacionCompleta":
                            "Av. Reforma Centro #90, Tehuacán Pue."
                      }
                    ];*/
          
                    listPlaces;
          
                    return Stack(children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: constraints5.maxHeight * 0.10),
                          width: constraints.maxWidth,
                          height: constraints5.maxHeight,
                          child: ListView.builder(
                            itemCount: listPlaces.length,
                            itemBuilder: (context, index) {
                              //print(listPlaces[index]);
                              return ListTile(
                                onTap: () async {
                                  //aqui poner codigfo para asignar la ubicacion seleccionada
                                },
                                leading: const FaIcon(FontAwesomeIcons.locationPin),
                                title: Text('${listPlaces[index]["description"]}'),
                                subtitle:null,
                                //trailing: const FaIcon(FontAwesomeIcons.clockRotateLeft),
                              );
                            },
                          )),
                      SizedBox(
                        width: constraints5.maxWidth,
                        height: constraints5.maxHeight * 0.10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 12,
                              child: CajaTextoPersonalizada(
                                label: "Dirección de destino",
                                hint: "Dirección de destino",
                                iconoPrefix: FontAwesomeIcons.locationDot,
                                icono: FontAwesomeIcons.locationDot,
                                controller: _controller,
                                onChanged: makeSuggestion,
                              ),
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {},
                              child: const Center(
                                child: FaIcon(FontAwesomeIcons.circleXmark),
                              ),
                            ))
                          ],
                        ),
                      )
                    ]);
                  }),
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.098,
                    child: LayoutBuilder(
                      builder: (context, constraints12) {
                        return BotonPersonalizado(
                            ancho: constraints12.maxWidth * 0.10,
                            alto: constraints12.maxHeight * 0.35,
                            color: Colors.black,
                            icono: FontAwesomeIcons.mapLocationDot,
                            anchoIconos: 0.10,
                            altoIconos: 0.75,
                            deshabFondoIconos: true,
                            colorIconos: Colors.grey,
                            texto: "Seleccionar del mapa",
                            onChanged: () {
                              //Aqui se mostrará el mapa
                              context.pushNamed(MapaScreen.name, extra: widget.origen);
                            });
                      },
                    ))
              ],
            );
          }),
        ),
      ),
    );
  }
}

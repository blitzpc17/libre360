
import 'package:taxi_app/modelo/models.dart';

import '../Services/services.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  var editando = false;
  var dias = [
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
    {"mes": "MAY", "dia": 20},
  ];

  @override
  Widget build(BuildContext context) {

    final viajesServices = Provider.of<ViajeService>(context);

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
                        "Historial",
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
                    padding: EdgeInsets.only(top: 5),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.09,
                    child: LayoutBuilder(builder: (context, constraints5) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: dias.map((ic) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: constraints5.maxWidth * 0.12,
                                  height: constraints5.maxHeight * 0.90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        ic["mes"] as String,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("${ic["dia"] as int}")
                                    ],
                                  )),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.70,
                    child: LayoutBuilder(builder: (context, constraints10) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                         children: viajesServices.viajes.expand((item) => [
                            _tarjetaHistorial(
                              ancho: constraints10.maxWidth, 
                              alto: constraints10.maxHeight*0.45, 
                              s:item)
                          ]).toList(),
                        ),
                      );
                    }),
                  )
                ],
              );
            }),
          ))),
    );
  }

  tarjetaHistorial(ancho, alto, Map<String, dynamic> s) {
   
  }
}

class _tarjetaHistorial extends StatelessWidget {

  final double ancho;
  final double alto ;
  final Viaje s;

  const _tarjetaHistorial({required this.ancho, required this.alto, required this.s});

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
              children: [
                Expanded(
                    child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                        "https://static.wikia.nocookie.net/logopedia/images/3/3a/1024x1024bb.jpg"),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Text(
                   s.folio,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "${56.89}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: BotonPersonalizado(
                    texto: "1ra Privada A V. Guerrero, Los cipreses",
                    ancho: ancho,
                    alto: alto * 0.60,
                    icono: FontAwesomeIcons.locationDot,
                    color: Colors.black,
                    onChanged: () {},
                  ),
                ),
                const Expanded(
                    child: SizedBox(
                  height: 5,
                )),
                Expanded(
                  flex: 5,
                  child: BotonPersonalizado(
                    texto: "Zona centro #145, Tehuacán.",
                    ancho: ancho,
                    alto: alto * 0.60,
                    icono: FontAwesomeIcons.flag,
                    color: Colors.black,
                    onChanged: () {},
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Pago en efectivo",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';

import '../widgets/widgets.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  var editando = false;

  @override
  Widget build(BuildContext context) {
    var pantalla = MediaQuery.of(context).size;

    final usuariosServices = Provider.of<UsuarioService>(context);

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
                        "Mi perfil",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.70,
                    child: LayoutBuilder(builder: (context, constraints2) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            width: constraints2.maxWidth,
                            height: constraints2.maxHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[Colors.white, Colors.white]),
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
                            child:  Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            "https://static.wikia.nocookie.net/logopedia/images/3/3a/1024x1024bb.jpg"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Nombre",
                                      hint: "Nombre",
                                      icono: FontAwesomeIcons.user,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Apellido paterno",
                                      hint: "Apellido paterno",
                                      icono: FontAwesomeIcons.user,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Apellido materno",
                                      hint: "Apellido materno",
                                      icono: FontAwesomeIcons.user,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Correo electronico",
                                      hint: "Correo electronico",
                                      icono: FontAwesomeIcons.envelope,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Teléfono",
                                      hint: "Teléfono",
                                      icono: FontAwesomeIcons.phone,
                                    ),
                                      SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      autocorrect: false,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.20,
                    child: LayoutBuilder(builder: (context, constraints3) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BotonPersonalizado(
                            texto:
                                editando == true ? "Guardar cambios" : "Editar",
                            ancho: constraints3.maxWidth * 0.60,
                            alto: constraints3.maxHeight * 0.35,
                            icono: null,
                            color: Colors.black,
                            onChanged: () {
                              setState(() {
                                editando = !editando;
                              });
                              /*usuariosServices.selectedUsuario = */
                            },
                          ),
                          SizedBox(
                            height: constraints3.maxHeight * 0.05,
                          ),
                          BotonPersonalizado(
                            texto: "Cancelar",
                            ancho: editando == true
                                ? constraints3.maxWidth * 0.60
                                : 0,
                            alto: editando == true
                                ? constraints3.maxHeight * 0.35
                                : 0,
                            icono: null,
                            color: Colors.black,
                            onChanged: () {
                              setState(() {
                                editando = false;
                              });
                            },
                          )
                        ],
                      );
                    }),
                  )
                ],
              );
            }),
          ))),
    );
  }
}

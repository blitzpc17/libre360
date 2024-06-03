import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/Services/usuario_service.dart';
import 'package:taxi_app/screens/screens.dart';

import '../modelo/models.dart';

class Menulateral extends StatefulWidget {
  const Menulateral({super.key});

  @override
  State<Menulateral> createState() => _MenulateralState();
}

class _MenulateralState extends State<Menulateral> {
  int _seleccion = 0;

  @override
  Widget build(BuildContext context) {

    final usuarioService = Provider.of<UsuarioService>(context, listen:false);   

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black38]),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.25,
                child: LayoutBuilder(builder: (context, constraints2) {
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(usuarioService.objUsuarioSesion.rol=="C"?'assets/driver.png':'assets/user.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: constraints2.maxWidth,
                            height: constraints2.maxHeight * 0.40,
                            child:  Center(
                              child: Column(
                                children: [
                                  Text(
                                    // ignore: unnecessary_null_comparison
                                    "Bienvenido ${usuarioService.objUsuarioSesion != null ? '${usuarioService.objUsuarioSesion.nombres} ${usuarioService.objUsuarioSesion.apellidos}' : ''}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    // ignore: unnecessary_null_comparison
                                    usuarioService.objUsuarioSesion.rol=='C'?"Conductor":"Usuario",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.0005,
                color: Colors.white,
              ),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.50,
                child: ListView(
                  padding: const EdgeInsets.all(7),
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: _seleccion == 0
                              ? Colors.black
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const Icon(
                          FontAwesomeIcons.house,
                          color: Colors.white,
                          size: 20,
                        ),
                        title: const Text(
                          'Inicio',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        selected: _seleccion == 0,
                        onTap: (){
                          selectDestination(0);
                          context.pushReplacementNamed(HomeScreen.name);
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: _seleccion == 1
                              ? Colors.black
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const Icon(
                          FontAwesomeIcons.clockRotateLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                        title: const Text(
                          'Historial de viajes',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        selected: _seleccion == 1,
                        onTap: () => selectDestination(1),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.0005,
                color: Colors.white,
              ),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.20,
                child: ListView(
                  padding: const EdgeInsets.all(7),
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: _seleccion == 2
                              ? Colors.black
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const Icon(
                          FontAwesomeIcons.circleUser,
                          color: Colors.white,
                          size: 20,
                        ),
                        title: const Text(
                          'Perfil',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        selected: _seleccion == 2,
                        onTap: () => selectDestination(2),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: _seleccion == 3
                              ? Colors.black
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const Icon(
                          FontAwesomeIcons.rightFromBracket,
                          color: Colors.white,
                          size: 20,
                        ),
                        title: const Text(
                          'Cerrar sesión',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        selected: _seleccion == 3,
                        onTap: (){
                          selectDestination(3);
                          //desloguear
                          usuarioService.logout();
                          context.pushReplacementNamed(LoginScreen.name);

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _seleccion = index;
    });
  }
}

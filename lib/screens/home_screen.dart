import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/screens/screens.dart';
import 'package:taxi_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var pantalla = MediaQuery.of(context).size;

       final usuarioService = Provider.of<UsuarioService>(context, listen:false);   

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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.10,
                    child: Text(
                      "!Hola ${usuarioService.objUsuarioSesion != null ? '${usuarioService.objUsuarioSesion.nombres} ${usuarioService.objUsuarioSesion.apellidos}' : ''}!",
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.90,
                    child: LayoutBuilder(builder: (context, constraints2) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            TarjetaPersonalizada(
                                ancho: constraints2.maxWidth,
                                alto: constraints2.maxHeight * 0.28,
                                titulo: "Viaje",
                                texto:
                                    "Viaja de la manera mas segura y comoda.",
                                textoBtn: "Solicitar viaje",
                                rutaImage:
                                    "assets/imgbackgrounds/bg_solicitarviaje.png",
                                function: (){
                                  context.pushNamed(SolicitarViajeScreen.name);
                                },
                                    )
                          ],
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
}

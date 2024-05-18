import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taxi_app/widgets/boton_personalizado.dart';

class TarjetaPersonalizada extends StatelessWidget {
  final double ancho, alto;
  final String titulo;
  final String texto;
  final String textoBtn;
  final String rutaImage;
  final dynamic? function;

  const TarjetaPersonalizada(
      {super.key,
      required this.ancho,
      required this.alto,
      required this.titulo,
      required this.texto,
      required this.textoBtn,
      required this.rutaImage,
      this.function
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      height: alto,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    texto,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
                  ),
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(rutaImage)))
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: BotonPersonalizado(
              texto: textoBtn,
              ancho: ancho * 0.60,
              alto: alto * 0.60,
              icono: null,
              color: Colors.black,
              onChanged: function,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/modelo/models.dart';
import 'package:taxi_app/providers/select_optins.dart';
import 'package:taxi_app/providers/usuario_form_provider.dart';

import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  // const RegisterScreen({super.key});
  static const name = 'register_screen';

  @override
  Widget build(BuildContext context) {
    final usuariosServices = Provider.of<UsuarioService>(context);
    final pantalla = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
        create: (_) => UsuarioFormProvider(),
        child: _RegisterScreenBody(
            pantalla: pantalla, usuariosServices: usuariosServices));
  }
}

class _RegisterScreenBody extends StatefulWidget {
  const _RegisterScreenBody(
      {super.key, required this.pantalla, required this.usuariosServices});

  final Size pantalla;
  final UsuarioService usuariosServices;

  @override
  State<_RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<_RegisterScreenBody> {
  String? perfil = "";
  Usuario objUsuario = new Usuario(   
      nombres: "", 
      apellidos: "", 
      email: "", 
      password: "", 
      telefono: "", 
      rol: "", 
      fechaalta: new DateTime.now(), 
      activo: "N", 
      fechabaja: "", 
      placa: "", 
      modelo: "", 
      color: "", 
      marca: "",
      domicilio: "",
      id: null, 
    );


  @override
  Widget build(BuildContext context) {

    final userForm = Provider.of<UsuarioFormProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: widget.pantalla.width - (widget.pantalla.width * 0.50),
              child: Container(
                width: widget.pantalla.width * 0.65,
                height: widget.pantalla.height * 0.22,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/imgbackgrounds/bg_registro.png'),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: widget.pantalla.width,
              height: widget.pantalla.height,
              decoration: const BoxDecoration(                
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black26, Colors.black87])),
              child: Form(
                key: userForm.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Expanded(child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            SizedBox(
                              height: constraints.maxHeight * 0.25,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: (){
                                  context.pop('/login');
                                },
                                child: const Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )),
                    Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                          child:
                              LayoutBuilder(builder: (context, constraints2) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: constraints2.maxWidth,
                                  height: constraints2.maxHeight * 0.22,
                                  child: const Text(
                                    "Bienvenido",
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),                              
                                SizedBox(
                                  width: constraints2.maxWidth,
                                  height: constraints2.maxHeight * 0.10,
                                  child: const Text(
                                    "¡Ingresa tus datos y viaja con nosotros!",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                  ),
                                ),
                                /*SizedBox(
                                  height: constraints2.maxHeight * 0.10,
                                ),*/
                              ],
                            );
                          }),
                        )),
                    Expanded(
                        flex: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 25),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<Option>(
                                    value: null,
                                    decoration: const InputDecoration(
                                        prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 12),
                                            child: FaIcon(
                                              FontAwesomeIcons.userCheck,
                                              size: 20,
                                            )),
                                        labelText: 'Quiero ser...'),
                                    items: SelectOptions.ListaPerfiles
                                        .map((e) {
                                      return DropdownMenuItem<Option>(
                                          value: e, 
                                          child: Text(e.label));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        objUsuario.rol = val != null?val.value:"";                                        
                                        print(objUsuario.rol);
                                      });
                                    },
                                    padding: const EdgeInsets.all(5),
                                  ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Nombre(s)",
                                      icono: FontAwesomeIcons.user,
                                      onChanged: (value){ 
                                        objUsuario.nombres = value;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Apellidos",
                                      icono: FontAwesomeIcons.user,
                                      onChanged: (value){ 
                                        objUsuario.apellidos = value;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Correo electrónico",                                      
                                      icono: FontAwesomeIcons.envelope,
                                      onChanged: (value){ 
                                        objUsuario.email = value;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Contraseña",
                                      icono: FontAwesomeIcons.lock,
                                      obscureText: true,
                                      onChanged: (value){ 
                                        objUsuario.password = value;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CajaTextoPersonalizada(
                                      label: "Teléfono",
                                      icono: FontAwesomeIcons.phone,
                                      onChanged: (value){ 
                                        objUsuario.telefono = value;
                                      },
                                    ),
                                    objUsuario.rol == "C"
                                        ? Container(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                CajaTextoPersonalizada(
                                                  label: "Domicilio",
                                                  icono: FontAwesomeIcons
                                                      .addressCard,
                                                  onChanged: (value){ 
                                                    objUsuario.domicilio = value;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                CajaTextoPersonalizada(
                                                  label: "Modelo",
                                                  icono:
                                                      FontAwesomeIcons.carRear,
                                                  onChanged: (value){ 
                                                    objUsuario.modelo = value;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                CajaTextoPersonalizada(
                                                  label: "Placas",
                                                  icono: FontAwesomeIcons
                                                      .circleInfo,
                                                  onChanged: (value){ 
                                                    objUsuario.placa = value;
                                                  },
                                                ),
                                                 const SizedBox(
                                                  height: 15,
                                                ),
                                                CajaTextoPersonalizada(
                                                  label: "Color",
                                                  icono: FontAwesomeIcons
                                                      .circleInfo,
                                                  onChanged: (value){ 
                                                    objUsuario.color = value;
                                                  },
                                                ),
                                                 const SizedBox(
                                                  height: 15,
                                                ),
                                                CajaTextoPersonalizada(
                                                  label: "Marca",
                                                  icono: FontAwesomeIcons
                                                      .circleInfo,
                                                  onChanged: (value){ 
                                                    objUsuario.marca = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(


                                        )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 3,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonPersonalizado(
                                ancho: constraints.maxWidth * 0.75,
                                alto: constraints.maxHeight * 0.35,
                                color: Colors.black54,
                                icono: FontAwesomeIcons.paperPlane,
                                texto: "Registrarse",
                                onChanged: () async {
                                  print(userForm.isValidForm());
                                  if(!userForm.isValidForm()){
                                    //mandar sncckbar
                                    NotificationsService.showSnackbar("Verifica tu información", Colors.amber.shade700, Icons.warning );
                                  }else{
                                    //procede a guardar
                                    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
                                    await usuarioService.saveOrCreateUsuario(objUsuario);
                                    NotificationsService.showSnackbar("¡Te has registrado, Bienvenido!", Colors.green.shade700, Icons.check );
                                  }

                                },  
                                
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

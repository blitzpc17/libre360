import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/modelo/models.dart';
import 'package:taxi_app/providers/select_optins.dart';
import 'package:taxi_app/providers/usuario_form_provider.dart';
import 'package:taxi_app/screens/login_screen.dart';

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
      tknotif: "",
      online: "",
      orden: ""
    );


  @override
  Widget build(BuildContext context) {

    final userForm = Provider.of<UsuarioFormProvider>(context);

        final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10));
        const Color amarillolib = Color.fromRGBO(232, 184, 47, 1);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(            
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/imgbackgrounds/login1.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: widget.pantalla.width,
              height: widget.pantalla.height,
              decoration: const BoxDecoration(                
                    color: Color.fromRGBO(50, 50, 50, 0.65)
                  ),
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
                                  height: constraints2.maxHeight * 0.28,                                  
                                  child: const Center(
                                    child: Text(                                    
                                      "Bienvenido",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),                              
                                SizedBox(                                  
                                  width: constraints2.maxWidth,
                                  height: constraints2.maxHeight * 0.25,
                                  child: const Center(
                                    child: Text(
                                      "¡Registrate y viaja ahora!",
                                      style: TextStyle(
                                          fontSize: 15, color: Color.fromRGBO(232,184,47,1)),
                                    ),
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
                        flex: 10,
                        child: Container(
                          padding: const EdgeInsets.all(15),                         
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
                                        floatingLabelStyle: TextStyle(color: amarillolib),
                                        hintStyle: TextStyle(color: Colors.amber),       
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white, // Color del borde cuando no está enfocado
                                            width: 2.0, // Grosor del borde cuando no está enfocado
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: amarillolib, // Color del borde cuando está enfocado
                                            width: 2.0, // Grosor del borde cuando está enfocado
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red, // Color del borde por defecto
                                            width: 2.0, // Grosor del borde por defecto
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.normal),
                                        focusColor: amarillolib,      
                                        suffixIconColor: amarillolib,
                                        prefixIconColor: amarillolib,
                                        labelText: 'Quiero ser...'
                                  ),
                                  dropdownColor: const Color.fromRGBO(0,0,0,1),
                                  items: SelectOptions.ListaPerfiles
                                      .map((e) {
                                    return DropdownMenuItem<Option>(
                                        value: e, 
                                        child: Text(e.label, style: const TextStyle(color: Colors.white),));
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      objUsuario.rol = val != null?val.value:"";                                        
                                      print(objUsuario.rol);
                                    });
                                  },
                                 
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
                                    color: Colors.white,
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
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  CajaTextoPersonalizada(
                                    label: "Correo electronico",                                      
                                    icono: FontAwesomeIcons.envelope,
                                    onChanged: (value){ 
                                      objUsuario.email = value;
                                    },
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  CajaTextoPersonalizada(
                                    label: "Contrasena",
                                    icono: FontAwesomeIcons.lock,
                                    obscureText: true,
                                    onChanged: (value){ 
                                      objUsuario.password = value;
                                    },
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  CajaTextoPersonalizada(
                                    label: "Telefono",
                                    icono: FontAwesomeIcons.phone,
                                    onChanged: (value){ 
                                      objUsuario.telefono = value;
                                    },
                                    color: Colors.white,
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
                                                color: Colors.white,
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
                                                color: Colors.white,
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
                                                color: Colors.white,
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
                                                color: Colors.white,
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
                                                color: Colors.white,
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
                        )),
                    Expanded(
                      flex: 3,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonPersonalizado(
                                ancho: constraints.maxWidth ,
                                alto: 60,
                                color: Colors.black54,
                                icono: FontAwesomeIcons.paperPlane,
                                texto: "Registrarme",
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
                                    context.pushNamed(LoginScreen.name);
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

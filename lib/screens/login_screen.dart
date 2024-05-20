import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/modelo/models.dart';
import 'package:taxi_app/providers/login_form_provider.dart';
import 'package:taxi_app/screens/register_screen.dart';

import '../Services/services.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const name='login_screen';

  @override
  Widget build(BuildContext context) {
    
    final usuariosService = Provider.of<UsuarioService>(context);
    var pantalla = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: pantalla.width,
              height: pantalla.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.black38]),
                  image: DecorationImage(
                    alignment: AlignmentDirectional.topStart,
                    image: AssetImage(
                        'assets/imgbackgrounds/background_login.jpg'),
                    fit: BoxFit.fitWidth,
                  )),
              child: ChangeNotifierProvider(
                create: (_)=>LoginFormProvider(),
                child: _LoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final loginForm = Provider.of<LoginFormProvider>(context);
    
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Taxi- App",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                )),
            Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 25),
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
                            CajaTextoPersonalizada(
                              label: "Correo electronico",
                              hint: "Correo electronico",
                              icono: FontAwesomeIcons.envelope,
                              onChanged: (value) => loginForm.email = value,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CajaTextoPersonalizada(
                              label: "Contraseña",
                              hint: "Contraseña",
                              icono: FontAwesomeIcons.lock,
                              onChanged: (value) => loginForm.password = value,
                            ),
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
                        alto: constraints.maxHeight * 0.22,
                        color: Colors.black54,
                        icono: FontAwesomeIcons.a,
                        texto: "Ingresar",
                        onChanged: loginForm.isLoading?null:() async{
      
                                  FocusScope.of(context).unfocus();
                                  final usuarioService = Provider.of<UsuarioService>(context, listen: false);

                                  if(!loginForm.isValidForm()) return;

                                  loginForm.isLoading = true;

                                  final String? errorMessahe = await usuarioService.login(loginForm.email, loginForm.password);

                                  if(errorMessahe == null){
                                   
                                  NotificationsService.showSnackbar("¡Bienvenido!", Colors.green, Icons.check);
                                   context.push('/home');

                                  }else{
                                    NotificationsService.showSnackbar(errorMessahe, Colors.amber, Icons.warning);
                                    loginForm.isLoading = false;
                                  }
                      
                      }),
                      SizedBox(
                        height: constraints.maxHeight * 0.10,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "¿Aun no tiene una cuenta - ",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                              GestureDetector(
                                onTap:(){
                                    context.pushNamed(RegisterScreen.name);
                                } ,                                       
                                child: const Text(
                                  "Registrate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

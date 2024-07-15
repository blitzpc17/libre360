import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/modelo/models.dart';
import 'package:taxi_app/providers/login_form_provider.dart';
import 'package:taxi_app/screens/home_screen.dart';
import 'package:taxi_app/screens/register_screen.dart';
import 'package:taxi_app/screens/screens.dart';

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
                        'assets/imgbackgrounds/login2.jpg'),
                    fit: BoxFit.fitHeight,
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
    
     return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(         
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(50, 50, 50, 0.65),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo/128X128.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 65),
            CajaTextoPersonalizada(
              textInputType: TextInputType.emailAddress,
              label: "Correo electronico",
              hint: "Correo electronico",
              icono: FontAwesomeIcons.envelope,
              onChanged: (value) => loginForm.email = value,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            CajaTextoPersonalizada(
              textInputType: TextInputType.text,
              label: "Contrasena",
              hint: "Contrasena",
              icono: FontAwesomeIcons.lock,
              onChanged: (value) => loginForm.password = value,
              color: Colors.white,
            ),
            const SizedBox(height: 55),
            BotonPersonalizado(
              ancho: MediaQuery.of(context).size.width,
              alto: 60,
              color: Colors.black54,
              icono: FontAwesomeIcons.a,
              texto: "Ingresar",
              onChanged: loginForm.isLoading ? null : () async {
                FocusScope.of(context).unfocus();
                final usuarioService = Provider.of<UsuarioService>(context, listen: false);
              
                if (!loginForm.isValidForm()) return;
              
                loginForm.isLoading = true;
              
                final String? errorMessage = await usuarioService.login(loginForm.email, loginForm.password);
              
                if (errorMessage == null) {
                  NotificationsService.showSnackbar("¡Bienvenido!", Colors.green, Icons.check);
              
                  if (usuarioService.objUsuarioSesion.rol == 'U') {
                    context.pushReplacementNamed(HomeScreen.name);
                  } else {
                    context.pushReplacementNamed(HomeChoferScreen.name);
                  }
                } else {
                  NotificationsService.showSnackbar(errorMessage, Colors.amber, Icons.warning);
                  loginForm.isLoading = false;
                }
              },
            ),
            const SizedBox(height: 200),
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿Aun no tiene una cuenta?",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(RegisterScreen.name);
                      },
                      child: const Text(
                        "Registrate",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );




  }
}

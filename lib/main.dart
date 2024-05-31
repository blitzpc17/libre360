import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/config/router/app_route.dart';
import 'package:taxi_app/config/theme/theme_app.dart';
import 'package:taxi_app/modelo/models.dart';
import 'package:taxi_app/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initalizeApp();
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioService()),
        ChangeNotifierProvider(create: (_) => ViajeService())
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuarioService = Provider.of<UsuarioService>(context, listen: false);

      PushNotificationService.messagesStream.listen((msg) async {
        print("MyApp: $msg");

        // Verificar si la sesión ha expirado
        String sessionExpirada = await usuarioService.validarSessionExpiro();
        Usuario objUsuario = await usuarioService.objUsuarioSesion;

        if (sessionExpirada == "") {

          if (objUsuario.rol == 'C') {
            //chofer
            appRouter.pushNamed(HomeChoferScreen.name, extra: msg);

          }else{
            //usuario
          } 

          final snackBar = SnackBar(content: Text("Notificación recibida"));
          NotificationsService.messengerKey.currentState?.showSnackBar(snackBar);
        } else {
          // Manejar la sesión expirada (por ejemplo, redirigir al login)
          //NotificationsService.navigatorKey.currentState?.pushNamed('/login');
           final snackBar = SnackBar(content: Text("Sesión caducada."));
             NotificationsService.messengerKey.currentState?.showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      scaffoldMessengerKey: NotificationsService.messengerKey,
    );
  }
}

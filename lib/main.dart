import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/config/router/app_route.dart';
import 'package:taxi_app/config/theme/theme_app.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initalizeApp();
  runApp(AppState());
}

class AppState extends StatefulWidget {
  @override
  _AppStateState createState() => _AppStateState();

}


class _AppStateState extends State<AppState> {

  @override
  void initState() {
    super.initState();

    PushNotificationService.messagesStream.listen((msg) {
      print("MyApp: $msg");
      //este se va a comentar por que solo va aser para el chofi
     NotificationsService.navigatorKey.currentState?.pushNamed( '/homechofer', arguments: msg);

      final snackBar = SnackBar(content: Text(msg),);
      NotificationsService.messengerKey.currentState?.showSnackBar(snackBar);
    });
    
  }

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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';
import 'package:taxi_app/config/router/app_route.dart';
import 'package:taxi_app/config/theme/theme_app.dart';


void main() {
  runApp(AppState());
}


class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UsuarioService()),
        ChangeNotifierProvider(create: (_)=>ViajeService())
      ],
      child: MainApp());
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

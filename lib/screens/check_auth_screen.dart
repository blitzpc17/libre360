import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Services/services.dart';

import 'package:taxi_app/screens/screens.dart';

class CheckAuthScreen extends StatelessWidget {

  static const name = 'check_auth'; 

  @override
  Widget build(BuildContext context) {   

    final authService = Provider.of<UsuarioService>( context, listen: false );

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            
            if ( !snapshot.hasData )            
              return Text('');

            if ( snapshot.data == '' ) {
              Future.microtask(() {
                context.pushReplacementNamed(LoginScreen.name);
              });

            } else {

              Future.microtask(() {
                context.pushReplacementNamed(HomeScreen.name);
              });
            }

            return Container();

          },
        ),
     ),
   );
  }
}
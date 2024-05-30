import 'package:flutter/material.dart';


class NotificationsService {


  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


  static showSnackbar( String message, Color color, IconData icono ) {

    final snackBar = SnackBar(
      content: Row(        
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icono,color: Colors.white),
          const SizedBox(height: 15),
          Text( 
            message, 
            style: const TextStyle( 
              color: Colors.white, 
              fontSize: 20)
          ),
        ],
      ),
      backgroundColor: color,
      
      
    );

    messengerKey.currentState!.showSnackBar(snackBar);

  }


}
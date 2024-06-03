import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

//E7:0C:FD:AE:0A:8F:66:C5:8A:C5:7D:E9:C3:24:16:A7:69:0F:74:D2

class PushNotificationService{

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<Map<String, dynamic>>_messageStreamController = StreamController();
  static Stream<Map<String, dynamic>>get messagesStream => _messageStreamController.stream;

  static const String url = "https://fcm.googleapis.com/fcm/send";
  static const String tokenNotif = "AAAA72VLyFo:APA91bGSfYvPkS-pUy0koLLlp45aGaWZwGCkdTcVChDLER_ZuVM8PACIzX6Ghh0Q-APPgliQlK1bTgRfBKP0zWSNR8Rz_niGWmbhUhdA4NqDaVnaWDmWpQnuXn64cRwnoBhiClaegj1C";

 


  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',// title    
    description:  'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
 
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


  static Future _backgroundHandler(RemoteMessage message) async {
    print("onBackground Handler ${message.messageId}");
    print("${message.data}");
    _messageStreamController.add(message.data);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print("onMessage Handler ${message.messageId}");
     print("${message.data[0]}");
     _messageStreamController.add(message.data);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    
        RemoteNotification? notification = message.notification;
        String iconName = AndroidInitializationSettings('@mipmap/ic_launcher').defaultIcon.toString();
    
        // Si `onMessage` es activado con una notificación, construimos nuestra propia
        // notificación local para mostrar a los usuarios, usando el canal creado.
        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,            
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: iconName
              ),
            )
          );
        }


  }

  static Future _onMessageOpenHandler(RemoteMessage message) async {
    print("onMessageOpen Handler ${message.messageId}");
     print("${message.data}");
     _messageStreamController.add(message.data);
  }

    
  
 
  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp: ${message.messageId}');
  }




  static Future initalizeApp() async {    

    //Push Notifications
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey:"AIzaSyDiO4VUEf9Nd-NvAS2z2wPWjd2cR7WPAuw", 
        appId: "1:1028196649050:android:526c70cae4d071b4ac3063", 
        messagingSenderId: "1028196649050", 
        projectId: "prueba23-edf7e",
        storageBucket: "prueba23-edf7e.appspot.com")
    );

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound:true
    );

/*
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );*/
    token = await FirebaseMessaging.instance.getToken();
    print("token: $token");
    final storage = FlutterSecureStorage();
    await storage.write(key: 'tknotif', value: token);
    final String? e =await storage.read(key: 'tknotif');


    //handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenHandler);  



  }

  static closeStreams(){
    _messageStreamController.close();
  }

  static Future<bool> createNotification(Map<String, dynamic> dataNotif) async {
    
   final Map<String, dynamic> notification = {
      'title': dataNotif['title'],
      'body': dataNotif['body'],
    };    

    final Map<String, dynamic> data = {
      'notification': notification,
      'priority': 'high',
      'to': dataNotif['tokendestino'],      
      'data': dataNotif['data']
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=${tokenNotif}',
      },
      body: jsonEncode(data),
    );

    print(tokenNotif);

    if (response.statusCode == 200) {
      print('Successfully sent message: ${response.body}');
      return true;
    } else {
      print('Error sending message: ${response.body}');
      return false;
    }


  }




}
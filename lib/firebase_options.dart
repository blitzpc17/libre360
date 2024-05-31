// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCe9OeUJjv_yc1MA8kbT4BpsbUUA9abYsc',
    appId: '1:1028196649050:web:c7409df30f93e189ac3063',
    messagingSenderId: '1028196649050',
    projectId: 'prueba23-edf7e',
    authDomain: 'prueba23-edf7e.firebaseapp.com',
    databaseURL: 'https://prueba23-edf7e-default-rtdb.firebaseio.com',
    storageBucket: 'prueba23-edf7e.appspot.com',
    measurementId: 'G-8GD20816V5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiO4VUEf9Nd-NvAS2z2wPWjd2cR7WPAuw',
    appId: '1:1028196649050:android:526c70cae4d071b4ac3063',
    messagingSenderId: '1028196649050',
    projectId: 'prueba23-edf7e',
    databaseURL: 'https://prueba23-edf7e-default-rtdb.firebaseio.com',
    storageBucket: 'prueba23-edf7e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVueGjXEzz-qbgIewZURW2f7wkVa_Z9Gc',
    appId: '1:1028196649050:ios:facc988157b0db6dac3063',
    messagingSenderId: '1028196649050',
    projectId: 'prueba23-edf7e',
    databaseURL: 'https://prueba23-edf7e-default-rtdb.firebaseio.com',
    storageBucket: 'prueba23-edf7e.appspot.com',
    iosBundleId: 'com.example.taxiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVueGjXEzz-qbgIewZURW2f7wkVa_Z9Gc',
    appId: '1:1028196649050:ios:facc988157b0db6dac3063',
    messagingSenderId: '1028196649050',
    projectId: 'prueba23-edf7e',
    databaseURL: 'https://prueba23-edf7e-default-rtdb.firebaseio.com',
    storageBucket: 'prueba23-edf7e.appspot.com',
    iosBundleId: 'com.example.taxiApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCe9OeUJjv_yc1MA8kbT4BpsbUUA9abYsc',
    appId: '1:1028196649050:web:46fcc8062da64a9bac3063',
    messagingSenderId: '1028196649050',
    projectId: 'prueba23-edf7e',
    authDomain: 'prueba23-edf7e.firebaseapp.com',
    databaseURL: 'https://prueba23-edf7e-default-rtdb.firebaseio.com',
    storageBucket: 'prueba23-edf7e.appspot.com',
    measurementId: 'G-J2HF12RE91',
  );
}
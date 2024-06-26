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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBS9roJyKeDoOnaG60Fo95GPZl8H_fPaMc',
    appId: '1:862345176718:android:10ace1f03aaa5b11530bdf',
    messagingSenderId: '862345176718',
    projectId: 'tasks-3b776',
    databaseURL: 'https://tasks-3b776-default-rtdb.firebaseio.com',
    storageBucket: 'tasks-3b776.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClFGBzAnJeN_njqDHfGk6O8G2P-nQzuS0',
    appId: '1:862345176718:ios:4236a699d1c42abe530bdf',
    messagingSenderId: '862345176718',
    projectId: 'tasks-3b776',
    databaseURL: 'https://tasks-3b776-default-rtdb.firebaseio.com',
    storageBucket: 'tasks-3b776.appspot.com',
    iosBundleId: 'com.example.oneMyTasks',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA485yloWj9GXhREGY2ejiUl-ZneRzct4E',
    appId: '1:862345176718:web:0920a096d77a3aaa530bdf',
    messagingSenderId: '862345176718',
    projectId: 'tasks-3b776',
    authDomain: 'tasks-3b776.firebaseapp.com',
    databaseURL: 'https://tasks-3b776-default-rtdb.firebaseio.com',
    storageBucket: 'tasks-3b776.appspot.com',
  );

}
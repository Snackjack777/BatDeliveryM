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
    apiKey: 'AIzaSyBf-AFUl9b2rVGyTdpH47eVBp7tjVCV6mw',
    appId: '1:465963359437:web:a3929e267c14e57ec59d84',
    messagingSenderId: '465963359437',
    projectId: 'flutter-firebase-mikkee',
    authDomain: 'flutter-firebase-mikkee.firebaseapp.com',
    storageBucket: 'flutter-firebase-mikkee.appspot.com',
    measurementId: 'G-LX8L5MNJW7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkt7Hsr474TlEfp-qUb1bLmC9EAxVWjY0',
    appId: '1:465963359437:android:be50a64d4b44bbdac59d84',
    messagingSenderId: '465963359437',
    projectId: 'flutter-firebase-mikkee',
    storageBucket: 'flutter-firebase-mikkee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHiTsCcHs6ZPSDOCfyiaiKj3i6hSEw8u0',
    appId: '1:465963359437:ios:ff4a26dab782b04dc59d84',
    messagingSenderId: '465963359437',
    projectId: 'flutter-firebase-mikkee',
    storageBucket: 'flutter-firebase-mikkee.appspot.com',
    iosBundleId: 'com.example.lotto',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHiTsCcHs6ZPSDOCfyiaiKj3i6hSEw8u0',
    appId: '1:465963359437:ios:ff4a26dab782b04dc59d84',
    messagingSenderId: '465963359437',
    projectId: 'flutter-firebase-mikkee',
    storageBucket: 'flutter-firebase-mikkee.appspot.com',
    iosBundleId: 'com.example.lotto',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBf-AFUl9b2rVGyTdpH47eVBp7tjVCV6mw',
    appId: '1:465963359437:web:dbab46b414466cbdc59d84',
    messagingSenderId: '465963359437',
    projectId: 'flutter-firebase-mikkee',
    authDomain: 'flutter-firebase-mikkee.firebaseapp.com',
    storageBucket: 'flutter-firebase-mikkee.appspot.com',
    measurementId: 'G-59HHLGX2Q3',
  );

}
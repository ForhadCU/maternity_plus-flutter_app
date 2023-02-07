// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAcOO-0SNaJeDTkzz4-FL5fle8l0FwvJQE',
    appId: '1:108205886977:web:689a807e3aa0bc8f5dba00',
    messagingSenderId: '108205886977',
    projectId: 'maaapp-ab769',
    authDomain: 'maaapp-ab769.firebaseapp.com',
    storageBucket: 'maaapp-ab769.appspot.com',
    measurementId: 'G-LKYYKG345Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVtJXRvFxVXSAmdKI-sZ-grWBFSd-A3FI',
    appId: '1:108205886977:android:d0b4b02ef39bba095dba00',
    messagingSenderId: '108205886977',
    projectId: 'maaapp-ab769',
    storageBucket: 'maaapp-ab769.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAU5ZbaqzvxsukilTAyRp8nPdM2DZB09rM',
    appId: '1:108205886977:ios:60f8708a63604f815dba00',
    messagingSenderId: '108205886977',
    projectId: 'maaapp-ab769',
    storageBucket: 'maaapp-ab769.appspot.com',
    androidClientId: '108205886977-ubt79tmjaot7l44koji4d80vbfqi1eli.apps.googleusercontent.com',
    iosClientId: '108205886977-b608n1igic9p2sgv3sgbupm871qtm969.apps.googleusercontent.com',
    iosBundleId: 'com.example.splashScreen',
  );
}

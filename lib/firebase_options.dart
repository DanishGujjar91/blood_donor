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
        return macos;
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
    apiKey: 'AIzaSyAxXSqPhbwDCVkwStdIwExKKy-uUdvkoiU',
    appId: '1:603607670443:web:705afae20196dbe8c221ee',
    messagingSenderId: '603607670443',
    projectId: 'blood-donor-75493',
    authDomain: 'blood-donor-75493.firebaseapp.com',
    storageBucket: 'blood-donor-75493.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMItHtD-bELo_vMajIYeQGjXY6UCnF6HI',
    appId: '1:603607670443:android:39cd9d9c114652e6c221ee',
    messagingSenderId: '603607670443',
    projectId: 'blood-donor-75493',
    storageBucket: 'blood-donor-75493.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlUc5n0HI084PLgA8WfyGzxEl4_Wpwitg',
    appId: '1:603607670443:ios:0a7b6f1a905737c5c221ee',
    messagingSenderId: '603607670443',
    projectId: 'blood-donor-75493',
    storageBucket: 'blood-donor-75493.appspot.com',
    iosClientId: '603607670443-2h8nisu8p3ql4p0bs5c4d8sna57111g9.apps.googleusercontent.com',
    iosBundleId: 'com.example.bloodDonor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlUc5n0HI084PLgA8WfyGzxEl4_Wpwitg',
    appId: '1:603607670443:ios:0a7b6f1a905737c5c221ee',
    messagingSenderId: '603607670443',
    projectId: 'blood-donor-75493',
    storageBucket: 'blood-donor-75493.appspot.com',
    iosClientId: '603607670443-2h8nisu8p3ql4p0bs5c4d8sna57111g9.apps.googleusercontent.com',
    iosBundleId: 'com.example.bloodDonor',
  );
}

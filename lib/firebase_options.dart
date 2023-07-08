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
    apiKey: 'AIzaSyDgEvPk3Yjy1GpkBa-PQK720jD8EJyRGlE',
    appId: '1:328975985379:web:7e88c80ccb8cc9999af3d6',
    messagingSenderId: '328975985379',
    projectId: 'babylog-flutter',
    authDomain: 'babylog-flutter.firebaseapp.com',
    storageBucket: 'babylog-flutter.appspot.com',
    measurementId: 'G-90BP8XGD1Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGaauJfG5B4GY6kwuJVTBMlLb-OBJ3250',
    appId: '1:328975985379:android:9b9ab48fd27147b79af3d6',
    messagingSenderId: '328975985379',
    projectId: 'babylog-flutter',
    storageBucket: 'babylog-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4E8x5aNMkLWMObra_wXt_puLzuzVizrQ',
    appId: '1:328975985379:ios:8995c0af4d0c50b09af3d6',
    messagingSenderId: '328975985379',
    projectId: 'babylog-flutter',
    storageBucket: 'babylog-flutter.appspot.com',
    iosClientId: '328975985379-hulnd0s42f0hj38t005mivjt5unta8ju.apps.googleusercontent.com',
    iosBundleId: 'com.example.babylog',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4E8x5aNMkLWMObra_wXt_puLzuzVizrQ',
    appId: '1:328975985379:ios:750ef70e39a59fed9af3d6',
    messagingSenderId: '328975985379',
    projectId: 'babylog-flutter',
    storageBucket: 'babylog-flutter.appspot.com',
    iosClientId: '328975985379-6vc6nlk5lpe661tn9pr0rd4hc9t6adp2.apps.googleusercontent.com',
    iosBundleId: 'com.example.babylog.RunnerTests',
  );
}

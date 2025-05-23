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
    apiKey: 'AIzaSyCcTjE3ONldWdQ5IbVVN6474SF3n-JZvsE',
    appId: '1:922379001254:web:68a737aed21e4ede194367',
    messagingSenderId: '922379001254',
    projectId: 'snappoll-181d5',
    authDomain: 'snappoll-181d5.firebaseapp.com',
    storageBucket: 'snappoll-181d5.appspot.com',
    measurementId: 'G-N4V1811VV5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATFlI_ELipI9OabbzS-suQ0TmVIMos_hs',
    appId: '1:922379001254:android:7fca674a379f997b194367',
    messagingSenderId: '922379001254',
    projectId: 'snappoll-181d5',
    storageBucket: 'snappoll-181d5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAk-Y1KZ53sktFq_VcdQw1j-gd5E7Dhcws',
    appId: '1:922379001254:ios:6c33fb5fc13c6267194367',
    messagingSenderId: '922379001254',
    projectId: 'snappoll-181d5',
    storageBucket: 'snappoll-181d5.appspot.com',
    androidClientId: '922379001254-thnclamou61po87rt982sd38og42k86v.apps.googleusercontent.com',
    iosClientId: '922379001254-gtlddo49skh7f7g3sscdt09arp4o6i52.apps.googleusercontent.com',
    iosBundleId: 'com.example.snapPoll',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAk-Y1KZ53sktFq_VcdQw1j-gd5E7Dhcws',
    appId: '1:922379001254:ios:6c33fb5fc13c6267194367',
    messagingSenderId: '922379001254',
    projectId: 'snappoll-181d5',
    storageBucket: 'snappoll-181d5.appspot.com',
    androidClientId: '922379001254-thnclamou61po87rt982sd38og42k86v.apps.googleusercontent.com',
    iosClientId: '922379001254-gtlddo49skh7f7g3sscdt09arp4o6i52.apps.googleusercontent.com',
    iosBundleId: 'com.example.snapPoll',
  );
}

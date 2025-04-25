import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCsBXn1Y9OyIGWYhUg-fLGFpXDdFNznVE0',
    appId: '1:918380051303:web:ed45b19a779202e7ad0a4b',
    messagingSenderId: '918380051303',
    projectId: 'tiktok-clone-441511',
    authDomain: 'tiktok-clone-441511.firebaseapp.com',
    databaseURL: 'https://tiktok-clone-441511-default-rtdb.firebaseio.com',
    storageBucket: 'tiktok-clone-441511.firebasestorage.app',
    measurementId: 'G-E4L62MQBBY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsBXn1Y9OyIGWYhUg-fLGFpXDdFNznVE0',
    appId: '1:918380051303:android:4f40c0fd2b85c867018dc2',
    messagingSenderId: '918380051303',
    projectId: 'tiktok-clone-441511',
    databaseURL: 'https://tiktok-clone-441511-default-rtdb.firebaseio.com',
    storageBucket: 'tiktok-clone-441511.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsBXn1Y9OyIGWYhUg-fLGFpXDdFNznVE0',
    appId: '1:918380051303:ios:4f40c0fd2b85c867018dc2',
    messagingSenderId: '918380051303',
    projectId: 'tiktok-clone-441511',
    databaseURL: 'https://tiktok-clone-441511-default-rtdb.firebaseio.com',
    storageBucket: 'tiktok-clone-441511.firebasestorage.app',
    iosClientId:
        '918380051303-o9hs7l3n73vt51p71hr9odvmrjsu5tol.apps.googleusercontent.com',
    iosBundleId: 'com.example.tiktok_app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsBXn1Y9OyIGWYhUg-fLGFpXDdFNznVE0',
    appId: '1:918380051303:ios:4f40c0fd2b85c867018dc2',
    messagingSenderId: '918380051303',
    projectId: 'tiktok-clone-441511',
    databaseURL: 'https://tiktok-clone-441511-default-rtdb.firebaseio.com',
    storageBucket: 'tiktok-clone-441511.firebasestorage.app',
    iosClientId:
        '918380051303-o9hs7l3n73vt51p71hr9odvmrjsu5tol.apps.googleusercontent.com',
    iosBundleId: 'com.example.tiktok_app',
  );
}

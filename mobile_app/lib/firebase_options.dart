import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
    apiKey: 'AIzaSyBbityr3vU5FPlKR7kzANAln2u8BnFE34E',
    appId: '1:250305718339:android:89a2e5270c818aa5554cf6',
    messagingSenderId: '250305718339',
    projectId: 'm2pex-final-project-2cb7f',
    storageBucket: 'm2pex-final-project-2cb7f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4rCZbbSjuxw7Lm9jlnzVFD6FS6EmPbv8',
    appId: '1:250305718339:ios:4220428a524d676e554cf6',
    messagingSenderId: '250305718339',
    projectId: 'm2pex-final-project-2cb7f',
    storageBucket: 'm2pex-final-project-2cb7f.firebasestorage.app',
    iosClientId: '250305718339-7rk82l0h9vhfjb006ckv228c0onf453m.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobileApp',
  );
}

// File: firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCTrwC6rU4uUTqq0s25SpJvEPTA5MwmP7M',
      appId: '1:964865307741:web:0b23526c97a4fc2d7989b4',
      messagingSenderId: '964865307741',
      projectId: 'flutter-to-do-lab',
      authDomain: 'flutter-to-do-lab.firebaseapp.com',
      storageBucket: 'flutter-to-do-lab.appspot.com',
    );
  }
}

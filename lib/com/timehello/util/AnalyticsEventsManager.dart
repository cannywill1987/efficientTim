// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AnalyticsEventsManager {
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  static AnalyticsEventsManager? instance;

  static getInstance() {
    if(instance == null) {
      instance = AnalyticsEventsManager();
      instance?.init();
    }
    return instance;
  }

  init(){
    // Firebase.initializeApp();
  }


  Future<void> _setDefaultEventParameters() async {
    // await analytics.setDefaultEventParameters(<String, dynamic>{
    //   'string': 'string',
    //   'int': 42,
    //   'long': 12345678910,
    //   'double': 42.0,
    //   'bool': true.toString(),
    // });
  }

  Future<void> sendAnalyticsEventMap(Map data) async {
    try {
      String sceneType = data['sceneType'] ?? "";
      String eventType = data['eventType'] ?? "";
      String message = data['message'] ?? "";
      await analytics.logEvent(
        name: sceneType + '_' + eventType,
        parameters: <String, dynamic>{
          'sceneType': sceneType,
          'eventType': eventType,
          'message': message,
        },
      );
    } catch(e) {
      print(e);
    }
  }

  Future<void> sendAnalyticsEvent({name}) async {
    // Only strings and numbers (longs & doubles for android, ints and doubles for iOS) are supported for GA custom event parameters:
    // https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#+logeventwithname:parameters:
    // https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics#public-void-logevent-string-name,-bundle-params
    //部分小米机型打不开
    // try {
    //   await analytics.logEvent(
    //     name: name,
    //     parameters: <String, dynamic>{
    //       'event_name': name,
    //       // 'int': 42,
    //       // 'long': 12345678910,
    //       // 'double': 42.0,
    //       // // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
    //       // // https://developers.google.cn/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
    //       // 'bool': true.toString(),
    //     },
    //   );
    // } catch(e) {
    //   print(e);
    // }
  }


// final FirebaseAnalytics _analytics = FirebaseAnalytics();

// FirebaseAnalyticsObserver getAnalyticsObserver() =>
//     FirebaseAnalyticsObserver(analytics: _analytics);
}

class DefaultFirebaseOptions {
  // static FirebaseOptions get currentPlatform {
  //   if (kIsWeb) {
  //     return web;
  //   }
  //   switch (defaultTargetPlatform) {
  //     case TargetPlatform.android:
  //       return android;
  //     case TargetPlatform.iOS:
  //       return ios;
  //     case TargetPlatform.macOS:
  //       return macos;
  //     case TargetPlatform.windows:
  //       throw UnsupportedError(
  //         'DefaultFirebaseOptions have not been configured for windows - '
  //             'you can reconfigure this by running the FlutterFire CLI again.',
  //       );
  //       return macos;
  //   // throw UnsupportedError(
  //   //   'DefaultFirebaseOptions have not been configured for windows - '
  //   //       'you can reconfigure this by running the FlutterFire CLI again.',
  //   // );
  //     case TargetPlatform.linux:
  //       throw UnsupportedError(
  //         'DefaultFirebaseOptions have not been configured for linux - '
  //             'you can reconfigure this by running the FlutterFire CLI again.',
  //       );
  //       return macos;
  //     default:
  //       throw UnsupportedError(
  //         'DefaultFirebaseOptions are not supported for this platform.',
  //       );
  //       return macos;
  //   }
  // }
  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyB7wZb2tO1-Fs6GbDADUSTs2Qs3w08Hovw',
  //   appId: '1:406099696497:web:87e25e51afe982cd3574d0',
  //   messagingSenderId: '406099696497',
  //   projectId: 'flutterfire-e2e-tests',
  //   authDomain: 'flutterfire-e2e-tests.firebaseapp.com',
  //   databaseURL:
  //   'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
  //   storageBucket: 'flutterfire-e2e-tests.appspot.com',
  //   measurementId: 'G-JN95N1JV2E',
  // );
  //
  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'AIzaSyBLS41GtdPpHDxoZJCnApkgsEKhZTsKOEc',
  //   appId: '1:163911111516:android:759884691278916e256799',
  //   messagingSenderId: '406099696497',
  //   projectId: 'timerbell-3a4af',
  //   storageBucket: 'timerbell-3a4af.appspot.com',
  // );
  // // databaseURL:
  // // 'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
  //
  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyAy6Leuu8G_uAVOtWgB5ZGPj47G4xts8oM',
  //   appId: '1:163911111516:ios:0704eba5fd312cfb256799',
  //   messagingSenderId: '406099696497',
  //   projectId: 'timerbell-3a4af',
  //   databaseURL:
  //   'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
  //   storageBucket: 'timerbell-3a4af.appspot.com',
  //   androidClientId:
  //   '163911111516-8vgn1632c9m0q67hmu0eboriogsn3hn4.apps.googleusercontent.com',
  //   iosClientId:
  //   '163911111516-gloh29m5f32vobruebkuevck16hd4mv3.apps.googleusercontent.com',
  //   iosBundleId: 'com.timespeed.timehello',
  // );
  //
  // static const FirebaseOptions macos = FirebaseOptions(
  //   apiKey: 'AIzaSyAy6Leuu8G_uAVOtWgB5ZGPj47G4xts8oM',
  //   appId: '1:163911111516:ios:0704eba5fd312cfb256799',
  //   messagingSenderId: '406099696497',
  //   projectId: 'timerbell-3a4af',
  //   databaseURL:
  //   'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
  //   storageBucket: 'timerbell-3a4af.appspot.com',
  //   androidClientId:
  //   '163911111516-8vgn1632c9m0q67hmu0eboriogsn3hn4.apps.googleusercontent.com',
  //   iosClientId:
  //   '163911111516-gloh29m5f32vobruebkuevck16hd4mv3.apps.googleusercontent.com',
  //   iosBundleId: 'com.timespeed.timehello',
  // );
}

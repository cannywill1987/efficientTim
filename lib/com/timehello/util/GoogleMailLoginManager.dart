import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';

import '../config/Params.dart';

class GoogleMailLoginManager {
  static GoogleMailLoginManager? instance;
  Timer? timer;
  bool? isEmailVerifiedVal=false;
  static getInstance() {
    if(instance == null) {
      instance = GoogleMailLoginManager();
      instance?.init();
    }
    return instance;
  }

  init(){
    // Firebase.initializeApp();
  }

  unregisterAccount({required String email, required String password}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? email = user?.email;
      bool isEmailVerified = user?.emailVerified ?? false;
      await user?.delete();
    } catch(e) {
      print(e);
    }
  }


  Future<void> login({required String email, required String password, required Function callbackSuccess}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      String? emailTmp = user?.email;
      bool isEmailVerified = user?.emailVerified ?? false;
      print('Signed in: ${userCredential.user}');
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        callbackSuccess();
        print('Verification email has been sent.');
      } else {
        callbackSuccess.call();
      }
      print('Signed in: ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use') {

      }
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  Future<void> signIn({required String email, required String password, required Function callbackSuccess}) async {
    // try {
    //   await FirebaseAuth.instance.currentUser?.reload();
    // } catch(e) {}
    try {
      // await unregisterAccount(email: email, password: password);
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      String? emailTmp = user?.email;
      bool isEmailVerified = user?.emailVerified ?? false;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        callbackSuccess();
        print('Verification email has been sent.');
      }

      print('Signed in: ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use') {
        await login(email: email, password: password, callbackSuccess: callbackSuccess);

      }
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  bool isEmailVerified() {
    User? user = FirebaseAuth.instance.currentUser;

    this.isEmailVerifiedVal = user?.emailVerified ?? false;
    // if(!(isEmailVerifiedVal ?? false)) {
    //   sendVerificationEmail();
    // }
    return isEmailVerifiedVal ?? false;
  }

  cancelTimer() {
    timer?.cancel();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    isEmailVerifiedVal = FirebaseAuth.instance.currentUser?.emailVerified;
    return isEmailVerifiedVal;
    // if(isEmailVerified == false) {
    //   sendVerificationEmail();
    // }
  }

  resetPassword({String? email, String? password}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email ?? '');
      print('Password reset email has been sent.');
    } on FirebaseAuthException catch(e) {
      print(e);
    }
  }

  Future<bool> isEmailExistFromServer({required String email}) async {
    try {
      BaseBean baseBean = await HttpManager.getInstance().doPostRequest(Urls.isUserExistByEmail, params: {"email": email});
      if(baseBean.code == CONSTANTS.CODE_USER_EXIST) {
        return true;
      }
      return false;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future checkEmailVerifiedPeriodic({required Function callSuccess}) async {
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      bool? isVerified = await checkEmailVerified();
      print('isVerified: $isVerified');
      if(isVerified == true) {
        callSuccess();
        timer.cancel();
      }
    });
  }

  Future sendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
    } catch(e) {
      print(e);
    }
  }

}

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
        return macos;
    // throw UnsupportedError(
    //   'DefaultFirebaseOptions have not been configured for windows - '
    //       'you can reconfigure this by running the FlutterFire CLI again.',
    // );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
        return macos;
    }
  }
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7wZb2tO1-Fs6GbDADUSTs2Qs3w08Hovw',
    appId: '1:406099696497:web:87e25e51afe982cd3574d0',
    messagingSenderId: '406099696497',
    projectId: 'flutterfire-e2e-tests',
    authDomain: 'flutterfire-e2e-tests.firebaseapp.com',
    databaseURL:
    'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutterfire-e2e-tests.appspot.com',
    measurementId: 'G-JN95N1JV2E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLS41GtdPpHDxoZJCnApkgsEKhZTsKOEc',
    appId: '1:163911111516:android:759884691278916e256799',
    messagingSenderId: '406099696497',
    projectId: 'timerbell-3a4af',
    storageBucket: 'timerbell-3a4af.appspot.com',
  );
  // databaseURL:
  // 'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAy6Leuu8G_uAVOtWgB5ZGPj47G4xts8oM',
    appId: '1:163911111516:ios:0704eba5fd312cfb256799',
    messagingSenderId: '406099696497',
    projectId: 'timerbell-3a4af',
    databaseURL:
    'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'timerbell-3a4af.appspot.com',
    androidClientId:
    '163911111516-8vgn1632c9m0q67hmu0eboriogsn3hn4.apps.googleusercontent.com',
    iosClientId:
    '163911111516-gloh29m5f32vobruebkuevck16hd4mv3.apps.googleusercontent.com',
    iosBundleId: 'com.timespeed.timehello',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAy6Leuu8G_uAVOtWgB5ZGPj47G4xts8oM',
    appId: '1:163911111516:ios:0704eba5fd312cfb256799',
    messagingSenderId: '406099696497',
    projectId: 'timerbell-3a4af',
    databaseURL:
    'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'timerbell-3a4af.appspot.com',
    androidClientId:
    '163911111516-8vgn1632c9m0q67hmu0eboriogsn3hn4.apps.googleusercontent.com',
    iosClientId:
    '163911111516-gloh29m5f32vobruebkuevck16hd4mv3.apps.googleusercontent.com',
    iosBundleId: 'com.timespeed.timehello',
  );
}

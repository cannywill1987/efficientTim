import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time_hello/com/timehello/util/EasyLoadingManager.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart' as FBinterface;
import 'package:time_hello/com/timehello/util/Utility.dart';

import 'AnalyticsEventsManager.dart';
import 'DeviceInfoManagement.dart';
import 'LoginUtil.dart';

/**
 * 用于金额管理
 */
class FirebaseAuthManager {
  static FirebaseAuthManager? mFirebaseManager;
  String? userEmail;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static FirebaseAuthManager getInstance() {
    if (mFirebaseManager == null) {
      mFirebaseManager = new FirebaseAuthManager();
      // mFirebaseManager?.init();
    }
    return mFirebaseManager!;
  }

  static initialized() async {
    if (DeviceInfoManagement.isWEB() == false) {
      await Firebase.initializeApp(
        name: "TimerBell",
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "xxx",
          appId: "xxx",
          messagingSenderId: "xxx",
          projectId: "xxx",
        ),
      );
    }
  }

  init() {
    // FacebookAuth.instance.autoLogAppEventsEnabled(true);

    //支持web
    if (Utility.isMacOS() == true) {
      // initialiaze the facebook javascript SDK
      //  FacebookAuth.instance.webAndDesktopInitialize(
      //   appId: "743462913842281",
      //   cookie: true,
      //   xfbml: true,
      //   version: "v15.0",
      // );
    }
  }

  verifyEmail({required String oobCode}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.checkActionCode(oobCode);
      await _auth.applyActionCode(oobCode);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Email verified successfully')),
      // );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error verifying email: $e')),
      // );
    }
  }

  /**
   * https://firebase.google.cn/docs/auth/flutter/email-link-auth?hl=zh-cn
   * https://firebase.google.cn/docs/auth/flutter/passing-state-in-email-actions?hl=zh-cn
   * 参考
   */
  signInGmail({required String email, required String password}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.sendEmailVerification();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Verification email sent to ${_emailController.text}')),
    // );
    //111
    // var acs = ActionCodeSettings(
    //     // URL you want to redirect back to. The domain (www.example.com) for this
    //     // URL must be whitelisted in the Firebase Console.
    //     url: 'https://www.example.com/finishSignUp?cartId=1234',
    //     // This must be true
    //     handleCodeInApp: true,
    //     iOSBundleId: 'com.example.ios',
    //     androidPackageName: 'com.example.android',
    //     // installIfNotAvailable
    //     androidInstallApp: true,
    //     // minimumVersion
    //     androidMinimumVersion: '12');
    //
    // var emailAuth = '258843056@qq.com';
    // FirebaseAuth.instance
    //     .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
    //     .catchError(
    //         (onError) => print('Error sending email verification $onError'))
    //     .then((value) => print('Successfully sent email verification'));
   //222
    // final user = FirebaseAuth.instance.currentUser;
    //
    // final actionCodeSettings = ActionCodeSettings(
    //   url: "http://www.example.com/verify?email=${user?.email}",
    //   iOSBundleId: "com.example.ios",
    //   androidPackageName: "com.example.android",
    // );
    //
    // await user?.sendEmailVerification(actionCodeSettings);
  }

  // Future<UserCredential> signInWithGoogle() async {
  Future<Map> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      EasyLoadingManager.getInstance().showLoading();
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>[
          'email',
          // 'https://www.googleapis.com/auth/contacts.readonly',
        ],
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // GoogleAuthProvider.credential()
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential.user?.displayName ?? '');
      // User? user = FirebaseAuth.instance.currentUser;
      String email = userCredential.user?.email ?? "";
      String displayName = userCredential.user?.displayName ?? "";
      // String phoneNumber = googleUser.phoneNumber ?? "";
      // String photoUrl = userCredential.user?.photoUrl ?? "";
      String id = googleUser?.id ?? "";

      return {
        "email": email,
        "name": displayName,
        // "id": id,
        // "avatar": photoUrl
      };
    } catch (e) {
      EasyLoadingManager.getInstance().hideLoading();
      print(e);
    }
    return {};
    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Future<void> _signInWithTwitter() async {
  //   TwitterAuthProvider twitterProvider = TwitterAuthProvider();
  //
  //   // if (kIsWeb) {
  //   //   await auth.signInWithPopup(twitterProvider);
  //   // } else {
  //     await auth.signInWithProvider(twitterProvider);
  //   // }
  // }

  /**
   * https://timerbell-3a4af.firebaseapp.com/__/auth/handler
   */
  Future<Map> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');

    // if (kIsWeb) {
    //   // Once signed in, return the UserCredential
    //   await auth.signInWithPopup(appleProvider);
    // } else {
    try {
      EasyLoadingManager.getInstance().showLoading();

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

      // EasyLoadingManager.getInstance().
      String email = userCredential.user?.email ?? "";
      String displayName = userCredential.user?.displayName ?? "";

      return {
        "email": email,
        "name": displayName,
        // "id": id,
        // "avatar": photoUrl
      };
    } catch (e) {
      print(e);
      EasyLoadingManager.getInstance().hideLoading();
      return {};
    }
    // }
  }

  // Future<UserCredential> signInWithFacebook() async {
  // Future<Map> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final FBinterface.LoginResult loginResult = await FacebookAuth.instance.login(
  //       // permissions: ['email', 'public_profile']
  //       permissions: ['email']
  //   );
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   final userData = await FacebookAuth.instance.getUserData();
  //
  //   String userEmail = userData['email'];
  //   String name = userData['name'];
  //   String id = userData['id'];
  //   String picture = userData?['picture']?['data']?['url'];
  //   // UserCredential UserCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   return {"email": userEmail, "name": name, "id": id, "avatar": picture};
  //   // Once signed in, return the UserCredential
  // }

  signout() async {
    await FirebaseAuth.instance.signOut();
    // userEmail = "";
    // await FacebookAuth.instance.logOut();
    await GoogleSignIn().signOut();

    // _googleSignIn.disconnect();
  }
}

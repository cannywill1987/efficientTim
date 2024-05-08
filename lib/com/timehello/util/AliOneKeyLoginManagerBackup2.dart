// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_ali_auth/flutter_ali_auth.dart';
// import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
//
// import '../../r.dart';
// import 'beans/BaseBean.dart';
// import 'common/database/apis/MongoApisManager.dart';
// import 'common/httpclient/HttpManager.dart';
// import 'config/Params.dart';
// import 'ScreenUtility/Utility.dart';
//
// class AliOneKeyLoginManager {
//   static AliOneKeyLoginManager? instance;
//   Function? resultListener;
//   bool isRequesting = false;
//
//   static AliOneKeyLoginManager getInstance() {
//     if (instance == null) {
//       instance = AliOneKeyLoginManager();
//       instance?.init();
//     }
//     return instance!;
//   }
//
//   init() async {
//     String aliAuthVersion;
//
//     /// 传入回调函数 onEvent
//     AliAuthClient.handleEvent(onEvent: (AuthResponseModel event) async {
//       if (resultListener != null && event.resultCode == "600000") {
//         this.resultListener!(event, true);
//       }
//       // else if (event.resultCode == "600001") {
//       //   // 成功唤起授权页
//       // }
//       // else if(event.resultCode == "700000") { // 点击了授权返回按钮
//       //
//       // }
//       else {
//         if (isRequesting == true) {
//           return;
//         }
//         isRequesting = true;
//         this.setIsRequesting();
//         this.resultListener!(event, false);
//         // this.resultListener!(event, false);
//       }
//     });
//
//     /// 初始化前需要须对插件进行监听
//     // await AliAuthClient.initSdk(
//     //   authConfig: AuthConfig(
//     //       iosSdk:
//     //       'GYrJb4NADCk3Vgn2gV1c+Xr4qQ9HqdhbBBiLElhevdBBvb69W5bRsSzJROXUhugd2F5fzhmDUZn1Z3MhXuVPQ2B2el6Yfx89Z5Nll63sQL4jb81hVhSuqwmVdYsXH798tIeq1XB3HqLUHTS1GblhCsnRm8JgXJ7yH4f9F1QbQSJc0+CnusoUaBBtCHJ4/Prn26pMhfCHKumEiL4MJLEbFbKpBtTg1iG0ijgc+1stVKa2Jy2G47n2fOUA2aMj1mvkmAw4sceDyo4Yz9ElZBNV/w==',
//     //       androidSdk:
//     //       '9FAGcChOIXzmSegMVFgKHNUuymGdqCa9mHuoNPk63HoGwWyxZBLblYNOIQV1p4TGGCEoMP9r+cyyU3Z9KCW7I1HJNt6Bw1sBdRfVrnTmkZYWbFbshbfJ/unckBMcG/jRuhCQMxRSd95meVxi1UtmBGSZjjrdUfKnz2hQawXmJ2j6TByC5Lw7/XsamR/sqa5/b/QZ/EjTSLSYSV4avvUQmiwZeo+7F8GeyBQhlbpIu0FJvGDQH/cP0tg0Pooaz2UyCMZ1L1vyHIoZqx66JX7kruhJdZe0DzV1mVC6/+SATKqp2f0X9LDlcWSz7UUX5BQS',
//     //       authUIStyle: AuthUIStyle.alert,
//     //       // authUIConfig: AlertUIConfig(logoConfig:LogoConfig(logoImage: R.assetsImgIcCircleLogo), alertContentViewColor: "#ff8800", sloganConfig: SloganConfig(sloganText: "来吧", sloganTextColor: "#ff8800"),),
//     //       authUIConfig: FullScreenUIConfig(backgroundImage: R.assetsImgBgOnekeyLogin, logoConfig:LogoConfig(logoImage: R.assetsImgIcCircleLogo), backgroundColor: Colors.pinkAccent.toHex(), sloganConfig: SloganConfig(sloganText: "来吧", sloganTextColor: Colors.black.toHex()),),
//     //       // Utility.getFamousSentence()
//     //       enableLog: true),
//     // );
//     // if (!mounted) return;
//     // setState(() {
//     //   _aliAuthVersion = aliAuthVersion;
//     // });
//   }
//
//   // 3.一键登录获取Token (login) #
//   // 调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token,可选参数为Timeout,默认5s
//   // 调用此接口后会通过之前注册的监听中回调信息
//   login() async {
//     /// 初始化前需要须对插件进行监听
//     await AliAuthClient.initSdk(
//       authConfig: AuthConfig(
//           iosSdk:
//           'GYrJb4NADCk3Vgn2gV1c+Xr4qQ9HqdhbBBiLElhevdBBvb69W5bRsSzJROXUhugd2F5fzhmDUZn1Z3MhXuVPQ2B2el6Yfx89Z5Nll63sQL4jb81hVhSuqwmVdYsXH798tIeq1XB3HqLUHTS1GblhCsnRm8JgXJ7yH4f9F1QbQSJc0+CnusoUaBBtCHJ4/Prn26pMhfCHKumEiL4MJLEbFbKpBtTg1iG0ijgc+1stVKa2Jy2G47n2fOUA2aMj1mvkmAw4sceDyo4Yz9ElZBNV/w==',
//           androidSdk:
//           '9FAGcChOIXzmSegMVFgKHNUuymGdqCa9mHuoNPk63HoGwWyxZBLblYNOIQV1p4TGGCEoMP9r+cyyU3Z9KCW7I1HJNt6Bw1sBdRfVrnTmkZYWbFbshbfJ/unckBMcG/jRuhCQMxRSd95meVxi1UtmBGSZjjrdUfKnz2hQawXmJ2j6TByC5Lw7/XsamR/sqa5/b/QZ/EjTSLSYSV4avvUQmiwZeo+7F8GeyBQhlbpIu0FJvGDQH/cP0tg0Pooaz2UyCMZ1L1vyHIoZqx66JX7kruhJdZe0DzV1mVC6/+SATKqp2f0X9LDlcWSz7UUX5BQS',
//           authUIStyle: AuthUIStyle.alert,
//           // authUIConfig: AlertUIConfig(logoConfig:LogoConfig(logoImage: R.assetsImgIcCircleLogo), alertContentViewColor: "#ff8800", sloganConfig: SloganConfig(sloganText: "来吧", sloganTextColor: "#ff8800"),),
//           authUIConfig: FullScreenUIConfig(backgroundImage: R.assetsImgBgOnekeyLogin, privacyConfig: PrivacyConfig(privacyOneUrl: Utility.getPrivacyProtocolUrl()),checkBoxConfig: CheckBoxConfig(checkBoxIsHidden: false,checkBoxIsChecked: !Utility.isHuaWei()), logoConfig:LogoConfig(logoImage: R.assetsImgIcCircleLogo), backgroundColor: Colors.pinkAccent.toHex(), sloganConfig: SloganConfig(sloganText: "来吧", sloganTextColor: Colors.black.toHex()),),
//           // Utility.getFamousSentence()
//           enableLog: true),
//     );
// // 一键登陆 需要用try-catch[PlatformException]捕获插件返回的异常
//     /// 无返回内容,调用之后，会在[handleEvent]的[onEvent]返回回调
//     await AliAuthClient.login();
//   }
//
//   hideLoginLoading() async {
//     /// 关闭授权页loading
//     await AliAuthClient.hideLoginLoading();
//   }
//
//   quitLoginPage() async {
//     /// 退出授权认证页
//     await AliAuthClient.quitLoginPage();
//   }
//
//   void setResultListener(
//       Future<Null> Function(AuthResponseModel event, bool isSuccess) param0) {
//     this.resultListener = param0;
//   }
//
//   void setIsRequesting() {
//     Future.delayed(Duration(seconds: 5), () {
//       isRequesting = false;
//     });
//   }
//
// }
//
// extension HexColor on Color {
//   String toHex() {
//     return '#${(0xFFFFFF & value).toRadixString(16).padLeft(6, '0')}';
//   }
// }
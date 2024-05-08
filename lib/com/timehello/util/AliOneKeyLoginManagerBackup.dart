// import 'dart:ui';
//
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:time_hello/com/timehello/models/lib/ali_auth.dart';
// import 'package:flutter_ali_auth/flutter_ali_auth.dart';
// import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
//
// import '../../../r.dart';
// import '../beans/BaseBean.dart';
// import '../common/database/apis/MongoApisManager.dart';
// import '../common/httpclient/HttpManager.dart';
// import '../config/Params.dart';
// import '../page/loginPage/LoginPage.dart';
// import 'Utility.dart';
//
// class AliOneKeyLoginManager {
//   static AliOneKeyLoginManager? instance;
//   Function? resultListener;
//   bool isRequesting = false;
//   /// 比例
//   late int unit;
//
//   String status = "初始化中...";
//
//   late CustomThirdView customThirdView;
//
//   /// Android 密钥
//   late String androidSk;
//
//   /// iOS 密钥
//   late String iosSk;
//
//   /// 弹窗宽度
//   late int dialogWidth;
//
//   /// 弹窗高度
//   late int dialogHeight;
//
//
//   /// 按钮高度
//   late int logBtnHeight;
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
//
//     /// 初始化第三方按钮数据
//     androidSk =
//     "9FAGcChOIXzmSegMVFgKHNUuymGdqCa9mHuoNPk63HoGwWyxZBLblYNOIQV1p4TGGCEoMP9r+cyyU3Z9KCW7I1HJNt6Bw1sBdRfVrnTmkZYWbFbshbfJ/unckBMcG/jRuhCQMxRSd95meVxi1UtmBGSZjjrdUfKnz2hQawXmJ2j6TByC5Lw7/XsamR/sqa5/b/QZ/EjTSLSYSV4avvUQmiwZeo+7F8GeyBQhlbpIu0FJvGDQH/cP0tg0Pooaz2UyCMZ1L1vyHIoZqx66JX7kruhJdZe0DzV1mVC6/+SATKqp2f0X9LDlcWSz7UUX5BQS";
//     iosSk =
//     "GYrJb4NADCk3Vgn2gV1c+Xr4qQ9HqdhbBBiLElhevdBBvb69W5bRsSzJROXUhugd2F5fzhmDUZn1Z3MhXuVPQ2B2el6Yfx89Z5Nll63sQL4jb81hVhSuqwmVdYsXH798tIeq1XB3HqLUHTS1GblhCsnRm8JgXJ7yH4f9F1QbQSJc0+CnusoUaBBtCHJ4/Prn26pMhfCHKumEiL4MJLEbFbKpBtTg1iG0ijgc+1stVKa2Jy2G47n2fOUA2aMj1mvkmAw4sceDyo4Yz9ElZBNV/w==";
//
//     dialogWidth =
//         (window.physicalSize.width / window.devicePixelRatio * 0.8).floor();
//     dialogHeight =
//         (window.physicalSize.height / window.devicePixelRatio * 0.65)
//             .floor() -
//             50;
//     unit = dialogHeight ~/ 10;
//     logBtnHeight = (unit * 1.1).floor();
//
//     // Map<String, dynamic> configMap = {
//     //   "width": -1,
//     //   "height": -1,
//     //   "top": unit * 10 + 80,
//     //   "space": 20,
//     //   "size": 20,
//     //   'itemWidth': 50,
//     //   'itemHeight': 50,
//     //   // "viewItemName": ["支付宝", "淘宝", "微博"],
//     //   "viewItemPath": [
//     //     // "assets/alipay.png",
//     //     // "assets/taobao.png",
//     //     // "assets/sina.png"
//     //   ]
//     // };
//     // customThirdView = CustomThirdView.fromJson(configMap);
//
//
//     //     /// 传入回调函数 onEvent
//     // AliAuthClient.handleEvent(onEvent: (AuthResponseModel event) async {
//     //   if (resultListener != null && event.resultCode == "600000") {
//     //     this.resultListener!(event, true);
//     //   }
//     //   // else if (event.resultCode == "600001") {
//     //   //   // 成功唤起授权页
//     //   // }
//     //   // else if(event.resultCode == "700000") { // 点击了授权返回按钮
//     //   //
//     //   // }
//     //   else {
//     //     if (isRequesting == true) {
//     //       return;
//     //     }
//     //     isRequesting = true;
//     //     this.setIsRequesting();
//     //     this.resultListener!(event, false);
//     //     // this.resultListener!(event, false);
//     //   }
//     // });
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
//
//     /// 初始化前需要须对插件进行监听
//     await AliAuthClient.initSdk(
//       authConfig: AuthConfig(
//           iosSdk:
//           'l1YRFweXMs92NU7cuQWCc+1+maAl8U78Ymqd5UEwgpfHNn7KlGDWjA2FD6ouL00ZaXE0gkNp2hyY1F27/7NjNIj6CDPVD+pZK0TF14pqpo4cAQ2mVGnfPjn0kFS12+0ZqXaDMFcR2ajqxGgM4fjzhB3NQoO9ytQbk8zPwnNFy8WigUqHT20Wvle3T5td1bsdQbjELF0gIOXUScsi5wIXt6uhUqjab6D6/GieS7w/IytTEkX7IIIi1tke8pw2A7v7Xz4QR0WH7zIvcbNWxaLpng==',
//           androidSdk:
//           '9FAGcChOIXzmSegMVFgKHNUuymGdqCa9mHuoNPk63HoGwWyxZBLblYNOIQV1p4TGGCEoMP9r+cyyU3Z9KCW7I1HJNt6Bw1sBdRfVrnTmkZYWbFbshbfJ/unckBMcG/jRuhCQMxRSd95meVxi1UtmBGSZjjrdUfKnz2hQawXmJ2j6TByC5Lw7/XsamR/sqa5/b/QZ/EjTSLSYSV4avvUQmiwZeo+7F8GeyBQhlbpIu0FJvGDQH/cP0tg0Pooaz2UyCMZ1L1vyHIoZqx66JX7kruhJdZe0DzV1mVC6/+SATKqp2f0X9LDlcWSz7UUX5BQS',
//           authUIStyle: AuthUIStyle.alert,
//           // authUIConfig: AlertUIConfig(logoConfig:LogoConfig(logoImage: R.assetsImgIcCircleLogo), alertContentViewColor: "#ff8800", sloganConfig: SloganConfig(sloganText: "来吧", sloganTextColor: "#ff8800"),),
//           authUIConfig: FullScreenUIConfig(backgroundImage: R.assetsImgBgOnekeyLogin, logoConfig:LogoConfig(logoImage: R.assetsImgIcCircleLogo), backgroundColor: Colors.pinkAccent.toHex(), sloganConfig: SloganConfig(sloganText: "来吧", sloganTextColor: Colors.black.toHex()),),
//           // Utility.getFamousSentence()
//           enableLog: true),
//     );
//     // if (!mounted) return;
//     // setState(() {
//     //   _aliAuthVersion = aliAuthVersion;
//     // });
//   }
//
//   // 3.一键登录获取Token (login) #
//   // 调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token,可选参数为Timeout,默认5s
//   // 调用此接口后会通过之前注册的监听中回调信息
//   login(BuildContext context) async {
//     login() async {
// // 一键登陆 需要用try-catch[PlatformException]捕获插件返回的异常
//       /// 无返回内容,调用之后，会在[handleEvent]的[onEvent]返回回调
//
//       try {
//         if (Utility.isAndroid() == true) {
//           await initSdk();
//           var res = await AliAuth.login();
//           print(res);
//         }
//         if (Utility.isIOS() == true) {
//           await initSdk();
//           var res = await AliAuth.login();
//           print(res);
//           //   await AliAuth.appleLogin;
//         }
//         else {
//           Utility.pushNavigator(context, new LoginPage(), callback: (res) {
//             // this.requestDatas();
//           });
//         }
//       } catch(e) {
//         print(e);
//       }
//       await AliAuthClient.login();
//     }
//
//     Future<void> initSdk() async {
//       AliAuth.loginListen(
//         onEvent: (onEvent) {
//           if(resultListener != null && onEvent["code"] == "600000") { //取消登录
//             this.resultListener!(onEvent, true);
//           }
//           else if(onEvent["code"] == "600024") { //"msg" -> "终端环境检查⽀持认证"
//             this.resultListener!(onEvent, false);
//           }
//           else if(onEvent["code"] == "600001") { //唤起授权页成功
//             this.resultListener!(onEvent, false);
//           }else if(onEvent["code"] == "500004") { //唤起授权页成功
//             this.resultListener!(onEvent, false);
//           }
//           // else if(onEvent["code"] == "700000") { //取消登录
//           //
//           // }
//           else {
//             if (isRequesting == true) {
//               return;
//             }
//             isRequesting = true;
//             // dispose();
//             this.setIsRequesting();
//             this.resultListener!(onEvent, false);
//           }
//         },
//       );
//
//       /// 初始化前需要须对插件进行监听
//       await AliAuth.initSdk(
//           getFullPortVideoConfig()
//       );
//       hideLoginLoading() async {
//         /// 关闭授权页loading
//         await AliAuthClient.hideLoginLoading();
//       }
//
//       dispose() {
//         AliAuth.dispose();
//         quitLoginPage() async {
//           /// 退出授权认证页
//           await AliAuthClient.quitLoginPage();
//         }
//
//         // hideLoginLoading() async {
//         //   /// 关闭授权页loading
//         //   await AliAuthClient.hideLoginLoading();
//         // }
//         //
//         // quitLoginPage() async {
//         //   /// 退出授权认证页
//         //   await AliAuthClient.quitLoginPage();
//         // }
//
//         void setResultListener(
//             Future<Null> Function(dynamic event, bool isSuccess) param0) {
//           Future<Null> Function(AuthResponseModel event, bool isSuccess) param0) {
//           this.resultListener = param0;
//           }
//
//           void setIsRequesting() {
//           Future.delayed(Duration(seconds: 5), () {
//           isRequesting = false;
//           });
//           }
//
//           /// 全屏视频背景
//           AliAuthModel getFullPortVideoConfig({bool isDelay = false}) {
//           /// 开启Gif、Video背景时建议隐藏nav
//           /// navHidden(true)
//           /// logoHidden(true)
//           /// sloganHidden(true)
//           /// webViewStatusBarColor(Color.TRANSPARENT)
//           /// statusBarColor(Color.TRANSPARENT)
//           /// statusBarUIFlag(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
//           Map<String, dynamic> configMap = {
//           'top': 40,
//           'left': 20,
//           'width': 40,
//           'height': 40,
//           'imgPath': "assets/return_btn_filll.png"
//           };
//           CustomView customReturnBtn = CustomView.fromJson(configMap);
//           return AliAuthModel(androidSk, iosSk,
//           isDebug: Params.isDebug,
//           isDelay: false,
//           pageType: Utility.isAndroid() ? PageType.customGif : PageType.dialogBottom,
//           // pageType: PageType.customMOV,
//           // pageType: PageType.customMOV,
//           statusBarColor: "#00026ED2",
//           bottomNavColor: "#000000",
//           isLightColor: true,
//           statusBarUIFlag: UIFAG.systemUiFalgLayoutFullscreen,
//           navHidden: true,
//           logoHidden: true,
//           numberColor: "#ffffff",
//           numberSize: 28,
//           switchAccHidden: true,
//           switchAccTextColor: "#FDFDFD",
//           logBtnText: getI18NKey().one_key_login,
//           logBtnTextSize: 16,
//           logBtnTextColor: "#FFFFFF",
//           // protocolOneName: "《通达理》",
//           // protocolOneURL: "https://tunderly.com",
//           // protocolTwoName: "《思预云》",
//           // protocolTwoURL: "https://jokui.com",
//           // protocolThreeName: "《思预云APP》",
//           // protocolThreeURL:
//           // "https://a.app.qq.com/o/simple.jsp?pkgname=com.civiccloud.master&fromcase=40002",
//           protocolCustomColor: "#F3F3F3",
//           protocolColor: "#dddddd",
//           protocolLayoutGravity: Gravity.centerHorizntal,
//           logBtnBackgroundPath: "${R.assetsImgLoginBtnNormal},${R.assetsImgLoginBtnUnable},${R.assetsImgLoginBtnPress}",
//           // "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
//           loadingImgPath: "authsdk_waiting_icon",
//           numFieldOffsetY: unit * 8,
//           numberLayoutGravity: Gravity.centerHorizntal,
//           switchOffsetY: -1,
//           switchOffsetY_B: -1,
//           logBtnOffsetY: unit * 10,
//           logBtnOffsetY_B: -1,
//           logBtnWidth: 300,
//           logBtnHeight: 51,
//           logBtnOffsetX: 0,
//           logBtnMarginLeftAndRight: 28,
//           logBtnLayoutGravity: Gravity.centerHorizntal,
//           privacyOffsetX: -1,
//           privacyOffsetY: -1,
//           privacyOffsetY_B: 28,
//           checkBoxWidth: 18,
//           checkBoxHeight: 18,
//           checkboxHidden: false,
//           navTextSize: 18,
//           switchAccTextSize: 16,
//           switchAccText: getI18NKey().other_login_mode,
//           sloganHidden: true,
//           uncheckedImgPath: R.assetsImgBtnUnchecked,
//           checkedImgPath: R.assetsImgBtnChecked,
//           privacyState: false,
//           protocolGravity: Gravity.centerHorizntal,
//           privacyTextSize: 12,
//           privacyMargin: 28,
//           privacyBefore: "",
//           privacyEnd: "",
//           vendorPrivacyPrefix: "",
//           vendorPrivacySuffix: "",
//           dialogWidth: -1,
//           dialogHeight: -1,
//           dialogBottom: false,
//           dialogOffsetX: 0,
//           dialogOffsetY: 0,
//           pageBackgroundPath: R.assetsImgBgLogin,
//           // webViewStatusBarColor: "#026ED2",
//           // webNavColor: "#FF00FF",
//           // webNavTextColor: "#F0F0F8",
//           // webNavTextSize: -1,
//           webNavReturnImgPath:R.assetsImgBgLogin,
//           webSupportedJavascript: true,
//           authPageActIn: "in_activity",
//           activityOut: "out_activity",
//           authPageActOut: "in_activity",
//           activityIn: "out_activity",
//           screenOrientation: -1,
//           logBtnToastHidden: false,
//           dialogAlpha: 1.0,
//           privacyOperatorIndex: 0,
//           /**
//            * "assets/background_gif.gif"
//            * "assets/background_gif1.gif"
//            * "assets/background_gif2.gif"
//            * "assets/background_image.jpeg"
//            * "assets/background_video.mp4"
//            *
//            * "https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-7/20187232061776607.gif"
//            * "https://img.zcool.cn/community/01dda35912d7a3a801216a3e3675b3.gif",
//            */
//           backgroundPath: R.assetsImgBgLogin,
//           // customThirdView: customThirdView,
//           customReturnBtn: customReturnBtn);
//           }
//         }
//
//         extension HexColor on Color {
//           String toHex() {
//             return '#${(0xFFFFFF & value).toRadixString(16).padLeft(6, '0')}';
//           }
//         }
//

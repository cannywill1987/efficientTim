//
// import 'package:flutter/cupertino.dart';
// import 'package:sharesdk_plugin/sharesdk_defines.dart';
// import 'package:sharesdk_plugin/sharesdk_interface.dart';
// import 'package:sharesdk_plugin/sharesdk_map.dart';
//
// /**
//  * https://www.mob.com/wiki/detailed?wiki=31&id=14
//  */
// class ShareSdkManagement {
//   static ShareSdkManagement? mShareSdkManagement;
//   ShareSdkManagement();
//
//   static ShareSdkManagement getInstance() {
//     if (mShareSdkManagement == null) {
//       mShareSdkManagement = new ShareSdkManagement();
//     }
//     return mShareSdkManagement!;
//   }
//
//   init() {
//     return mShareSdkManagement;
//   }
//
//
//   /**
//    * 授权（auth）
//    */
//   static shareAuthWechat(BuildContext context) {
//       // SharesdkPlugin.auth(
//       //     ShareSDKPlatforms.wechatSession, {}, (SSDKResponseState, dynamic, SSDKError) => {
//       //   // showAlert(state, user != null ? user : error.rawData, context);
//       // });
//   }
//
//   /**
//    * 获取用户信息（getUserInfo）
//    */
//   static void getUserInfoToWechat(BuildContext context) {
//     // SharesdkPlugin.getUserInfo(
//     //     ShareSDKPlatforms.wechatSession, (SSDKResponseState, dynamic, SSDKError) {
//     //   // showAlert(state, user != null ? user : error.rawData, context);
//     // });
//   }
//
//   static shareWechat() {
//     SSDKMap params = SSDKMap()
//       ..setGeneral(
//           "title",
//           "text",
//           ["http://wx3.sinaimg.cn/large/006nLajtly1fpi9ikmj1kj30dw0dwwfq.jpg"],
//           "http://wx3.sinaimg.cn/large/006nLajtly1fpi9ikmj1kj30dw0dwwfq.jpg",
//           "",
//           "http://www.mob.com/",
//           "http://wx4.sinaimg.cn/large/006WfoFPly1fw9612f17sj30dw0dwgnd.jpg",
//           "http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT",
//           "http://f1.webshare.mob.com/dvideo/demovideos.mp4",
//           "",
//           SSDKContentTypes.webpage);
//     SharesdkPlugin.showMenu(null, null, params, (SSDKResponseState state,
//         ShareSDKPlatform platform,
//         dynamic userData,
//         dynamic contentEntity,
//         SSDKError error) {
//       // showAlert(state, error.rawData, context);
//     });
//   }
//   static shareQQ() {
//     SSDKMap params = SSDKMap()
//       ..setQQ(
//           "text",
//           "title",
//           "http://m.93lj.com/sharelink?mobid=ziqMNf",
//           "",
//           "",
//           "",
//           "",
//           "",
//           "http://wx4.sinaimg.cn/large/006tkBCzly1fy8hfqdoy6j30dw0dw759.jpg",
//           "",
//           "",
//           "http://m.93lj.com/sharelink?mobid=ziqMNf",
//           "",
//           "",
//           SSDKContentTypes.webpage,
//           ShareSDKPlatforms.qq);
//     SharesdkPlugin.share(ShareSDKPlatforms.qq, params, (SSDKResponseState state,
//         dynamic userdata, dynamic contentEntity, SSDKError error) {
//       // showAlert(state, error.rawData, context);
//     });
//   }
//
// }

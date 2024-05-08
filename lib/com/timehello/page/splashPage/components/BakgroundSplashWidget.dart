// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:time_hello/com/timehello/config/Params.dart';
// import 'package:time_hello/r.dart';
//
// /**
//  * 用不上了
//  */
// class BakgroundSplashWidget extends StatefulWidget {
//   String sec;
//   String min;
//
//   BakgroundSplashWidget({this.sec = "00", this.min = "00"});
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return BakgroundState();
//   }
// }
//
// class BakgroundState extends State<BakgroundSplashWidget>
//     with TickerProviderStateMixin {
//   Animation<double>? animationTree;
//   AnimationController? controllerTree;
//
//   Animation<double>? animationShootingStar1;
//   AnimationController? controllerShootingStar1;
//
//   Animation<double>? animationShootingStar1Opacity;
//   Animation? controllerShootingStar1Opacity;
//
//   Animation<double>? animationCloud1;
//   AnimationController? controllerCloud1;
//
//   Animation<double>? animationCloud2;
//   AnimationController? controllerCloud2;
//
//   Animation<double>? animationCloud3;
//   AnimationController? controllerCloud3;
//
//
//
//
//   double cloud1X = 0.3;
//   double cloud1Y = -0.6;
//
//   double cloud2X = -0.8;
//   double cloud2Y = -0.3;
//
//   double cloud3X = 0.9;
//   double cloud3Y = -0.35;
//
//   initState() {
//     super.initState();
//       // startTreeAinm();
//       // startCloud1();
//       // startCloud2();
//       // startCloud3();
//   }
//
//   startTreeAinm() {
//     controllerTree = new AnimationController(
//         animationBehavior: AnimationBehavior.preserve,
//         duration: const Duration(milliseconds: 2000),
//         reverseDuration: const Duration(milliseconds: 2000),
//         vsync: this);
//     animationTree = new Tween(begin: 0.0, end: 0.05).animate(controllerTree!)
//       ..addListener(() {
//         setState(() {
//           // the state that has changed here is the animation object’s value
//         });
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controllerTree?.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controllerTree?.forward();
//         }
//       });
//     controllerTree?.forward();
//   }
//
//   //月亮的白云
//   startCloud1() {
//     controllerCloud1= new AnimationController(
//         animationBehavior: AnimationBehavior.preserve,
//         duration: const Duration(milliseconds: 14000),
//         reverseDuration: const Duration(milliseconds: 14000),
//         vsync: this);
//     animationCloud1 = new Tween(begin: cloud1X, end: cloud1X + 0.6).animate(controllerCloud1!)
//       ..addListener(() {
//         // setState(() {
//         //   // the state that has changed here is the animation object’s value
//         // });
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controllerCloud1?.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controllerCloud1?.forward();
//         }
//       });
//     controllerCloud1?.forward();
//   }
//
//   //左边的白云
//   startCloud2() {
//     controllerCloud2= new AnimationController(
//         animationBehavior: AnimationBehavior.preserve,
//         duration: const Duration(milliseconds: 14000),
//         reverseDuration: const Duration(milliseconds: 14000),
//         vsync: this);
//     animationCloud2 = new Tween(begin: cloud2X, end: cloud2X + 0.3).animate(controllerCloud2!)
//       ..addListener(() {
//         // setState(() {
//         //   // the state that has changed here is the animation object’s value
//         // });
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controllerCloud2?.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controllerCloud2?.forward();
//         }
//       });
//     controllerCloud2?.forward();
//   }
//
//   //右边的白云
//   startCloud3() {
//     controllerCloud3= new AnimationController(
//         animationBehavior: AnimationBehavior.preserve,
//         duration: const Duration(milliseconds: 14000),
//         reverseDuration: const Duration(milliseconds: 14000),
//         vsync: this);
//     animationCloud3 = new Tween(begin: cloud3X, end: cloud3X + 0.2).animate(controllerCloud3!)
//       ..addListener(() {
//         // setState(() {
//         //   // the state that has changed here is the animation object’s value
//         // });
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controllerCloud3?.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controllerCloud3?.forward();
//         }
//       });
//     controllerCloud3?.forward();
//   }
//
//   startShootingStarsAinm() {
//     controllerShootingStar1 = new AnimationController(
//         animationBehavior: AnimationBehavior.preserve,
//         duration: const Duration(milliseconds: 2000),
//         reverseDuration: const Duration(milliseconds: 2000),
//         vsync: this);
//     animationShootingStar1 = new Tween(begin: 0.0, end: 0.05).animate(controllerShootingStar1!)
//       ..addListener(() {
//         setState(() {
//           // the state that has changed here is the animation object’s value
//         });
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controllerShootingStar1?.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controllerShootingStar1?.forward();
//         }
//       });
//     controllerShootingStar1?.forward();
//
//     // animationShootingStar1Opacity = new AnimationController(
//     //     animationBehavior: AnimationBehavior.preserve,
//     //     duration: const Duration(milliseconds: 2000),
//     //     reverseDuration: const Duration(milliseconds: 2000),
//     //     vsync: this);
//     // controllerShootingStar1Opacity = new Tween(begin: 0.0, end: 1.0)?.animate(animationShootingStar1Opacity!)
//     //   ?..addListener(() {
//     //     setState(() {
//     //       // the state that has changed here is the animation object’s value
//     //     });
//     //   })
//     //   ..addStatusListener((status) {
//     //     if (status == AnimationStatus.completed) {
//     //     //   controllerShootingStar1Opacity?.reverse();
//     //     // } else if (status == AnimationStatus.dismissed) {
//     //     //   controllerShootingStar1Opacity?.forward();
//     //     // }
//     //   });
//     // controllerShootingStar1Opacity?.forward();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     // 资源释放
//     if(controllerCloud3 != null)
//      controllerCloud3?.dispose();
//     if(controllerCloud2 != null)
//     controllerCloud2?.dispose();
//     if(controllerCloud1 != null)
//     controllerCloud1?.dispose();
//     if(controllerShootingStar1 != null)
//     controllerShootingStar1?.dispose();
//     if(controllerTree != null)
//     controllerTree?.dispose();
//     // if(animationTree != null)
//     // animationTree?.removeListener();
//     // if(animationCloud1 != null)
//     // animationCloud1?.removeListener();
//     // if(animationCloud2 != null)
//     // animationCloud2?.removeListener();
//     // if(animationCloud3 != null)
//     // animationCloud3?.removeListener();
//     // if(animationShootingStar1 != null)
//     //   animationShootingStar1?.removeListener(null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Stack(
//       // return new Image.asset(this.widget.checked?this.widget.checkedImg:this.widget.unckeckedImg, width: this.widget.width, height: this.widget.height,fit: BoxFit.cover,)
//       children: [
//         Container(color: Colors.black),
//         Align(
//             alignment: Alignment(0.7, -1),
//             child: Image.asset(R.assetsImgBgStars, fit: BoxFit.fill)),
//         Align(
//             alignment: Alignment(0.0, -0.1),
//             child: Image.asset(R.assetsImgBgCircle, width: 380, height: 380)),
//         //中间的大圈
//         Align(
//             alignment: Alignment(0.26, -0.4),
//             child:
//             Image.asset(R.assetsImgBgCircleLight, width: 50, height: 50)),
//         //中间的大圈的光
//         Align(
//             alignment: Alignment(0.42, -0.3),
//             child: Image.asset(R.assetsImgBgLightCircleDot,
//                 width: 10, height: 10)),
//         //中间的大圈的光
//         Align(
//             alignment: Alignment(0.9, -.75),
//             child: Image.asset(R.assetsImgIcMoon, width: 100, height: 100)),
//         //月亮
//         Align(
//             alignment: Alignment(animationCloud1 != null ? (animationCloud1?.value ?? 0) : cloud1X, cloud1Y),
//             child: Image.asset(R.assetsImgIcCloud1, width: 100, height: 100)),
//         //月亮的白云
//         Align(
//             alignment: Alignment(animationCloud2 != null ? (animationCloud2?.value ?? 0) : cloud2X, cloud2Y),
//             child: Image.asset(R.assetsImgIcCloud2, width: 70, height: 100)),
//         //左边的白云
//         Align(
//             alignment: Alignment(animationCloud3 != null ? (animationCloud3?.value ?? 0) : cloud3X, cloud3Y),
//             child: Image.asset(R.assetsImgIcCloud3, width: 50, height: 50)),
//         //右边的百源
//         Align(
//             alignment: Alignment(0.7, -.15),
//             child: Image.asset(R.assetsImgIcBird, width: 50, height: 50)),
//         //右边的百源
//         Align(
//             alignment: Alignment(-0.6, .15),
//             child: Image.asset(R.assetsImgIcBird, width: 50, height: 50)),
//         //右边的百源
//         Align(
//             alignment: Alignment(-0.9, -.85),
//               child: Image.asset(R.assetsImgIcShootingstar1,
//                 width: 300, height: 300)),
//         //流星
//         Align(
//             alignment: Alignment(-0.9, -1.2),
//             child: Image.asset(R.assetsImgIcShootingstar2,
//                 width: 150, height: 300)),
//         //流星
//         Align(
//             alignment: Alignment(-1.4, -0.9),
//             child: Image.asset(R.assetsImgIcShootingstar3,
//                 width: 150, height: 300)),
//         //流星
//         Align(
//             alignment: Alignment(-0.4, -1.4),
//             child: Image.asset(R.assetsImgIcShootingstar3,
//                 width: 150, height: 300, color: Color(0x91ffffff))),
//         //流星
//         Align(
//             alignment: Alignment(
//                 -0.0, animationTree != null ? animationTree?.value  ?? 0 : 0.0),
//             child: Image.asset(R.assetsImgIcTree, width: 150, height: 300)), //树
//         //树
//         Align(
//             alignment: Alignment(
//                 -0.0, animationTree != null ? animationTree?.value ?? 0  : 0.0),
//             child: Image.asset(R.assetsImgIcFlower, width: 130, height: 300)),
//         //树
//       ],
//     );
//   }
// }

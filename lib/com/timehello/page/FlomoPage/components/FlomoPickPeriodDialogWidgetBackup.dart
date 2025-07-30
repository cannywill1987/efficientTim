// import 'package:flutter/cupertino.dart';
// import 'package:time_hello/com/timehello/page/FlomoPage/components/FlomoCheckButtonListWidget.dart';
//
// import '../../../config/CONSTANTS.dart';
//
// class FlomoPickPeriodDialogWidget extends StatefulWidget {
//   Function? onChange;
//   double endTime = -1;
//   FlomoPickPeriodDialogWidget({Key? key,this.onChange}):super(key: key)
//
//   // State<StatefulWidget> createState() {
//   //   // TODO: implement createState
//   //   return FlomoPickPeriodDialogWidgetState(endTime: endTime);
//   // }
//
//
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return FlomoPickPeriodDialogWidgetState(endTime: this.endTime);
//   }}
//
// class FlomoPickPeriodDialogWidgetState extends State<FlomoPickPeriodDialogWidget> {
//   double marginTop = 20;
//   double endTime = -1;
//
//   FlomoPickPeriodDialogWidgetState({required this.endTime})
//
//   // Widget build(BuildContext context) {
//   //   // TODO: implement build
//   //
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     //圆角 白色背景 container
//     return Container(
//       decoration: BoxDecoration(
//           color: Color(0xffffffff),
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//       child: Column(children: [
//
//         SizedBox(height: marginTop,),
//         FlomoCheckButtonListWidget(list: CONSTANTS.getFlomoDurationButtonList(),
//             onTapListener: (e, endTime) async {
//               String code = e['data'].code;
//               bool isCheck = e['data'].isCheck;
//               this.endTime = endTime;
//               this.widget.onChange?.call(code, isCheck, endTime);
//             }),
//         SizedBox(height: marginTop,),
//         // 时间选择组件 返回hh:mm
//         Container(
//           margin: EdgeInsets.only(top: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "目标奖励一直",
//                 style: TextStyle(
//                     color: Color(0xff404040),
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "持续进行",
//                 style: TextStyle(
//                     color: Color(0xffFFA500),
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ],),
//     );
//   }}
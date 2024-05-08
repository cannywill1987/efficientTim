import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

class TitleDescWidget extends StatelessWidget{
  String? title;
  String? desc;
  double paddingTitle = 10;
  Color color = Color(0xf0404040);

  TitleDescWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      SizedBox(height: 20,),
      Padding(
          padding: EdgeInsets.only(left: this.paddingTitle),
          child: Text(this.title ?? "",
              style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: color), fontSize: 24))),
      Padding(
          padding: EdgeInsets.only(left: this.paddingTitle),
          child: Text(this.desc ?? "",
              style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: color, defaultDarkColor: Color(0xffa0a0a0)), fontSize: 18))),
      Center(
          child: Image.asset(R.assetsImgBgTomato,
              width: 150, height: 150)),
    ],);
  }

}
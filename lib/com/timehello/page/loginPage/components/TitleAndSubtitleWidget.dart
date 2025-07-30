import 'package:flutter/cupertino.dart';

class TitleAndSubtitleWidget extends StatelessWidget {
  String title;
  String subtitle;

  TitleAndSubtitleWidget({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      Text(this.title, style: TextStyle(color: Color(0xff404040), fontSize: 14),),
      Text(this.subtitle, style: TextStyle(color: Color(0xff999999), fontSize: 12),)
    ],);
  }

}

import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  double? iconSize;
  int? color;
  int icon;

  IconWidget({this.iconSize, this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Icon(
         IconData(icon ?? 0,
             fontFamily: 'MaterialIcons'), //标签
        color: Color(color ?? 0xffff8800),
        size: iconSize);
  }

}

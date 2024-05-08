import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

class GameBadgetWidget extends StatelessWidget {
  String title = "";
  Color? color = Color(0xd81e06);

  GameBadgetWidget({required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(width: 25, height: 25, child: Stack(children: [Utility.getSVGPicture(R.assetsImgBgBadge), Align(alignment: Alignment.center, child:Text(this.title, style: TextStyle(color: this.color, fontSize: 5, fontWeight: FontWeight.w700),))],),);
  }

}
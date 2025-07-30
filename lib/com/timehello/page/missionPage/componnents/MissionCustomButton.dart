import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class MissionCustomButton extends StatelessWidget {
  final double fontSize;
  final Color color;
  final String text;
  final Function onTapListener;
  MissionCustomButton({required this.onTapListener, required this.fontSize, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: (){
        this.onTapListener.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: color,
              width: 1,
            )),
        child: Text(
          this.text ?? "",
          style: TextStyle(color: this.color, fontSize: this.fontSize, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

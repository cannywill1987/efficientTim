import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';

class ClosedButton extends StatelessWidget {
  // , this.checkedImg, this.unckeckedImg
  OnTapListener onTapListener;

  ClosedButton({Key? key, required this.onTapListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        this.onTapListener(null);
      },
      // style: StylesConfig.transparentTextButtonStyleWithSize(Size(15, 15)),
      //   onPressed: () {
      //     this.onTapListener(null);
      //   },
      child: Container(
        alignment: Alignment.center,
        decoration: StylesConfig.getCloseButtonDecoration(),
        width: 15,
        height: 15,
        child: Icon(Icons.close,
            color: Colors.white, size: 12),
      ),
    );
  }
}

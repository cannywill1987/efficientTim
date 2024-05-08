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
    return TextButton(
      style: StylesConfig.transparentTextButtonStyleWithSize(Size(15, 15)),
        onPressed: () {
          this.onTapListener(null);
        },
      child: Container(
        decoration: StylesConfig.getCloseButtonDecoration(),
        width: 15,
        height: 15,
        child: Icon(Icons.close,
            color: Colors.white, size: 12),
      ),
    );
  }
}

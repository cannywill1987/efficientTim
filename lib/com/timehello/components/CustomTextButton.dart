import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/StylesConfig.dart';

class CustomTextButton extends StatelessWidget {
  late Widget child;
  late double width;
  late double height;
  Function onPressed;

  CustomTextButton(
      {required this.onPressed,
      required this.child,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        GestureDetector(
          // style: StylesConfig.transparentTextButtonStyleWithSize(Size(this.width, this.height)),
          onTap: () {
            this.onPressed();
          },
          child: Container(
            alignment: Alignment.center,
            width: this.width,
            height: this.height,
            child: this.child,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCloseButton extends StatelessWidget {
  Function onTapListener;
  double size;
  EdgeInsets? margin;
  CustomCloseButton({this.margin, required this.onTapListener, this.size: 12});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        onTapListener();
      },
      child: Container(
        width: size + 2,
          height: size + 2,
          // padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0xffe0e0e0),
          borderRadius: BorderRadius.circular(50),
        ),
        margin: margin,
        // width: size,
        child: Icon(CupertinoIcons.clear, size: size - 2),
      ),
    );
  }

}
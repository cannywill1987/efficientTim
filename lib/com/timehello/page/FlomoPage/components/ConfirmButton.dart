import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  bool isChecked = false;


  ConfirmButton({this.isChecked = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //一个20* 20的灰色圆环里面再嵌入一个15*15的灰色圆环
    return Container(
      padding: EdgeInsets.all(2),
      // constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xffdddddd)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
          constraints: BoxConstraints(maxWidth: 16, maxHeight: 16),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffdddddd)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: isChecked == false
              ? SizedBox(
                  width: 16,
                  height: 16,
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Color(0xff02a7b2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/ThemeManager.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final Function onPressed;
  String title = '';
  double fontSize = 13;
  double marginVertical = 0;
  CustomIconButton({required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: this.marginVertical),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: fontSize + 10,
        decoration:BoxDecoration(
            color: ThemeManager.getInstance().getLightDefaultThemeColor(),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          radius: 10,
          onTap: () {
            onPressed();
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              if (icon != null) icon!,
              SizedBox(
                width: 4,
              ),
              new Text(
                title ?? '',
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style:TextStyle(
                    color: ThemeManager.getInstance()
                        .getTextColor(defaultDarkColor: Color(0xffa0a0a0)),
                    fontSize: fontSize),
              )
            ],
          ),
        ));
  }
}
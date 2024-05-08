import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/WidgetManager.dart';

class CustomGameItemBackground extends StatelessWidget {
  Widget? decorationWidget;
  List<Widget> children;

  CustomGameItemBackground({this.decorationWidget, required this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        this.decorationWidget != null ? this.decorationWidget! : SizedBox.shrink(),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.green),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Row(mainAxisSize: MainAxisSize.min, children: this.children),
        )
      ],
    );
  }
}

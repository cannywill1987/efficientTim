import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class DescriptionWidget extends StatelessWidget {
  final String text;

  const DescriptionWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (TextUtil.isEmpty(text)) {
      return Container();
    } else {
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
         maxHeight: 120,
        ),
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: ThemeManager.getInstance()
                .getCardBackgroundColor(defaultColor: Color(0xfff5f5f5)),
            borderRadius: BorderRadius.circular(5)),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 14,
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Color(0xff666666))),
            ),
          ),
        ),
      );
    }
  }
}

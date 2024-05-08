import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class MissionDetailTitleContainerWidget extends StatelessWidget {
  String title;
  Widget child;

  MissionDetailTitleContainerWidget({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white), borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: [
              Container(
                width: 4,
                height: 15,
                decoration: BoxDecoration(
                    color: ThemeManager.getInstance().getColor(defaultColor: Color(0xffff8800)),
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(title,
                  style: TextStyle(fontSize: 12))
            ],
          ),
          this.child
        ],
      ),
    );
  }
}

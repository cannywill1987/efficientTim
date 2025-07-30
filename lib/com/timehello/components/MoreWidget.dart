
import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

class MoreWidget extends StatelessWidget {
  String text = '';
  MoreWidget({this.text = ''});
  @override
  Widget build(BuildContext context) {
    //白色圆角
    return SliverToBoxAdapter(
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
          children: [Container(
            margin: EdgeInsets.symmetric(vertical: 3),
            padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
            decoration: BoxDecoration(
              color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Color(0xffffffff)),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(text, style: TextStyle(color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff404040)), fontSize: 10),),
          )],
        ),
      ),
    );
  }
}

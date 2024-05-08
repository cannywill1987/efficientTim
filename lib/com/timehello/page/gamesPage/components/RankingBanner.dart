import 'package:flutter/cupertino.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class RankingBanner extends StatelessWidget {
  String rankingThisTime = "";
  String rankingText;
  RankingBanner({required this.rankingThisTime, required this.rankingText});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 5),
      width: double.infinity,
      height: 30,
      color: Color(0xffefb667),
      child: Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          getI18NKey().my_ranking_this_time(this.rankingThisTime.toString()),
          style: TextStyle(color: Color(0xff404040), fontSize: 13),
        ),
        Text(
          ",",
          style: TextStyle(color: Color(0xff404040), fontSize: 13),
        ),
        Text(
          rankingText,
          style: TextStyle(color: Color(0xff404040), fontSize: 13),
        ),

      ]),
    );
  }
}

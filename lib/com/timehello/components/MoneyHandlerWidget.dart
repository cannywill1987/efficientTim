import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/MoneyManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../config/ENUMS.dart';
import '../config/Params.dart';
import '../models/EventFn.dart';
import 'MineValueWidget.dart';

/**
 * 金额显示
 */
class MoneyHandlerWidget extends StatefulWidget {
  PageFromEnum pageFrom = PageFromEnum.MissionDetailPage;
  String? money;
  MoneyHandlerWidget({this.money, required this.pageFrom});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MoneyHandlerWidgetState();
  }
}

class MoneyHandlerWidgetState extends State<MoneyHandlerWidget> {

  @override
  Widget build(BuildContext context) {
    if(this.widget.pageFrom == PageFromEnum.MobileMinePage) {
      return
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MineValueWidget(color: Utility.isHandsetBySize() ? Colors.white: ColorsConfig.colorGold,),
            getWidget(fontSize: 18, pictureSize:18, margin: 3),
          ],
        );
    } else if(this.widget.pageFrom == PageFromEnum.MissionDetailPage) {
      return
        getWidget(fontSize: 24, pictureSize:30, margin: 3);
    } else if(this.widget.pageFrom == PageFromEnum.PresentDialog) {
      return
        getWidget(fontSize: 18, pictureSize:16, margin: 1, color: Color(0xff404040));
    }else { // mine页面
      return
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            getWidget(fontSize: 15, pictureSize:15, margin: 1, color: Color(0xff404040)),
            MineValueWidget(color: Utility.isHandsetBySize() ? Colors.white: ColorsConfig.colorGold,),
          ],
        );
    }
  }
  Widget getWidget({required double pictureSize, required double fontSize, required double margin,  Color color = Colors.white}) {
    return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Utility.getSVGPicture(R.assetsImgIcMoney2, size: pictureSize),
          SizedBox(width: margin,),
          Text(this.widget.money ?? MoneyManager.getInstance().getLocalMoney().toString(), style: TextStyle(fontSize: fontSize, color: ThemeManager.getInstance().getTextColor(defaultColor: color)),),
          this.widget.pageFrom != PageFromEnum.MissionDetailPage ? SizedBox.shrink() : SizedBox(width: 5,),
          this.widget.pageFrom != PageFromEnum.MissionDetailPage ? SizedBox.shrink() : Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text("+" + (MoneyManager.getInstance()?.localMoneyMake ?? 0).toString(), style: TextStyle(fontSize: fontSize - 8, color: color),),
          ),
          SizedBox(width: 8,),
          // Text('元', style: TextStyle(fontSize: fontSize, color: Colors.white),)
        ]);
  }

  @override
  void initState() {
    eventBus.on<EventFn>().listen((EventFn event) {
      if (event.type == Params.ACTION_UPDATE_MONEY && mounted) {
        setState(() {

        });
      }
    });
  }
}

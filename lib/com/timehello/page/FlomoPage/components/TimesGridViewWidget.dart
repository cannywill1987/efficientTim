import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../util/ScreenUtil.dart';
import '../../../util/TextUtil.dart';

/**
 * mission设置页面的tag
 */
class TimesGridViewWidget extends StatefulWidget {
  OnTapListener? onTapDeleteTagListener;
  OnTapListener? onTapAddTimeListener;
  List<int> datas = [];
  List<int> extraDatasWithoutAction = [];

  TimesGridViewWidget(
      {this.onTapAddTimeListener,
      this.onTapDeleteTagListener,
        required this.extraDatasWithoutAction,
      required this.datas});

  @override
  State<StatefulWidget> createState() {
    return _TimesGridViewWidgetState();
  }
}

class _TimesGridViewWidgetState extends State<TimesGridViewWidget> {
  @override
  void onCreate() {}

  @override
  void initState() {
  }

  @override
  void didUpdateWidget(TimesGridViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  build(BuildContext context) {
    // TODO: implement baseBuild
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: Utility.isMobile() ? ScreenUtil.getScreenW(context) - 100 : ScreenUtil.getScreenW(context) - 200,
          child: Wrap(
            spacing: 2, //主轴上子控件的间距
            runSpacing: 5, //交叉轴上子控件之间的间距
            children: [...getItems(this.widget.extraDatasWithoutAction, false), ...getItems(this.widget.datas)],
          ),
        )
      ],
    );
  }

  /**
   * 每个tag items
   */
   getItems(List datas, [bool clickable = true]) {
    List<Widget> list = [];
    for (int index = 0; index < datas.length; index++) {
      int time = datas[index];
      list.add(GestureDetector(
        onTap: () {
          if (clickable==false) {
            return;
          }
          if (this.widget.onTapDeleteTagListener != null) {
            this.widget.onTapDeleteTagListener!(datas[index]);
          }
        },
        child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Color(0xff909090)),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TextUtil.isEmpty(time) ==
                      false
                      ? Utility.formatHourAndMin2(
                      time ?? 0)
                      : getI18NKey().none,
                  style: TextStyle(
                      color: Color(
                        0xff909090,
                      ),
                      fontSize: 13),
                ),
                SizedBox(
                  width: 3,
                ),
                GestureDetector(
                    onTap: () {
                      if (this.widget.onTapDeleteTagListener != null) {
                        this.widget.onTapDeleteTagListener!(time);
                      }
                    },
                    child: Icon(Icons.close_sharp,
                        size: 14, color: Color(0xff909090)))
              ],
            )),
      ));
    }
    //clickable == true代表是最后一排
    if(clickable == true) {
      list.add(getButton());
    }
    return list;
  }

  Widget getButton() {
    Color color = Color(0xff909090);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: color),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: GestureDetector(
            onTap: () async {
              TimeOfDay? timeOfDay;
              timeOfDay = await Utility.showTimePickerDialog(context);
              if (timeOfDay == null) {
                return;
              }
              int startTime =
                  timeOfDay.hour * 60 * 60 * 1000 + timeOfDay.minute * 60 * 1000;
              if(this.widget.datas.indexOf(startTime) != -1) {
                Utility.showToast(msg:getI18NKey().already_exists_at_this_time, context: context);
                return;
              }
              this.widget.datas.add(startTime);
              this.widget.datas.sort();
              setState(() {

              });
              if (this.widget.onTapAddTimeListener != null) {
                this.widget.onTapAddTimeListener!(this.widget.datas);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: color),
                SizedBox(
                  width: 3,
                ),
                Text(
                  getI18NKey().add_reminder,
                  style: TextStyle(color: color, fontSize: 11),
                ),
              ],
            )));
  }
}

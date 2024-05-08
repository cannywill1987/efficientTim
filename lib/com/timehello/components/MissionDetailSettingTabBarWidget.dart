import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

/**
 * 任务详情 设置任务页
 */
class MissionDetailSettingButtonListWidget extends StatefulWidget {
  List<CheckButtonStateModel> list;
  OnTapListener? onTapListener;

  MissionDetailSettingButtonListWidget({required this.list, this.onTapListener});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MissionDetailSettingButtonListWidgetState();
  }
}

class MissionDetailSettingButtonListWidgetState
    extends State<MissionDetailSettingButtonListWidget> {
  // List<CheckButtonStateModel>? list;

  MissionDetailSettingButtonListWidgetState();
@override
  void didUpdateWidget(covariant MissionDetailSettingButtonListWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: getList(this.widget.list ?? [])));
  }

  List<Widget> getList(List<CheckButtonStateModel> list) {
    List<Widget> listTmp = [];
    for (int i = 0; i < list.length; i++) {
      CheckButtonStateModel element = list[i];
      listTmp.add(SizedBox(
        width: Utility.isHandsetBySize() ? 4 : 40,
        height: 1,
      ));
      listTmp.add(getCheckButton(element, list.indexOf(element)));
      listTmp.add(SizedBox(
        width: Utility.isHandsetBySize() ? 4 : 40,
        height: 1,
      ));
      if (i < list.length - 1) {
        listTmp.add(Container(
          height: 30,
          width: 1,
          color: ColorsConfig.dividerLine,
        ));
      }
    }
    return listTmp;
  }

  Widget getCheckButton(CheckButtonStateModel model, int index) {
    return TextButton(
        style: StylesConfig.transparentTextButtonStyle,
        onPressed: () {
          this.initModelListState();
          setState(() {
            model.isCheck = true;
            this.widget.onTapListener!({"data": model, "index": index});
          });
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Align(
                    child: Utility.getSVGPicture(
                  model.checkIconUrl ?? "",
                  size: 16,
                  // color: Colors.white,
                ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            new Text(
              model.title ?? '',
              maxLines: 1,
              softWrap: false,
              style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ));
  }

  void initModelListState() {
    this.widget.list?.forEach((element) {
      element.isCheck = false;
    });
  }
}

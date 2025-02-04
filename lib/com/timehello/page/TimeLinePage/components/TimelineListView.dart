import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/TimeLinePage/components/FileMessageWidget.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../config/ENUMS.dart';
import '../../../models/TimelineMissionModel.dart';
import '../../../util/Utility.dart';

class TimelineListView extends StatefulWidget {
  List<Widget> children = [];
  List<TimelineMissionModel> datas = [];
  DateTime dateTimeNow = DateTime.now();
  Function? onTapListener;
  Function? onTapDelete;
  TimelinePageFromEnum timelinePageFromEnum;

  TimelineListView(
      {List<Widget>? children,
      this.onTapDelete,
      required List<TimelineMissionModel> datas,
      this.timelinePageFromEnum = TimelinePageFromEnum.normal,
      this.onTapListener}) {
    if (children == null) {
      this.children = [];
    }
    this.datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TimelineListViewState();
  }
}

class TimelineListViewState extends State<TimelineListView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.widget.datas.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text(getI18NKey().no_data,
            style: TextStyle(
                color: Color(0xffa0a0a0),
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      );
    } else {
      List<Widget> list = getListItems();
      return ListView(cacheExtent: 10000, children: [
        if(this.widget.timelinePageFromEnum != TimelinePageFromEnum.FolderStatisticPage && this.widget.timelinePageFromEnum != TimelinePageFromEnum.ObjectivePage)
        SizedBox(
          height: (this.widget.timelinePageFromEnum !=
              TimelinePageFromEnum.ObjectivePage.index) && list.length > 0 ? 26 : 0,
        ),
        ...this.widget.children,
        ...list
      ]);
    }
  }

  List<Widget> getListItems() {
    List<Widget> list = [];
    this.widget.datas.forEach((element) {
      list.add(getItem(element));
    });
    return list;
  }

  Widget getModeWidget(String scene, int color) {
    return Text(CONSTANTS.getTimelineTypeTextByScene(scene: scene),
        style: TextStyle(
          color: Color(color),
          fontSize: 10,
        ));
  }

  Widget getEditModeWidget(TimelineMissionModel timelineMissionModel) {
    String scene = timelineMissionModel.sceneType ?? "";
    if (scene.isNotEmpty &&
        (timelineMissionModel.url != null) &&
        (scene == 'note' || scene == 'diary')) {
      return Text("【" + getI18NKey().see + "】",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 12,
          ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget getItem(TimelineMissionModel model) {
    // print("111111${model.picUrl}");

    int defaultColor = 0xffff8800;
    return GestureDetector(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(model);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 90,
                alignment: Alignment.center,
                child: Text(
                  Utility.getDifTime(
                      Utility.getDateTimeFromUTCString(model.createdAt ?? "")),
                  style: TextStyle(
                      fontSize: 12, color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor)),
                )),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 1,
                  height: 60,
                  color: Color(0xffa0a0a0),
                ),
                Container(
                    alignment: Alignment.center,
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Colors.white,
                    )),
                Container(
                  alignment: Alignment.center,
                  width: 45,
                  height: 45,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          IconData(model.icon ?? Icons.hive.codePoint,
                              fontFamily: 'MaterialIcons'),
                          color: Color(model.color ?? defaultColor),
                        ),
                        getModeWidget(
                            model.sceneType ?? '', model.color ?? defaultColor),
                      ]),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Color((model.color ?? defaultColor) - 0xdc000000),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: Color((model.color ?? defaultColor)))),
                ),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            getRightPartItem(model),
            SizedBox(
              width: 20,
            ),
            TextUtil.isEmpty(model.picUrl)
                ? SizedBox.shrink()
                : CachedNetworkImage(
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    imageUrl: Utility.filterHttpUrl(model.picUrl ?? "", prefix: "oss"),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              width: 10,
            )
          ],
        ));
  }

  /**
   * 右侧部分
   */
  Widget getRightPartItem(TimelineMissionModel model) {
    if (model.eventType == "note_voice" || model.eventType == "diary_voice") {
      return FileMessageWidget(timelineMissionModel: model);
    } else {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  Utility.getDateTimeYMDHM(Utility.getDateTimeFromUTCString(
                          model.createdAt ?? "")) ??
                      "",
                  style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12),
                ),
                this.widget.timelinePageFromEnum ==
                        TimelinePageFromEnum.StatisticPage
                    ? SizedBox.shrink()
                    : InkWell(
                        onTap: () {
                          if (this.widget.onTapDelete != null) {
                            this.widget.onTapDelete!(model);
                          }
                        },
                        child: Text(
                          "【" + getI18NKey().delete + "】",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ))
              ],
            ),
            Wrap(
              children: [
                Text(
                  model.timelineMessage ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.chartTextColor),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                getEditModeWidget(model)
              ],
            ),
          ],
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/CustomTextButton.dart';
import 'package:time_hello/com/timehello/components/ListingSecurityWidget.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/CalendarModel.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';

import '../../../../../r.dart';
import '../../../components/ListingFilterWidget.dart';
import '../../../config/CONSTANTS.dart';
import '../../../config/StylesConfig.dart';

typedef OnTapFinishListener = void Function(FolderModel? folderModel,
    MissionModel? missionModel, int? timestampCurrent);
typedef OnTapPlayListener = void Function(
    FolderModel? folderModel, MissionModel? missionModel);
typedef OnTapSettingListener = void Function(
    FolderModel? folderModel, MissionModel? missionModel);
typedef OnTapCreateListener = void Function(DayModel dayModel);

/**
 * calendar日历列表
 */
class CalendarSliverListWidget extends StatelessWidget {
  // final int indexOfMonth; //第几个月
  // final int fromIndexOfDays;
  final List<DayModel> listDayModels;
  final Function onScrollListener;
  final Function onTapHeaderListener;
  final OnTapFinishListener onTapFinishListener;
  final OnTapPlayListener onTapPlayListener;
  final OnTapSettingListener onTapSettingListener;
  final OnTapCreateListener onTapCreateListener;
  final Function onTapFolderFilterListener;

  const CalendarSliverListWidget(
      {Key? key,
      required this.onTapFolderFilterListener,
      required this.onTapSettingListener,
      required this.onTapHeaderListener,
      required this.listDayModels,
      required this.onScrollListener,
      required this.onTapFinishListener,
      required this.onTapPlayListener,
      required this.onTapCreateListener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      key: ValueKey('ejfiewf'),
      padding: EdgeInsets.all(CalendarHeaderWidget.padding).copyWith(top: 0),
      sliver: MultiSliver(
        key: ValueKey('ejfiewf121'),
        pushPinnedChildren: true,
        children: [
          SliverStack(
            key: ValueKey("jfizjf"),
            insetOnOverlap: true,
            children: [
              MultiSliver(
                key: ValueKey("jeiwjfiwef"),
                children: <Widget>[
                  //头部月份
                  SliverPinnedHeader(
                      key: ValueKey("jeiwjfizjiczj"),
                      child: CalendarHeaderWidget(
                        onTapFolderFilterListener: (folderModel) {
                          if (this.onTapFolderFilterListener != null) {
                            this.onTapFolderFilterListener(folderModel);
                          }
                        },
                        onTapListener: (data) {
                          this.onTapHeaderListener();
                        },
                        title: this.listDayModels[0].year.toString(),
                        subtitle:
                            '${this.listDayModels[0].month.toString() + " 1-" + this.listDayModels.length.toString()}',
                      )),
                  SliverClip(
                    child: MultiSliver(
                      children: <Widget>[
                        SliverList(
                          key: ValueKey("ejfdizjizjif"),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // print('index ' +
                              //     (this.fromIndexOfDays + index).toString());
                              // this.onScrollListener(this.fromIndexOfDays + index);
                              return AutoScrollTag(
                                  key: ValueKey(index),
                                  controller: AutoScrollController(),
                                  index: index,
                                  highlightColor: Colors.redAccent,
                                  child: Item(
                                    onTapCreateListener:
                                        this.onTapCreateListener,
                                    dayModel: listDayModels[index],
                                    onTapSettingListener:
                                        this.onTapSettingListener,
                                    onTapFinishListener:
                                        this.onTapFinishListener,
                                    onTapPlayListener: this.onTapPlayListener,
                                  ));
                            },
                            childCount: listDayModels.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CalendarHeaderWidget extends StatelessWidget {
  static const double padding = 0;
  final String title; //年
  final String subtitle; //月份
  final OnTapListener onTapListener;
  final OnTapListener onTapFolderFilterListener;

  const CalendarHeaderWidget({
    Key? key,
    required this.onTapFolderFilterListener,
    required this.onTapListener,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: ThemeManager.getInstance()
                        .getLineColor(defaultColor: Color(0xffe3e0e2)),
                    width: 1))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        this.onTapListener(null);
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Text(
                                    this.title,
                                    style: TextStyle(
                                        color: ThemeManager.getInstance()
                                            .getTextColor(
                                                defaultColor:
                                                    ColorsConfig.gray_40)),
                                  )),
                              Container(
                                padding: EdgeInsets.only(left: 0, bottom: 10),
                                child: Text(
                                  this.subtitle,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: ThemeManager.getInstance()
                                          .getTextColor(
                                              defaultColor: Colors.black),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Icon(Icons.arrow_drop_down,
                                  size: 30,
                                  color: ThemeManager.getInstance()
                                      .getIconColor(
                                          defaultColor: Colors.black)))
                        ],
                      ))),
            ),
            ListingFilterWidget(onTapListener: (data) {
              if (this.onTapFolderFilterListener != null) {
                this.onTapFolderFilterListener(data);
              }
              // this.curSearchingFocusModel = data;
              // this.requestDatas();
            }),
          ],
        ),
      );
}

/**
 * 每一个滚动横条
 */
class Item extends StatelessWidget {
  final DayModel dayModel;
  final OnTapFinishListener onTapFinishListener;
  final OnTapPlayListener onTapPlayListener;
  final OnTapSettingListener onTapSettingListener;
  final OnTapCreateListener onTapCreateListener;

  const Item({
    Key? key,
    required this.onTapCreateListener,
    required this.onTapSettingListener,
    required this.onTapFinishListener,
    required this.onTapPlayListener,
    required this.dayModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => getItem(dayModel);

  /**
   * 每个横条Mission
   */
  Widget getItem(DayModel dayModel) {
    String? week = Utility.getWeekDay(dayModel.weekday);
    int? day = dayModel.day;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 85,
          height: StylesConfig.heightItemOfCalendar,
          decoration: BoxDecoration(
              color: ThemeManager.getInstance().getLeftMenuColor(
                  defaultColor:
                      ThemeManager.getInstance().getLightDefaultThemeColor()),
              border: dayModel.isCurrent
                  ? Border(
                      right: BorderSide(
                          color: ThemeManager.getInstance()
                              .getLineColor(defaultColor: Color(0xffe7e6e9)),
                          width: 1),
                      bottom: BorderSide(
                          color: ThemeManager.getInstance()
                              .getLineColor(defaultColor: Color(0xffe7e6e9)),
                          width: 1),
                      left: BorderSide(color: Colors.blue, width: 6))
                  : Border(
                      right: BorderSide(
                          color: ThemeManager.getInstance()
                              .getLineColor(defaultColor: Color(0xffe7e6e9)),
                          width: 1),
                      bottom: BorderSide(
                          color: ThemeManager.getInstance()
                              .getLineColor(defaultColor: Color(0xffe7e6e9)),
                          width: 1))),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              this.onTapCreateListener(dayModel);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //昨天的日期
                Text(
                  '$week',
                  style: TextStyle(
                      fontSize: 16,
                      color: dayModel.isCurrent
                          ? Colors.blue
                          : ThemeManager.getInstance()
                              .getTextColor(defaultColor: Color(0xff5a5c64))),
                ),
                Text('$day',
                    style: TextStyle(
                        fontSize: 18,
                        color: dayModel.isCurrent
                            ? Colors.blue
                            : ThemeManager.getInstance()
                                .getTextColor(defaultColor: Color(0xff5a5c64)),
                        fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    dayModel.hasAlertOfMissionModel == true
                        ? Icon(
                            Icons.alarm,
                            size: 12,
                          )
                        : SizedBox.shrink(),
                    Text(getI18NKey().add_task,
                        style: TextStyle(
                            fontSize: 11,
                            color: ThemeManager.getInstance()
                                .getDefautThemeColor(),
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
            child: Container(
          height: StylesConfig.heightItemOfCalendar,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: this.dayModel.missionModelList.length,
              itemBuilder: (context, index) {
                return ItemIndividualWidget(
                    dayModel: this.dayModel,
                    onTapSettingListener: this.onTapSettingListener,
                    onTapFinishListener: onTapFinishListener,
                    onTapPlayListener: onTapPlayListener,
                    missionModel: this.dayModel.missionModelList[index]);
                // return
                //   buildItem(this.dayModel.missionModelList[index]);
              }),
        ))
      ],
    );
  }
}

class ItemIndividualWidget extends StatefulWidget {
  MissionModel missionModel;
  DayModel dayModel;
  OnTapFinishListener onTapFinishListener;
  OnTapPlayListener onTapPlayListener;
  OnTapSettingListener onTapSettingListener;

  ItemIndividualWidget(
      {required this.onTapFinishListener,
      required this.dayModel,
      required this.onTapSettingListener,
      required this.onTapPlayListener,
      required this.missionModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemIndividualState();
  }
}

class ItemIndividualState extends State<ItemIndividualWidget> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FolderModel? folderModelWithMission;
    if (!TextUtil.isEmpty(this.widget.missionModel.folder_id)) {
      List<FolderModel> folderModelList = MongoApisManager.getInstance()!
          .queryWhereEqual_folderModelWithFolderId(
              this.widget.missionModel.folder_id);
      for (int i = 0; i < folderModelList.length; i++) {
        FolderModel item = folderModelList[i];
        if (item.tag == 2) {
          //
          folderModelWithMission = item;
        }
        if (item.tag == 1) {
          folderModelWithMission = item;
        }
        if (item.tag == 0) {
          folderModelWithMission = item;
        }
      }
    }
    double itemWidth = Utility.isHandsetBySize() == true
        ? StylesConfig.heightItemOfCalendar
        : 140;
    return GestureDetector(
        onTap: () {
          // if (this.widget.missionModel.isFinished == false)
          this.widget.onTapSettingListener(
              folderModelWithMission, this.widget.missionModel);
        },
        child: MouseRegion(
            onEnter: (_) {
              // setState(() {
              // this.isHover = true;
              // });
            },
            onHover: (_) {},
            onExit: (_) {
              // setState(() {
              // this.isHover = false;
              // });
            },
            child: Container(
                margin: EdgeInsets.only(right: 1),
                width: itemWidth,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                decoration: BoxDecoration(
                    color: ThemeManager.getInstance().getBackgroundColor(
                        defaultColor: Color((folderModelWithMission != null &&
                                folderModelWithMission.color != null)
                            ? (folderModelWithMission.color - 0xC1000000)
                            : 0xffff8800 - 0xC1000000)),
                    border: Border(
                        top: BorderSide(color: Color(0xffcdd7d0), width: 0.5),
                        right: BorderSide(color: Color(0xffcdd7d0), width: 0.5),
                        bottom:
                            BorderSide(color: Color(0xffcdd7d0), width: 0.5),
                        left:
                            BorderSide(color: Color(0xffcdd7d0), width: 0.5))),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // SizedBox(height: 5,),
                      Container(
                          height: 4,
                          color: folderModelWithMission != null
                              ? Color(folderModelWithMission.color)
                              : Color(0xffff8800)),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              width: 12,
                              height: 12,
                              child: folderModelWithMission != null
                                  ? Icon(
                                      IconData(folderModelWithMission.icon ?? 0,
                                          fontFamily: 'MaterialIcons'),
                                      size: 12,
                                      color:
                                          Color(folderModelWithMission.color))
                                  : SizedBox.shrink()),
                          ListingSecurityWidget(
                            missionModdel_id:
                                this.widget.missionModel?.objectId,
                            folder_id:
                                this.widget.missionModel?.folder_id ?? "",
                            cryptoVersion:
                                this.widget.missionModel?.cryptoVersion ?? -1,
                            marginLeft: 3,
                            marginRight: 3,
                            size: 11,
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                folderModelWithMission?.title ?? "",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: ThemeManager.getInstance()
                                        .getTextColor(
                                            defaultColor:
                                                ColorsConfig.gray_40)),
                              )),
                          //点击完毕
                          GestureDetector(
                              onTap: () {
                                // if (this.widget.missionModel.isFinished ==
                                //     false)
                                this.widget.onTapFinishListener(
                                    folderModelWithMission,
                                    this.widget.missionModel,
                                    this
                                        .widget
                                        .dayModel
                                        ?.dateTime
                                        ?.millisecondsSinceEpoch);
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: CheckImage(
                                  width: 20,
                                  height: 20,
                                  isSizeConfigured: true,
                                  onTapListener: (res) {
                                    // if (this.widget.missionModel.isFinished ==
                                    //     false)
                                    this.widget.onTapFinishListener(
                                        folderModelWithMission,
                                        this.widget.missionModel,
                                        this
                                            .widget
                                            .dayModel
                                            ?.dateTime
                                            ?.millisecondsSinceEpoch);
                                    // if (this.widget.onTapFinishListener != null)
                                    //   this.widget.onTapFinishListener(_missionModel);
                                  },
                                  checked: Utility.getIsFinishOfMissionModel(
                                    missionModel: this.widget.missionModel,
                                    curMonthTimeStamp: this
                                            .widget
                                            .dayModel
                                            .dateTime
                                            ?.millisecondsSinceEpoch ??
                                        0,
                                  ),
                                  checkIcon: Icon(Icons.check_circle,
                                      size: 20,
                                      color: ColorsConfig.calendar_green),
                                  uncheckIcon: Icon(
                                      Icons.radio_button_unchecked_outlined,
                                      color: ColorsConfig.gray_a7,
                                      size: 20),
                                ),
                              )),
                          SizedBox(
                            width: 3,
                          ),
                        ],
                      ),
                      Expanded(
                          child: GestureDetector(
                              // style: StylesConfig.transparentTextButtonStyle,
                              onTap: () {
                                if (this.widget.onTapSettingListener != null) {
                                  this.widget.onTapSettingListener(
                                      folderModelWithMission,
                                      this.widget.missionModel);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 5,
                                  left: 5,
                                  right: 5,
                                ),
                                child: Text.rich(
                                    maxLines: 3,
                                    TextSpan(
                                        // text: 'Hello', // default text style
                                        children: [
                                          TextSpan(
                                              text: this
                                                      .widget
                                                      .missionModel
                                                      ?.title ??
                                                  "",
                                              style: ThemeManager.getInstance()
                                                  .getTextStyle(
                                                      defaultTextStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          decoration: this
                                                                      .widget
                                                                      .missionModel
                                                                      ?.isFinished ==
                                                                  true
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decorationColor:
                                                              Color(0xffa0a0a0),
                                                          decorationThickness:
                                                              2,
                                                          color: ColorsConfig
                                                              .gray_40))),
                                          WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [

                                                  if ((this
                                                              .widget
                                                              .missionModel
                                                              ?.subMissions
                                                              ?.length ??
                                                          0) >
                                                      0) ...[
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Utility.getSVGPicture(
                                                        R.assetsImgIcSubmission,
                                                        size: 14),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      this
                                                              .widget
                                                              .missionModel
                                                              ?.subMissions
                                                              ?.length
                                                              .toString() ??
                                                          "0",
                                                      textAlign: TextAlign.left,
                                                      style: ThemeManager
                                                              .getInstance()
                                                          .getTextStyle(
                                                              defaultTextStyle: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xff9DA7B2))),
                                                    ),
                                                  ],
                                                ],
                                              )),
                                          ...WidgetManager.getTagsWidgetSpan(
                                              this.widget.missionModel ??
                                                  MissionModel(),
                                              fontSize: 12)
                                        ])),
                              ))),
                      GestureDetector(
                          onTap: () {
                            this.widget.onTapPlayListener(
                                folderModelWithMission,
                                this.widget.missionModel);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: CONSTANTS.getPriorityIcon(
                                      this.widget.missionModel.priorityStatus ??
                                          3,
                                      size: 14)),
                              SizedBox(
                                width: 3,
                              ),
                              Utility.isAlertOn(this.widget.missionModel) ==
                                      true
                                  ? Icon(
                                      Icons.alarm,
                                      size: 12,
                                      color: Colors.blueAccent,
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                width: 3,
                              ),
                              if ((this
                                          .widget
                                          .missionModel
                                          ?.subMissions
                                          ?.length ??
                                      0) >
                                  0)
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Utility.getSVGPicture(
                                        R.assetsImgIcSubmission,
                                        size: 14),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    Text(
                                      this
                                              .widget
                                              .missionModel
                                              ?.subMissions
                                              ?.length
                                              .toString() ??
                                          "0",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(0xff9DA7B2)),
                                    ),
                                  ],
                                ),
                              Spacer(),
                              RatingBar(
                                curNumber: this
                                        .widget
                                        .missionModel
                                        .no_tomotoes_finished ??
                                    0,
                                number:
                                    this.widget.missionModel.total_tomotoes ??
                                        0,
                                size: 12,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                Icons.play_circle_outline,
                                color: Color(0xfffd5553),
                                size: 14,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                            ],
                          ))
                    ],
                  ),
                ]))));
  }

  List<Widget> getTagsTextView(MissionModel missionModel) {
    List<FolderModel> list = CONSTANTS
        .getFolderModelListFromStringList(missionModel.tagNames?.split(','));
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      listWidget.add(SizedBox(
        width: 5,
      ));
      FolderModel folderModel = list[i];
      listWidget.add(Text("#" + (folderModel.title ?? ""),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Color(folderModel.color))));
    }
    return listWidget;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/IconWidget.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/components/StateImage.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/r.dart';

import '../../../components/DashWidget.dart';
import '../../../config/Params.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/ScreenUtil.dart';
import 'ConfirmButton.dart';

typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapEditTitleListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapPlayListener = void Function(dynamic obj);
typedef OnDragEndListener = void Function(dynamic obj);

class FlomoMissionSilverList extends StatefulWidget {
  String ymd = ""; // 2022-01-12
  DateTime curDateTime;
  List _datas = [];
  OnTapListener? onTapListener;
  OnTapListener? onTapClockInListener;
  FlomoMissionSilverListState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  late OnDragEndListener onDragEndListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  bool? isSlideEnable;
  Widget? bottomChild;

  FlomoMissionSilverList(
      {Key? key,
      required List datas,
      OnTapListener? onTapListener,
        this.onTapClockInListener,
      required this.curDateTime,
      String? ymd,
      this.onTapFinishListener,
      required OnDragEndListener onDragEndListener,
      this.bottomChild,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.isSlideEnable = true})
      : super(key: key) {
    if (ymd == null) {
      this.ymd = Utility.getYMDToday();
    } else {
      this.ymd = ymd;
    }
    this.onDragEndListener = onDragEndListener;
    this.onTapListener = onTapListener;
    this._datas = datas;
  }

  set datas(List datas) {
    _datas = datas;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menuSilverListState = new FlomoMissionSilverListState();
  }
}

class FlomoMissionSilverListState extends State<FlomoMissionSilverList> {
  double draggableItemWidth = 0;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      if (this.widget.bottomChild != null &&
          index == this.widget._datas.length) {
        return this.widget.bottomChild!;
      }
      return buildFlomoMissionSilverListItem(index, isDraggable: false);
    },
            childCount: this.widget.bottomChild == null
                ? this.widget._datas.length
                : this.widget._datas.length + 1));
  }

  FlomoMissionSilverListItem buildFlomoMissionSilverListItem(int index,
      {bool isDraggable: false}) {
    return FlomoMissionSilverListItem(
      isSlideEnable: this.widget.isSlideEnable,
      onTapClockInListener: this.widget.onTapClockInListener,
      onTapListener: this.widget.onTapListener,
      isDraggable: isDraggable,
      index: index,
      ymd: this.widget.ymd,
      curDateTime: this.widget.curDateTime,
      missionModel: this.widget._datas[index],
      onTapEditTitleListener: this.widget.onTapEditTitleListener,
      onTapEditListener: this.widget.onTapEditListener,
      onTapDeleteListener: this.widget.onTapDeleteListener,
      onTapFinishListener: this.widget.onTapFinishListener,
      onTapPlayListener: this.widget.onTapPlayListener,
    );
  }
}

class FlomoMissionSilverListItem extends StatefulWidget {
  String ymd = ""; // 2022-01-12
  OnTapListener? onTapListener;
  OnTapPlayListener? onTapPlayListener;
  int? index;
  bool? isVisible;
  bool? isSlideEnable = true;
  late FlomoMissionModel missionModel;
  OnTapFinishListener? onTapFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapListener? onTapClockInListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapEditTitleListener? onTapEditTitleListener;
  bool isDraggable;
  DateTime curDateTime;
  double itemWidth = 0;

  FlomoMissionSilverListItem(
      {Key? key,
      bool isVisible = true,
      required this.curDateTime,
      required this.ymd,
        this.onTapClockInListener,
      this.isDraggable = false,
      OnTapListener? onTapListener,
      required FlomoMissionModel missionModel,
      int? index,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.onTapFinishListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.isSlideEnable})
      : super(key: key) {
    this.onTapListener = onTapListener;
    this.index = index;
    this.isVisible = isVisible;
    this.missionModel = missionModel;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw MenuSilverListItem(onTapListener);
    return FlomoMissionSilverListItemState();
  }
}

class FlomoMissionSilverListItemState
    extends State<FlomoMissionSilverListItem> {
  bool isHover = false;
  double fontSize = Utility.isHandsetBySize() ? 11 : 15;
  double marginLeftRight = 10;
  final GlobalKey containerKey = GlobalKey();
  Size size = Size(0, 0);
  double percentClocksIn = 0; //打卡比例

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        size = Utility.getItemSizeByGlobalKey(containerKey);
      });
    });
  }



  Widget getContainerWithHeight(
      {double percent = 0.3,
      double? height,
      required FlomoMissionModel flomoMissionModel,
      required Widget child}) {
    double draggableWidth =
        (ScreenUtil.getScreenW(context) - 50) / 2; //可拖曳组件的宽度

    //得到container宽度
    return InkWell(
      onTap: () {
        if (this.widget.onTapListener != null) {
          this.widget.onTapListener!(flomoMissionModel);
        }
      },
      child: Container(
        key: containerKey,
        // width: percent * draggableWidth,
        // constraints: BoxConstraints(minHeight: height),
        height: 115,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        // padding: EdgeInsets.only(
        //     top: Utility.isHandsetBySize() ? 3 : 6,
        //     bottom: Utility.isHandsetBySize() ? 3 : 6),
        margin: EdgeInsets.only(
            top: 6,
            bottom: Utility.isHandsetBySize() ? 0 : 2,
            left: 10,
            right: 10),
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            Container(
              width: size.width * percentClocksIn,
              color: ThemeManager.getInstance().isDark() ? Color(
                  (this.widget.missionModel.color ?? 0xffff8800) - 0x50000000) : Color(
                  (this.widget.missionModel.color ?? 0xffff8800) - 0xb0000000),
            ),
            Column(
              children: [
                child,
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      getI18NKey().clockin_n_days_continuously(Utility
                              .totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStamp(
                            flomoMissionModel: flomoMissionModel,
                            curTimeStamp:
                                this.widget.curDateTime.millisecondsSinceEpoch,
                          ).toString()) +
                          "-" +
                          getI18NKey().clockin_n_days_totally(
                              Utility.totalFlomoMissionClockInFinished(
                            clockInMap: flomoMissionModel?.clockIn ?? {},
                            daily_num_times: flomoMissionModel.daily_num_times,
                          ).toString()),
                      style: TextStyle(color: Color(0xff999999), fontSize: 12),
                    ),
                    Spacer(),
                    Text(
                      "",
                      style: TextStyle(color: Color(0xff999999), fontSize: 12),
                    ),
                    SizedBox(width: 10)
                  ],
                )
              ],
            ),
            Positioned(
              top: 38,
              right:  0 ,
              child: // 完成不需要显示
            this.widget.missionModel.isFinished == true
                ? SizedBox.shrink()
                : InkWell(
              onTap: () {
                this.widget.onTapClockInListener?.call(this.widget.missionModel);
              },
              child: Container(
                // alignment: Alignment(0.3,-1),
                padding: EdgeInsets.only(top: 15),
                alignment: Alignment.topCenter,
                height: 100,
                width: 70,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, 0, Utility.isHandsetBySize() ? 0 : 10, 0),
                    child: ConfirmButton(
                      isChecked: this.percentClocksIn >= 1 ? true : false,
                    )),
              ),
            ),)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlomoMissionModel _missionModel = this.widget.missionModel;
    percentClocksIn = Utility.getPercentOfNumClocksIn(missionModel: this.widget.missionModel, ymd: this.widget.ymd);
    //左边文案和角标
    if (Utility.isHandsetBySize() == false && this.widget.isDraggable == true) {
      fontSize = 12;
    }
    // size = Utility.getItemSizeByGlobalKey(containerKey);

    List<Widget> childrenRow = <Widget>[
      Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 10, left: 10),
          decoration: BoxDecoration(
              color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white), borderRadius: BorderRadius.circular(40)),
          child: IconWidget(
            icon: this.widget.missionModel.icon ?? 0,
            iconSize: 28,
            color: this.widget.missionModel.color,
          )),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(this.widget.missionModel.title ?? "",
                        textAlign: TextAlign.left,
                        maxLines: (this.widget.isDraggable) ? 1 : 3,
                        style: TextStyle(
                            decoration: (_missionModel.isFinished ?? false)
                                ? TextDecoration.lineThrough
                                : null,
                            decorationStyle: TextDecorationStyle.solid,
                            // decorationColor: Utility.getTextColorByPriority(this.widget.priorityEnum),
                            decorationThickness: 3,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                            overflow: TextOverflow.ellipsis,
                            color: ThemeManager.getInstance().getTextColor(defaultColor: ColorsConfig.gray_40))),
                    SizedBox(
                      width: Utility.isHandsetBySize() ? 1 : 3,
                    ),
                    // GestureDetector(
                    //   child: Icon(Icons.edit,
                    //       size: Utility.isHandsetBySize() ? 10 : 14),
                    //   onTap: () {
                    //     if (this.widget.onTapEditTitleListener != null)
                    //       this.widget.onTapEditTitleListener!(_missionModel);
                    //   },
                    // ),
                    SizedBox(
                      width: 3,
                    ),
                    // ...getTagsTextView(_missionModel),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.watch,
                    //   color: ColorsConfig.darkRed,
                    //   size: Utility.isHandsetBySize() ? 10 : 12,
                    // ),
                    // SizedBox(width: 2),
                    Text(
                      (this.widget.missionModel?.alert_times?.length ?? 0) > 0
                          ? Utility.formatHourAndMin2(
                              Utility.getTheLatestTimesFromNow(
                                  this.widget.missionModel?.alert_times ?? []))
                          : "",
                      style: TextStyle(
                          fontSize: Utility.isHandsetBySize() ? 10 : 12,
                          color: ColorsConfig.darkRed),
                    )
                  ],
                )
              ]),
          flex: 3),

      DeviceInfoManagement.isMoible() == false
          ? SizedBox(
              width: 15,
            )
          : SizedBox(
              width: 0,
            )
    ];
    //组件可拖曳展示方式
    // if (this.widget.isDraggable == true) {
    //   return getItem(childrenRow, _missionModel);
    // }
    return Slidable(
      enabled: (DeviceInfoManagement.isMoible() == true  || DeviceInfoManagement.isWebMobileBySize()) &&
          _missionModel.isFinished == false,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: MouseRegion(
          onEnter: (_) {
            setState(() {
              this.isHover = true;
            });
          },
          onHover: (_) {},
          onExit: (_) {
            setState(() {
              this.isHover = false;
            });
          },
          child: getItem(childrenRow, _missionModel)),
      secondaryActions: <Widget>[
        IconSlideAction(
          // caption: getI18NKey().finish,
          color: Colors.lightBlue,
          foregroundColor: Colors.white,
          icon: Icons.check,
          onTap: () {
            if (this.widget.onTapFinishListener != null)
              this.widget.onTapFinishListener!(_missionModel);
          },
        ),
        IconSlideAction(
          // caption: getI18NKey().edit,
          color: Colors.lightGreen,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          onTap: () {
            if (this.widget.onTapEditListener != null)
              this.widget.onTapEditListener!(_missionModel);
          },
        ),
        IconSlideAction(
          // caption: getI18NKey().delete,
          foregroundColor: Colors.white,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            if (this.widget.onTapDeleteListener != null)
              this.widget.onTapDeleteListener!(_missionModel);
          },
        ),
      ],
    );
  }

  Widget getItem(List<Widget> childrenRow, FlomoMissionModel _missionModel) {
    return getContainerWithHeight(
      flomoMissionModel: _missionModel,
      height: Utility.isHandsetBySize() == true ? 40 : null,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
                padding: EdgeInsets.symmetric(
                    horizontal: marginLeftRight, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getI18NKey().everyDayOnce(
                              this.widget.missionModel.daily_num_times),
                          style:
                              TextStyle(color: Color(0xff8c8c8c), fontSize: 12),
                        ),
                        (this.isHover == true )
                            ? SizedBox.shrink()
                            : Text(
                                this.widget.missionModel.inspration_message ??
                                    "",
                                style: TextStyle(
                                    color: Color(0xff999999), fontSize: 12),
                              )
                      ],
                    ),
                  ],
                ),
              ),
              DashLineWidget(
                color: Color(0xffff8800),
                gap: 6,
              ),
              SizedBox(
                height: 10,
              ),
              Stack(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: childrenRow,
                ),
              ]),
            ],
          ),
          (this.isHover == true && _missionModel.isFinished == false)
              ? Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<String>(
                    tooltip: '',
                    padding: EdgeInsets.only(left: 0),
                    // offset: Offset(130, 30),
                    iconSize: 14,
                    icon: Icon(
                      Icons.more_vert,
                      color: ThemeManager.getInstance().getIconColor(defaultColor: Colors.black87),
                    ),
                    onCanceled: () {
                      print(1);
                    },
                    itemBuilder: (context) {
                      // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'complete',
                          onTap: () {
                            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
                            Future.delayed(Duration(milliseconds: 100), () {
                              this.widget.onTapFinishListener!(_missionModel);
                            });
                          },
                          child: Text(getI18NKey().archived,
                              style: TextStyle(fontSize: fontSize)),
                        ),
                        PopupMenuItem<String>(
                          value: 'edit',
                          onTap: () {
                            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
                            Future.delayed(Duration(milliseconds: 100), () {
                              this.widget.onTapEditListener!(_missionModel);
                            });
                          },
                          child: Text(getI18NKey().edit,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12)),
                        ),
                        PopupMenuItem<String>(
                          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
                          value: 'delete',
                          onTap: () {
                            Future.delayed(Duration(milliseconds: 100), () {
                              this.widget.onTapDeleteListener!(_missionModel);
                            });
                          },
                          child: Text(
                            getI18NKey().delete,
                            style: TextStyle(
                                color: ColorsConfig.red, fontSize: fontSize),
                          ),
                        ),
                      ];
                    },
                  ),
                )
              :  (this.isHover == true && _missionModel.isFinished == true) ? Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<String>(
              tooltip: '',
              padding: EdgeInsets.only(left: 0),
              // offset: Offset(130, 30),
              iconSize: 14,
              icon: Icon(
                Icons.more_vert,
                color: Colors.black87,
              ),
              onCanceled: () {
                print(1);
              },
              itemBuilder: (context) {
                // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
                    value: 'delete',
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 100), () {
                        this.widget.onTapDeleteListener!(_missionModel);
                      });
                    },
                    child: Text(
                      getI18NKey().delete,
                      style: TextStyle(
                          color: ColorsConfig.red, fontSize: fontSize),
                    ),
                  ),
                ];
              },
            ),
          ) : SizedBox.shrink()
        ],
      ),
    );
  }
}

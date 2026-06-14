// ignore_for_file: must_be_immutable, deprecated_colon_for_default_value

import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/IconWidget.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/action_pane_motions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/models/FlomoMissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../components/DashWidget.dart';
import '../../../util/DeviceInfoManagement.dart';
import 'ConfirmButton.dart';

typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapEditTitleListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapPlayListener = void Function(dynamic obj);
typedef OnDragEndListener = void Function(dynamic obj);

/**
 * 文件类型：组件
 * 文件作用：展示 Flomo 打卡任务列表和单个任务卡片。
 * 主要职责：承接打卡、编辑、归档、删除等交互，并把任务 item 渲染成参考 FolderPage 的圆角卡片样式。
 */
class FlomoMissionSilverList extends StatefulWidget {
  String ymd = ""; // 2022-01-12
  DateTime curDateTime;
  List _datas = [];
  OnTapListener? onTapListener;
  OnTapListener? onTapClockInListener;
  FlomoMissionSilverListState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  Function? onTapCancelClockInListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  late OnDragEndListener onDragEndListener;
  OnTapFinishListener? onTapFinishListener;
  Function? onTapUnfinishListener;
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
      required this.onTapUnfinishListener,
      required OnDragEndListener onDragEndListener,
      required this.onTapCancelClockInListener,
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
      onTapCancelClockInListener: this.widget.onTapCancelClockInListener,
      onTapEditTitleListener: this.widget.onTapEditTitleListener,
      onTapEditListener: this.widget.onTapEditListener,
      onTapDeleteListener: this.widget.onTapDeleteListener,
      onTapFinishListener: this.widget.onTapFinishListener,
      onTapUnfinishListener: this.widget.onTapUnfinishListener,
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
  Function? onTapCancelClockInListener;
  Function? onTapUnfinishListener;
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
      this.onTapUnfinishListener,
      this.onTapEditTitleListener,
      this.onTapCancelClockInListener,
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

  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );

  Widget _buildOverflowMenu(FlomoMissionModel missionModel) {
    final Color iconColor = ThemeManager.getInstance()
        .getIconColor(defaultColor: Colors.black87)
        .withValues(alpha: isHover ? 0.95 : 0.55);

    if (missionModel.isFinished == false) {
      return PopupMenuButton<String>(
        tooltip: '',
        padding: EdgeInsets.zero,
        iconSize: 16,
        icon: Icon(Icons.more_vert, color: iconColor),
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'complete',
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  this.widget.onTapFinishListener?.call(missionModel);
                });
              },
              child: Text(getI18NKey().archived,
                  style: TextStyle(fontSize: fontSize)),
            ),
            PopupMenuItem<String>(
              value: 'edit',
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  this.widget.onTapEditListener?.call(missionModel);
                });
              },
              child: Text(getI18NKey().edit,
                  style: TextStyle(color: Colors.green, fontSize: fontSize)),
            ),
            PopupMenuItem<String>(
              value: 'cancel_latest_clockin',
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  this.widget.onTapCancelClockInListener?.call(missionModel);
                });
              },
              child: Text(getI18NKey().cancel_latest_clockin,
                  style: TextStyle(color: Colors.grey, fontSize: fontSize)),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              onTap: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  this.widget.onTapDeleteListener?.call(missionModel);
                });
              },
              child: Text(
                getI18NKey().delete,
                style: TextStyle(color: ColorsConfig.red, fontSize: fontSize),
              ),
            ),
          ];
        },
      );
    }

    return PopupMenuButton<String>(
      tooltip: '',
      padding: EdgeInsets.zero,
      iconSize: 16,
      icon: Icon(Icons.more_vert, color: iconColor),
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'delete',
            onTap: () {
              Future.delayed(Duration(milliseconds: 100), () {
                this.widget.onTapDeleteListener?.call(missionModel);
              });
            },
            child: Text(
              getI18NKey().delete,
              style: TextStyle(color: ColorsConfig.red, fontSize: fontSize),
            ),
          ),
        ];
      },
    );
  }

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
    final bool isDark = ThemeManager.getInstance().isDark();
    final bool isClockedToday = percentClocksIn >= 1;
    final Color missionColor =
        Color(this.widget.missionModel.color ?? 0xffff8800);
    final Color cardColor = isClockedToday
        ? (isDark ? const Color(0xff3b3528) : const Color(0xfffff9df))
        : ThemeManager.getInstance().getCardBackgroundColor(
            defaultColor: Colors.white,
          );

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
        // height: 115,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isClockedToday
                ? const Color(0xffffe2a7)
                : ThemeManager.getInstance().getLineColor(
                    defaultColor: const Color(0xffedf1fb),
                  ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.10 : 0.035),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        // padding: EdgeInsets.only(
        //     top: Utility.isHandsetBySize() ? 3 : 6,
        //     bottom: Utility.isHandsetBySize() ? 3 : 6),
        margin: EdgeInsets.only(
            top: 5,
            bottom: Utility.isHandsetBySize() ? 0 : 8,
            left: 10,
            right: 10),
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: missionColor.withValues(
                      alpha: isClockedToday ? 0.42 : 0.22,
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                  ),
                ),
              ),
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
                    const SizedBox(width: 10),
                    Expanded(
                      // 底部连续/累计打卡文案在窄侧栏里很容易变长，必须限制成单行省略，避免右侧出现 Flutter overflow 黄黑条。
                      child: Text(
                        getI18NKey().clockin_n_days_continuously(Utility
                                .totalFlomoMissionClockInFinishedContinuouslyAtYmdTimeStamp(
                              flomoMissionModel: flomoMissionModel,
                              curTimeStamp: this
                                  .widget
                                  .curDateTime
                                  .millisecondsSinceEpoch,
                            ).toString()) +
                            "-" +
                            getI18NKey().clockin_n_days_totally(
                                Utility.totalFlomoMissionClockInFinished(
                              clockInMap: flomoMissionModel.clockIn ?? {},
                              daily_num_times:
                                  flomoMissionModel.daily_num_times,
                            ).toString()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Color(0xff999999), fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                )
              ],
            ),
            Positioned(
              top: 38,
              right: 0,
              child: // 完成不需要显示
                  this.widget.missionModel.isFinished == true
                      ? SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            this
                                .widget
                                .onTapClockInListener
                                ?.call(this.widget.missionModel);
                          },
                          child: Container(
                            // alignment: Alignment(0.3,-1),
                            padding: EdgeInsets.only(top: 15),
                            alignment: Alignment.topCenter,
                            height: 100,
                            width: 70,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0,
                                    Utility.isHandsetBySize() ? 0 : 10, 0),
                                child: ConfirmButton(
                                  isChecked:
                                      this.percentClocksIn >= 1 ? true : false,
                                )),
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlomoMissionModel _missionModel = this.widget.missionModel;
    percentClocksIn = Utility.getPercentOfNumClocksIn(
        missionModel: this.widget.missionModel, ymd: this.widget.ymd);
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
              color: ThemeManager.getInstance()
                  .getCardBackgroundColor(defaultColor: Colors.white),
              borderRadius: BorderRadius.circular(40)),
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
                            color: ThemeManager.getInstance().getTextColor(
                                defaultColor: ColorsConfig.gray_40))),
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
                      this.widget.missionModel.alert_times.isNotEmpty
                          ? Utility.formatHourAndMin2(
                              Utility.getTheLatestTimesFromNow(
                                  this.widget.missionModel.alert_times))
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
      key: ValueKey(_missionModel),
      enabled: (DeviceInfoManagement.isMoible() == true ||
          DeviceInfoManagement.isWebMobileBySize() ||
          DeviceInfoManagement.isIOS()),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: ratio,
        children: _missionModel.isFinished == false
            ? getUnfinishedSlidableItems(_missionModel)
            : getFinishedSlidableItems(_missionModel),
      ),
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
        child: getItem(childrenRow, _missionModel),
      ),
    );
  }

  List<Widget> getFinishedSlidableItems(FlomoMissionModel _missionModel) {
    return [
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapUnfinishListener != null)
            this.widget.onTapUnfinishListener!(_missionModel);
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        icon: Icons.cancel_outlined,
        label: getI18NKey().unfinished, // 添加label以替代旧版中的caption
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete, // 添加label以替代旧版中的caption
      ),
    ];
  }

  List<Widget> getUnfinishedSlidableItems(FlomoMissionModel _missionModel) {
    return [
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapFinishListener != null)
            this.widget.onTapFinishListener!(_missionModel);
        },
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        icon: Icons.check,
        label: getI18NKey().finish, // 添加label以替代旧版中的caption
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapEditListener != null)
            this.widget.onTapEditListener!(_missionModel);
        },
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        label: getI18NKey().edit, // 添加label以替代旧版中的caption
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapCancelClockInListener != null)
            this.widget.onTapCancelClockInListener!(_missionModel);
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        icon: Icons.cancel_outlined,
        label: getI18NKey().cancel_latest_clockin, // 添加label以替代旧版中的caption
      ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onTapDeleteListener != null)
            this.widget.onTapDeleteListener!(_missionModel);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getI18NKey().delete, // 添加label以替代旧版中的caption
      ),
    ];
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
                color: ThemeManager.getInstance()
                    .getCardBackgroundColor(defaultColor: Colors.white),
                padding: EdgeInsets.symmetric(
                    horizontal: marginLeftRight, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            getI18NKey().everyDayOnce(
                                this.widget.missionModel.daily_num_times),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xff8c8c8c), fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 6),
                        (this.isHover == true)
                            ? SizedBox.shrink()
                            : Flexible(
                                child: Text(
                                  this.widget.missionModel.inspration_message ??
                                      "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Color(0xff999999), fontSize: 12),
                                ),
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
          Align(
            alignment: Alignment.topRight,
            child: _buildOverflowMenu(_missionModel),
          )
        ],
      ),
    );
  }
}

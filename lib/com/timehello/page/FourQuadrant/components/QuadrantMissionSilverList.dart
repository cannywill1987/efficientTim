import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CheckImage.dart';
import 'package:time_hello/com/timehello/components/RatingBar.dart';
import 'package:time_hello/com/timehello/components/StateImage.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/StylesConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/actions.dart';
import 'package:time_hello/com/timehello/libs/flutter_slidable/src/slidable.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:time_hello/com/timehello/util/WidgetManager.dart';
import 'package:time_hello/r.dart';

import '../../../components/ListingSecurityWidget.dart';
import '../../../components/SubmissionColumnList.dart';
import '../../../config/Params.dart';
import '../../../libs/flutter_slidable/src/action_pane_motions.dart';
import '../../../util/DeviceInfoManagement.dart';
import '../../../util/ScreenUtil.dart';

typedef OnTapFinishListener = void Function(dynamic obj);
typedef OnTapEditListener = void Function(dynamic obj);
typedef OnTapEditTitleListener = void Function(dynamic obj);
typedef OnTapDeleteListener = void Function(dynamic obj);
typedef OnTapPlayListener = void Function(dynamic obj);
typedef OnDragEndListener = void Function(dynamic obj);

class QuadrantMissionSilverList extends StatefulWidget {
  List _datas = [];
  OnTapListener? onTapListener;
  OnTapListener? onTapCreateListener;
  MissionSilverState? menuSilverListState;
  OnTapEditTitleListener? onTapEditTitleListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  late OnDragEndListener onDragEndListener;
  OnTapFinishListener? onTapFinishListener;
  OnTapPlayListener? onTapPlayListener;
  bool? isSlideEnable;
  Function onDragingListener; // 拖动中
  GlobalKey quadrantWidgetGlobalKey;
  double containerWidth = 0;
  double containerHeight = 0;
  PriorityEnum priorityEnum; //拖动时的优先级来显示颜色 否则item是白色 需要自己加颜色
  QuadrantMissionSilverList(
      {Key? key,
      required List datas,
      OnTapListener? onTapListener,
      required this.containerHeight,
      required this.containerWidth,
      required this.onDragingListener,
      this.onTapFinishListener,
      required OnDragEndListener onDragEndListener,
      required this.priorityEnum,
      required this.quadrantWidgetGlobalKey,
        this.onTapCreateListener,
      this.onTapDeleteListener,
      this.onTapEditListener,
      this.onTapEditTitleListener,
      this.onTapPlayListener,
      this.isSlideEnable = true})
      : super(key: key) {
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
    return menuSilverListState = new MissionSilverState();
  }
}

class MissionSilverState extends State<QuadrantMissionSilverList> {
  double draggableItemWidth = 0;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return LongPressDraggable(
          onDragUpdate: (d) {
            double x = d.localPosition.dx;
            double y = d.localPosition.dy -
                (this
                            .widget
                            .quadrantWidgetGlobalKey!
                            .currentContext
                            ?.size
                            ?.height ==
                        null
                    ? 0
                    : ScreenUtil.getInstance().screenHeight -
                        (this
                                .widget
                                .quadrantWidgetGlobalKey!
                                .currentContext
                                ?.size
                                ?.height ??
                            0));
            // print("detal: ${d.delta.dx},localDx:${d.localPosition.dx} globalDx:${d.globalPosition.dx}");
            // print("x:${x} y:${y} width:${this.widget.containerWidth/2} height:${this.widget.containerHeight/2}");
            int index = 0;
            if (x < this.widget.containerWidth &&
                y < this.widget.containerHeight) {
              index = 0;
              // priorityEnum = PriorityEnum.red1;
              this.widget.onDragingListener.call(1);
            } else if (x > this.widget.containerWidth &&
                y < this.widget.containerHeight) {
              index = 2;
              // priorityEnum = PriorityEnum.blue2;
              this.widget.onDragingListener.call(2);
            } else if (x < this.widget.containerWidth &&
                y > this.widget.containerHeight) {
              index = 3;
              // priorityEnum = PriorityEnum.yellow3;
              this.widget.onDragingListener.call(3);
            } else if (x > this.widget.containerWidth &&
                y > this.widget.containerHeight) {
              index = 4;
              // priorityEnum = PriorityEnum.green4;
              this.widget.onDragingListener.call(4);
            }
            // print("index is:${index}");
          },
          onDragEnd: (d) {
            double screenWidth = ScreenUtil.getInstance().screenWidth ?? -1;
            double screenHeight = ScreenUtil.getInstance().screenHeight ?? -1;
            double x = d.offset.dx -
                (this
                            .widget
                            .quadrantWidgetGlobalKey!
                            .currentContext
                            ?.size
                            ?.width ==
                        null
                    ? 0
                    : ScreenUtil.getInstance().screenWidth -
                        (this
                                .widget
                                .quadrantWidgetGlobalKey!
                                .currentContext
                                ?.size
                                ?.width ??
                            0));
            double y = d.offset.dy -
                (this
                            .widget
                            .quadrantWidgetGlobalKey!
                            .currentContext
                            ?.size
                            ?.height ==
                        null
                    ? 0
                    : ScreenUtil.getInstance().screenHeight -
                        (this
                                .widget
                                .quadrantWidgetGlobalKey!
                                .currentContext
                                ?.size
                                ?.height ??
                            0));
            // print("width: ${width}, height: ${height}, x: ${x}, y: ${y}");
            PriorityEnum priorityEnum = this.widget.priorityEnum;
            if (x < (screenWidth / 2 - this.draggableItemWidth / 2) &&
                y < screenHeight / 2) {
              priorityEnum = PriorityEnum.red1;
            } else if (x > (screenWidth / 2 - this.draggableItemWidth / 2) &&
                y < screenHeight / 2) {
              priorityEnum = PriorityEnum.yellow2;
            } else if (x < (screenWidth / 2 - this.draggableItemWidth / 2) &&
                y > screenHeight / 2) {
              priorityEnum = PriorityEnum.blue3;
            } else if (x > (screenWidth / 2 - this.draggableItemWidth / 2) &&
                y > screenHeight / 2) {
              priorityEnum = PriorityEnum.green4;
            }

            MissionModel missionModel = this.widget._datas[index];
            if (priorityEnum != this.widget.priorityEnum) {
              if (this.widget.onDragEndListener != null &&
                  screenWidth != -1 &&
                  screenHeight != -1) {
                missionModel.priorityStatus = priorityEnum.index;
                this.widget.onDragEndListener(missionModel);
              }
            }
            this.widget.onDragEndListener(null);
          },
          feedback: Container(
            alignment: Alignment.center,
            width: this.draggableItemWidth =
                (ScreenUtil.getScreenW(context) - 50) / 2,
            //可拖曳组件的宽度,
            height: Utility.isHandsetBySize() ? 50 : 70,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                  colors: Utility.getBGColorByPrioritySelectedDraggable(
                      this.widget.priorityEnum)),
              border: new Border.all(
                  width: 1.0,
                  color:
                      Utility.getTextColorByPriority(this.widget.priorityEnum)),
              borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
              // borderRadius:
              //     const BorderRadius.all(const Radius.circular(8.0)),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: buildQuadrantMissionSilverListItem(index,
                    isDraggable: true)),
          ),
          child: buildQuadrantMissionSilverListItem(index, isDraggable: false));
    }, childCount: this.widget._datas.length));
  }

  QuadrantMissionSilverListItem buildQuadrantMissionSilverListItem(int index,
      {bool isDraggable: false}) {
    return QuadrantMissionSilverListItem(
      isSlideEnable: this.widget.isSlideEnable,
      onTapListener: this.widget.onTapListener,
      priorityEnum: this.widget.priorityEnum,
      isDraggable: isDraggable,
      index: index,
      missionModel: this.widget._datas[index],
      onTapEditTitleListener: this.widget.onTapEditTitleListener,
      onTapEditListener: this.widget.onTapEditListener,
      onTapDeleteListener: this.widget.onTapDeleteListener,
      onTapFinishListener: this.widget.onTapFinishListener,
      onTapPlayListener: this.widget.onTapPlayListener,
    );
  }
}

class QuadrantMissionSilverListItem extends StatefulWidget {
  OnTapListener? onTapListener;
  OnTapPlayListener? onTapPlayListener;
  int? index;
  bool? isVisible;
  bool? isSlideEnable = true;
  late MissionModel _missionModel;
  OnTapFinishListener? onTapFinishListener;
  OnTapEditListener? onTapEditListener;
  OnTapDeleteListener? onTapDeleteListener;
  OnTapEditTitleListener? onTapEditTitleListener;
  bool isDraggable;
  PriorityEnum priorityEnum;

  QuadrantMissionSilverListItem(
      {Key? key,
      bool isVisible = true,
      required this.priorityEnum,
      this.isDraggable = false,
      OnTapListener? onTapListener,
      required MissionModel missionModel,
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
    this._missionModel = missionModel;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw MenuSilverListItem(onTapListener);
    return QuadrantMissionSilverListItemState();
  }
}

class QuadrantMissionSilverListItemState
    extends State<QuadrantMissionSilverListItem> {
  bool isHover = false;
  double fontSize = Utility.isHandsetBySize() ? 11 : 15;

  List<Widget> getTagsTextView(MissionModel missionModel) {
    List<FolderModel> list = CONSTANTS
        .getFolderModelListFromStringList(missionModel.tagNames?.split(','));
    List<Widget> listWidget = [];
    for (int i = 0; i < list.length; i++) {
      FolderModel folderModel = list[i];
      listWidget.add(SizedBox(
        width: Utility.isHandsetBySize() ? 1 : 5,
      ));
      listWidget.add(Text("#" + (folderModel.title ?? ""),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
              color: Color(folderModel.color))));
    }
    return listWidget;
  }

  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );
  Container getContainerWithHeight({double? height, required Widget child}) {
    double draggableWidth =
        (ScreenUtil.getScreenW(context) - 50) / 2; //可拖曳组件的宽度

    if (height != null) {
      return Container(
        width:
            this.widget.isDraggable == true ? draggableWidth : double.infinity,
        constraints: BoxConstraints(minHeight: height),
        // height: height,
        padding: EdgeInsets.only(
            top: Utility.isHandsetBySize() ? 3 : 6,
            bottom: Utility.isHandsetBySize() ? 3 : 6),
        margin: EdgeInsets.only(
            bottom: Utility.isHandsetBySize() ? 0 : 2,
            left: CONSTANTS.missionPageMargin,
            right: CONSTANTS.missionPageMargin),
        alignment: Alignment.centerLeft,
        child: child,
      );
    } else {
      return Container(
        width:
            this.widget.isDraggable == true ? draggableWidth : double.infinity,
        padding: EdgeInsets.only(
            top: Utility.isHandsetBySize() ? 0 : 6,
            bottom: Utility.isHandsetBySize() ? 0 : 6),
        margin: EdgeInsets.only(
            bottom: Utility.isHandsetBySize() ? 0 : 2,
            left: CONSTANTS.missionPageMargin,
            right: CONSTANTS.missionPageMargin),
        alignment: Alignment.centerLeft,
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MissionModel _missionModel = this.widget._missionModel;
    // TODO: implement build
    //左边文案和角标
    if (Utility.isHandsetBySize() == false && this.widget.isDraggable == true) {
      fontSize = 12;
    }

    List<Widget> childrenRow = <Widget>[
      Container(
          width: Utility.isHandsetBySize() ? 25 : 40,
          // margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: CheckImage(
            width: Utility.isHandsetBySize() ? 25 : 40,
            height: Utility.isHandsetBySize() ? 25 : 40,
            isSizeConfigured: true,
            onTapListener: (res) {
              if (_missionModel.isFinished == true) {
                return;
              }
              if (this.widget.onTapFinishListener != null)
                this.widget.onTapFinishListener!(_missionModel);
            },
            checked: _missionModel.isFinished ?? false,
            checkIcon: Icon(Icons.check_circle,
                size: Utility.isHandsetBySize() ? 14 : 20,
                color: ColorsConfig.calendar_green),
            uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                color: ColorsConfig.gray_a7,
                size: Utility.isHandsetBySize() ? 14 : 20),
          )),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                    maxLines: (this.widget.isDraggable) ? 1 : 3,
                    TextSpan(
                      // text: 'Hello', // default text style
                        children: [
                          TextSpan(
                              text: this.widget._missionModel?.title ?? "",
                              style: ThemeManager.getInstance().getTextStyle(
                                  defaultTextStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      decoration: _missionModel?.isFinished == true
                                          ? TextDecoration.lineThrough
                                          : null,
                                      // decorationStyle: TextStyle(
                                      //     decoration: (_missionModel.isFinished ?? false)
                                      //         ? TextDecoration.lineThrough
                                      //         : null,
                                      //     decorationStyle: TextDecorationStyle.solid,
                                      //     decorationColor: Utility.getTextColorByPriority(
                                      //         this.widget.priorityEnum),
                                      //     decorationThickness: 3,
                                      //     fontWeight: FontWeight.w500,
                                      //     fontSize: fontSize,
                                      //     overflow: TextOverflow.ellipsis,
                                      //     color: ThemeManager.getInstance().getTextColor(
                                      //         defaultColor: ColorsConfig.gray_40)),
                                      decorationColor: Color(0xffa0a0a0),
                                      decorationThickness: 2,
                                      color: ColorsConfig.gray_40))),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [

                                  if ((_missionModel?.subMissions?.length ?? 0) >
                                      0) ...[
                                    Utility.getSVGPicture(R.assetsImgIcSubmission,
                                        size: 14),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _missionModel?.subMissions?.length
                                          .toString() ??
                                          "0",
                                      textAlign: TextAlign.left,
                                      style: ThemeManager.getInstance()
                                          .getTextStyle(
                                          defaultTextStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff9DA7B2))),
                                    ),
                                  ],
                                ],
                              )),
                          ...WidgetManager.getTagsWidgetSpan(
                              _missionModel ?? MissionModel(),
                              fontSize: 13),
                          ...WidgetManager.getIsNoteWidget(
                            _missionModel ?? MissionModel(),
                          ),
                        ])),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SubmissionColumnList(
                    missionModel: _missionModel ?? MissionModel(),
                  ),
                if ((_missionModel?.subMissions?.length ?? 0) > 0)
                  SizedBox(
                    height: 3,
                  ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if(Utility.shouldShowTomatoes(missionModelType: _missionModel?.missionModelType))
                    RatingBar(
                      curNumber: _missionModel.no_tomotoes_finished ?? 0,
                      number: _missionModel.total_tomotoes ?? 1,
                      size: Utility.isHandsetBySize()
                          ? 10
                          : this.widget.isDraggable
                              ? 12
                              : 15,
                    ),
                    if(Utility.shouldShowTomatoes(missionModelType: _missionModel?.missionModelType))
                    SizedBox(width: 3),
                    Icon(
                      Icons.calendar_today_rounded,
                      color: ColorsConfig.darkRed,
                      size: Utility.isHandsetBySize() ? 10 : 12,
                    ),
                    SizedBox(width: 2),
                    Text(
                      CONSTANTS.getDateStringSubtitle(_missionModel),
                      style: TextStyle(
                          fontSize: Utility.isHandsetBySize() ? 10 : 12,
                          color: ColorsConfig.darkRed),
                    )
                  ],
                )
              ]),
          flex: 3),
      // 完成不需要显示
      _missionModel.isFinished == true
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 0, Utility.isHandsetBySize() ? 0 : 10, 0),
              child: IconButton(
                  onPressed: () {
                    if (this.widget.onTapPlayListener != null) {
                      this.widget.onTapPlayListener!(_missionModel);
                    }
                  },
                  icon: Icon(
                    Icons.play_circle_outline,
                    color: Color(0xfffd5553),
                    size: Utility.isHandsetBySize() ? 16 : 18,
                  ))),
      DeviceInfoManagement.isMoible() == false
          ? SizedBox(
              width: 15,
            )
          : SizedBox(
              width: 0,
            )
    ];
    //组件可拖曳展示方式
    if (this.widget.isDraggable == true) {
      return getItem(childrenRow, _missionModel);
    }
    return Slidable(
      key: ValueKey(_missionModel),
      enabled: (DeviceInfoManagement.isMoible() == true ||
          DeviceInfoManagement.isWebMobileBySize()) &&
          _missionModel.isFinished == false,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: ratio,
        children: <Widget>[
          SlidableAction(
            onPressed: (context) {
              if (this.widget.onTapFinishListener != null) {
                this.widget.onTapFinishListener!(_missionModel);
              }
            },
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Finish',  // 添加label以替代旧版中的caption
          ),
          SlidableAction(
            onPressed: (context) {
              if (this.widget.onTapEditListener != null) {
                this.widget.onTapEditListener!(_missionModel);
              }
            },
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',  // 添加label以替代旧版中的caption
          ),
          SlidableAction(
            onPressed: (context) {
              if (this.widget.onTapDeleteListener != null) {
                this.widget.onTapDeleteListener!(_missionModel);
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',  // 添加label以替代旧版中的caption
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (this.widget.onTapListener != null) {
            this.widget.onTapListener!(_missionModel);
          }
        },
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
      ),
    );
  }

  Container getItem(List<Widget> childrenRow, MissionModel _missionModel) {
    return getContainerWithHeight(
      height: Utility.isHandsetBySize() == true ? 40 : null,
      child: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: childrenRow,
        ),
        Align(
            alignment: Alignment.topRight,
            child: (this.isHover == true && _missionModel.isFinished == false)
                ? PopupMenuButton<String>(
                    tooltip: '',
                    padding: EdgeInsets.only(left: 18, bottom: 20),
                    // offset: Offset(130, 30),
                    iconSize: 14,
                    icon: Icon(
                      Icons.more_vert,
                      color: ThemeManager.getInstance()
                          .getIconColor(defaultColor: Colors.black87),
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
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.check, size: fontSize),
                              SizedBox(width: 5),
                              Text(getI18NKey().finish,
                                  style: TextStyle(fontSize: fontSize)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'edit',
                          onTap: () {
                            //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
                            Future.delayed(Duration(milliseconds: 100), () {
                              this.widget.onTapEditListener!(_missionModel);
                            });
                          },
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.edit,
                                  color: Colors.green, size: fontSize),
                              SizedBox(width: 5),
                              Text(getI18NKey().edit,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: fontSize)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          //需要加延时，否则弹窗弹出来会造成这里pop没隐藏报错
                          value: 'delete',
                          onTap: () {
                            Future.delayed(Duration(milliseconds: 100), () {
                              this.widget.onTapDeleteListener!(_missionModel);
                            });
                          },
                          child: Wrap(
                            // runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.delete,
                                  color: ColorsConfig.red, size: fontSize),
                              SizedBox(width: 5),
                              Text(
                                getI18NKey().delete,
                                style: TextStyle(
                                    color: ColorsConfig.red,
                                    fontSize: fontSize),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  )
                : ListingSecurityWidget(
                    missionModdel_id: _missionModel?.objectId,
                    folder_id: _missionModel?.folder_id ?? "",
                    cryptoVersion: _missionModel?.cryptoVersion ?? -1,
                    marginRight: 5,
                    marginTop: 2,
                    size: 14,
                  ))
      ]),
    );
  }
}

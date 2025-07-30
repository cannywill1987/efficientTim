import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as FlutterReorderList;
import 'package:time_hello/com/timehello/util/BeanParser.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../models/DateTimeModel.dart';
import '../models/MissionModel.dart';
import '../models/SubmissionModel.dart';
import '../util/TextUtil.dart';
import 'CheckImage.dart';
// import 'package:flutter/src/widgets/reorderable_list.dart' hide ReorderableList;

enum DraggingMode {
  iOS,
  android,
}

class SubmissionSliverList extends StatefulWidget {
  MissionModel missionModel;
  Function onChange;

  SubmissionSliverList({Key? key,required this.missionModel, required this.onChange}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SubmissionSliverListState();
  }
}

class SubmissionSliverListState extends State<SubmissionSliverList> {
  late List<SubmissionModel> _items;
  DraggingMode _draggingMode = DraggingMode.iOS;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem =
        this.widget.missionModel.subMissionModels[draggingIndex];
    debugPrint("Reordering $item -> $newPosition");
    this.widget.missionModel.subMissionModels.removeAt(draggingIndex);
    this
        .widget
        .missionModel
        .subMissionModels
        .insert(newPositionIndex, draggedItem);
    this.widget.missionModel.subMissionModels =
        this.widget.missionModel.subMissionModels;
    setState(() {});
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem =
        this.widget.missionModel.subMissionModels[_indexOfKey(item)];
    this.widget.missionModel.subMissions = this.widget.missionModel.subMissions;
    this.widget.onChange.call(this.widget.missionModel);
    debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return this
        .widget
        .missionModel
        .subMissionModels
        .indexWhere((SubmissionModel d) => d.key == key);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterReorderList.ReorderableList(
      onReorder: _reorderCallback,
      onReorderDone: _reorderDone,
      child: CustomScrollView(
        // cacheExtent: 3000,
        slivers: <Widget>[
          SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SumissionSliverListItem(
                      // key: _items[index].key,
                      data: this.widget.missionModel.subMissionModels[index],
                      // first and last attributes affect border drawn during dragging
                      isFirst: index == 0,
                      isLast: index ==
                          this.widget.missionModel.subMissionModels.length - 1,
                      draggingMode: _draggingMode,
                      onClickDelete: (data) {
                        List list = this.widget.missionModel.subMissionModels;
                        list.remove(data);
                        this.widget.missionModel.subMissionModels =
                            this.widget.missionModel.subMissionModels;
                        this.widget.missionModel.subMissions =
                            this.widget.missionModel.subMissions;
                        this.widget.onChange.call(this.widget.missionModel);
                        setState(() {});
                      },
                      onClickAlarm: (SubmissionModel data) async {
                        //没有权限提醒设置权限
                        DateTimeModel? model;
                        TimeOfDay? timeOfDay;
                        // if (this.widget.missionModel?.repetiveType == 0) {
                        model = await Utility.showDateTimePickerDialog(context);
                        if (model == null) {
                          return;
                        }
                        // this.alertTimeModel = model;
                        data.notificationTime = model.timestamp ?? -1; //设置提醒时间
                        this.widget.missionModel.subMissionModels =
                            this.widget.missionModel.subMissionModels;
                        this.widget.onChange.call(this.widget.missionModel);
                        setState(() {});
                        // } else {
                        //   //每日提醒四件
                        //   timeOfDay =
                        //       await Utility.showTimePickerDialog(context);
                        //   if (timeOfDay == null) {
                        //     return;
                        //   }
                        //   data.notificationTime =
                        //       timeOfDay.hour * 60 * 60 * 1000 +
                        //           timeOfDay.minute * 60 * 1000;
                        //   this.widget.missionModel.subMissionModels = this.widget.missionModel.subMissionModels;
                        //   this.widget.onChange.call(this.widget.missionModel);
                        // }
                      },
                      onClickFinish: (data) {
                        List<SubmissionModel> list =
                            this.widget.missionModel.subMissionModels;
                        this.widget.missionModel.subMissionModels = list;
                        this.widget.onChange.call(this.widget.missionModel);
                      },
                      onClickOnfocus: (res) {
                        if (res == false) {
                          if (!TextUtil.isEmpty(
                              this.widget.missionModel.title)) {
                            this.widget.onChange.call(this.widget.missionModel);
                          }
                        }
                      },
                      onSubmitListener: () {
                        //点击submit就提交换行

                        // Navigator.of(context).pop();
                        // GlobalKey key = GlobalKey();
                        insertNewAtIndex(index);
                        // this.widget?.okCallBack!(curSliderVal);
                      },
                      onChangeListener: (val) {
                        this.widget.missionModel.subMissionModels[index] = val;
                        this.widget.onChange.call(this.widget.missionModel);
                        // this.widget.missionModel.subMissionModels[index].title = val;
                        // this.widget.missionModel.subMissionModels = this.widget.missionModel.subMissionModels;
                        // this.widget.onChange.call(this.widget.missionModel);
                      },
                    );
                  },
                  childCount: this.widget.missionModel.subMissionModels.length,
                ),
              )),
        ],
      ),
    );
  }

  void addItem() {
    insertNewAtIndex(this.widget.missionModel.subMissionModels.length-1);
  }

  void insertNewAtIndex(int index) {
     int key = Utility.getRandom(from: 0, max: 10000000);
    // GlobalKey<SumissionSliverListItemState> key;
    SubmissionModel item;
    List<SubmissionModel> list =
        this.widget.missionModel.subMissionModels;
    list.insert(
        index + 1,
        item = SubmissionModel(
            key: ValueKey(key),
            isFinished: false,
            id: key,
            shouldFocus: true,
            title: "",
            notificationTime: -1,
            numToamatoesFocused: 0,
            numToamatoTotal: 0,
            create_time: Utility.getTimeStampToday(),
            update_time: Utility.getTimeStampToday()));
    this.widget.missionModel.subMissionModels = list;
    print(
        "key is ${item.key}, item ${item.shouldFocus}, value is ${item.title}");
    // this.widget.onChange.call(this.widget.missionModel);
     this.widget.onChange.call(this.widget.missionModel);
    if (mounted == true) {
      setState(() {
        //   Future.delayed(Duration(milliseconds: 1000), () {
        //     print(key.currentState);
        //     key.currentState?.requestFocus();
        //   });
        //   // key.
      });
    }
  }
}

class SumissionSliverListItem extends StatefulWidget {
  final Function onClickDelete;
  final Function onClickAlarm;
  final Function onClickOnfocus;
  final Function onClickFinish;
  final Function onSubmitListener;
  final Function onChangeListener;
  final SubmissionModel data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  const SumissionSliverListItem({
    Key? key,
    required this.onClickFinish,
    required this.onClickAlarm,
    required this.onChangeListener,
    required this.onClickDelete,
    required this.onClickOnfocus,
    required this.onSubmitListener,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SumissionSliverListItemState();
  }
}

class SumissionSliverListItemState extends State<SumissionSliverListItem> {
  FocusNode focusNode = FocusNode();
  String? originTitle;

  initState() {
    this.originTitle = this.widget.data.title;
    print(
        "begin request focusing: key is ${this.widget.data.id}, item ${this.widget.data.shouldFocus}, value is ${this.widget.data.title}");
    requestFocus();
    // print("begin request focusing: ${this.widget.data.shouldFocus}");
    // Future.delayed(Duration(milliseconds: 800), () {
    //   this.requestFocus();
    // });
  }

  requestFocus() {
    //失去焦点 打印unfocus 获取焦点打印focus

    Future.delayed(Duration(milliseconds: 100), () {
      focusNode.addListener(() {
        print("title: ${this.widget.data.title}");
        if (focusNode.hasFocus) {
          print('Focus');
        } else {
          print('Unfocus');
        }
        if (this.originTitle != this.widget.data.title) {
          this.originTitle = this.widget.data.title;
          this.widget.onClickOnfocus.call(focusNode.hasFocus);
        }
      });
      if (this.widget.data.shouldFocus == true) {
        print("request focus");
        this.widget.data.shouldFocus = false;
        FocusScope.of(context).requestFocus(focusNode);
      }
      // else {
      //   focusNode.removeListener(() {});
      // }
    });
  }

  @override
  void didUpdateWidget(covariant SumissionSliverListItem oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    this.requestFocus();
  }

  Widget _buildChild(
      BuildContext context, FlutterReorderList.ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == FlutterReorderList.ReorderableItemState.dragProxy ||
        state == FlutterReorderList.ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Color(0xD0FFFFFF)));
    } else {
      bool placeholder =
          state == FlutterReorderList.ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: this.widget.isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: this.widget.isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white));
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = this.widget.draggingMode == DraggingMode.iOS
        ? FlutterReorderList.ReorderableListener(
            child: Container(
              padding: const EdgeInsets.only(right: 6.0, left: 6.0),
              // color: const Color(0x08000000),
              child:  Center(
                child: Icon(
                  Icons.reorder,
                  color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xFF888888)),
                  size: 20,
                ),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity:
                state == FlutterReorderList.ReorderableItemState.placeholder
                    ? 0.0
                    : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CheckImage(
                    width: 40,
                    height: 40,
                    isSizeConfigured: true,
                    onTapListener: (res) {
                      this.widget.data.isFinished =
                          !this.widget.data.isFinished;
                      this.widget.onClickFinish.call(this.widget.data);
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    checked: this.widget.data.isFinished ?? false,
                    checkIcon: Icon(Icons.check_circle,
                        size: 20, color: ColorsConfig.calendar_green),
                    uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                        color: ThemeManager.getInstance().getIconColor(defaultColor: ColorsConfig.gray_a7), size: 20),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      //textfield不需要下划线和任何decoration和下划线
                      child: TextField(
                          focusNode: focusNode,
                          onChanged: (val) {
                            this.widget.data.title = val;
                            // if (this.widget.onChangeListener != null) {
                            this.widget.onChangeListener.call(this.widget.data);
                            // }
                          },
                          onSubmitted: (String value) {
                            if (this.widget.onSubmitListener != null) {
                              this.widget.onSubmitListener.call();
                            }

                            print(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: ThemeManager.getInstance().getTextColor(defaultColor: Color(0xff909090)),
                            ),
                          ),
                          controller: TextEditingController(
                            text: this.widget.data.title,
                          ),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Spacer(),
                  this.widget.data.notificationTime < 0 ||
                          this.widget.data.notificationTime == null
                      ? SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            this.widget.onClickAlarm.call(this.widget.data);
                          },
                          child: Text(
                            CONSTANTS.getAlertDateString(
                                Utility.getDateTimeModelFromTimeStamp(
                                    this.widget.data.notificationTime ?? 0)),
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff909090)),
                          ),
                        ),
                  SizedBox(
                    width: 7,
                  ),
                  InkWell(
                    onTap: () {
                      this.widget.onClickAlarm.call(this.widget.data);
                    },
                    child: Icon(
                      Icons.alarm_on,
                      color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xff909090)),
                      size: 17,
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  InkWell(
                    onTap: () {
                      this.widget.onClickDelete.call(this.widget.data);
                    },
                    child: Icon(
                      Icons.delete,
                      color: ThemeManager.getInstance().getIconColor(defaultColor: Color(0xff909090)),
                      size: 17,
                    ),
                  ),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (this.widget.draggingMode == DraggingMode.android) {
      content = FlutterReorderList.DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterReorderList.ReorderableItem(
        key: this.widget.data.key ??
            ValueKey(Utility.getRandom(from: 0, max: 1000000)), //
        childBuilder: _buildChild);
  }
}

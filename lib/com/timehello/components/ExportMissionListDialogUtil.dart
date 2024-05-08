import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../main.dart';
import '../beans/ResourceDeliveryInfoBean.dart';
import '../config/CONSTANTS.dart';
import '../config/ColorsConfig.dart';
import '../config/Params.dart';
import '../models/CheckButtonStateModel.dart';
import '../util/SharePreferenceUtil.dart';
import '../util/WidgetManager.dart';
import 'CheckButtonListWidget.dart';
import 'CustomMarquee.dart';
import 'CustomTitileWidget.dart';
import 'ScrollableCheckButtonListWidget.dart';

class ExportMissionListDialogUtil {
  static show(
    BuildContext mContext, {
    String? title,
    String? content,
    TextEditingController? textEditingController,
    String initVal = "123",
    OnTapListener? onTapListener,
    Function? okCallBack,
    Function? export,
  }) {
    title = title ?? "";
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          return ExportMissionListDialog(
            title: title,
            content: content,
            leftText: getI18NKey().export_excel,
            initVal: initVal,
            rightText: getI18NKey().confirm,
            okCallBack: okCallBack,
            textEditingController: textEditingController,
            onTapListener: onTapListener,
            export: export,
          );
        });
    // showDialog(
    //     context: mContext,
    //     builder: (BuildContext context) {
    //       return DialogContent(
    //           title: title,
    //           content: content,
    //           leftText: leftText,
    //           initVal: initVal,
    //           rightText: rightText,
    //           counterEnum: counterEnum,
    //           okCallBack: okCallBack,
    //           onTapListener: onTapListener,
    //           cancelCallBack: cancelCallBack,
    //           okRouteUri: okRouteUri,
    //           input: input);
    //     });
  }
}

class ExportMissionListDialog extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? export; //左边回调
   OnTapListener? onTapListener;
   String? initVal;
  TextEditingController? textEditingController;

  ExportMissionListDialog({
    Key? key,
    this.onTapListener,
    this.title,
    this.content,
    this.textEditingController,
    this.leftText,
    this.rightText,
    this.onlyRight,
    this.okCallBack,
    this.initVal,
    this.export,
  }) : super(key: key);

  @override
  ExportMissionListDialogState createState() => ExportMissionListDialogState(
        onTapListener: this.onTapListener,
        title: this.title,
        content: this.content,
        leftText: this.leftText,
        rightText: this.rightText,
        onlyRight: this.onlyRight,
        textEditingController: this.textEditingController,
        initVal: this.initVal,
      );
}

class ExportMissionListDialogState extends State<ExportMissionListDialog> {
  String? label = '';
  String? initVal = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   OnTapListener? onTapListener;
  TextEditingController? textEditingController = TextEditingController();
  List listCurCheckButtonModels = [];
  FixedExtentScrollController durationScrollController =
      FixedExtentScrollController(initialItem: 0);
  double maxHeight = 800;
  MissionOrderEnum missionOrderEnum = MissionOrderEnum.orderByWords;

  ExportMissionListDialogState({
    this.onTapListener,
    this.textEditingController,
    this.title,
    this.content,
    this.leftText,
    this.rightText,
    this.onlyRight,
    this.initVal,
  }) {
    // textEditingController.text = this.initVal ?? '';
  }

  @override
  void didUpdateWidget(ExportMissionListDialog oldWidget) {
    // this.onTapListener
  }

  @override
  void initState() {
    super.initState();
    listCurCheckButtonModels = CONSTANTS.getExportButtonsList();
  }

  @override
  void didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    // textfieldInputController.text = this.title;
    return new Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        //自定义dialog布局
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    color: ThemeManager.getInstance().getDialogBackgroundColor(defaultColor: Colors.white),
                    constraints: BoxConstraints(
                        maxHeight: this.maxHeight, maxWidth: 500),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomMarquee(
                          bean: MarqueInfo.marqueExportXls,
                        ),
                        SizedBox(height: 10),
                        CustomTitileWidget(
                          text: '${getI18NKey().select_contents}' +
                              (Utility.isHandsetBySize()
                                  ? '(${getI18NKey().slide_left_right})'
                                  : ''),
                        ),
                        SizedBox(height: 10),
                        ScrollableCheckButtonListWidget(
                          unit: "",
                          isMultiSelected: true,
                          onTapListener: (res) {
                            this.listCurCheckButtonModels = res['data'];
                            this.widget?.onTapListener!({
                              "enum": this.missionOrderEnum,
                              "data": this.listCurCheckButtonModels
                            });
                            setState(() {});
                          },
                          list: CONSTANTS.getExportButtonsList(),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 5,
                          ),
                          alignment: Alignment.centerLeft,
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: ColorsConfig.gray_40,
                                    fontWeight: FontWeight.bold),
                              ),
                              getPopupMenu()
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                            child: Container(
                          // height: 650,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
                          child: TextField(
                            controller: textEditingController,
                            onChanged: (data) {},
                            keyboardType: TextInputType.multiline,
                            maxLines: 40,
                            //不限制行数
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: getI18NKey().note,
                                hintStyle: new TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(187, 187, 187, 1))),
                          ),
                        )),
                        SizedBox(height: 10),
                        new ButtonBar(
                          children: <Widget>[
                            new ElevatedButton(
                              child: new Text(getI18NKey().export_excel),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) {
                                      //默认状态使用灰色
                                      return Colors.black;
                                    },
                                  ),
                                  //背景颜色
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    //设置按下时的背景颜色
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.white;
                                    }
                                    //默认不使用背景颜色
                                    return Colors.white;
                                  }),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          fontSize: 18, color: Colors.black))),
                              onPressed: () {
                                if (this.widget.export != null) {
                                  this.widget.export!(null);
                                }
                              },
                            ),
                            new ElevatedButton(
                              child: new Text(
                                getI18NKey().copy,
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) {
                                      //默认状态使用灰色
                                      return Colors.black;
                                    },
                                  ),
                                  //背景颜色
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    //设置按下时的背景颜色
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.blueAccent;
                                    }
                                    //默认不使用背景颜色
                                    return Colors.blue;
                                  }),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          fontSize: 18, color: Colors.black))),
                              onPressed: () {
                                Utility.copyToClipboard(
                                    textEditingController?.text ?? "");
                              },
                            ),
                            RawKeyboardListener(
                                autofocus: true,
                                onKey: (event) {
                                  if (event.runtimeType == RawKeyDownEvent) {
                                    if (event.physicalKey ==
                                        PhysicalKeyboardKey.enter) {
                                      if(this.widget?.okCallBack != null) {
                                        this.widget?.okCallBack!(
                                            listCurCheckButtonModels);
                                      }
                                    }
                                  }
                                },
                                focusNode: FocusNode(),
                                child: new ElevatedButton(
                                  child: new Text(getI18NKey().confirm),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) {
                                          //默认状态使用灰色
                                          return Colors.white;
                                        },
                                      ),
                                      //背景颜色
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        //设置按下时的背景颜色
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.red;
                                        }
                                        //默认不使用背景颜色
                                        return Colors.red;
                                      }),
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(
                                              fontSize: 18,
                                              color: Colors.red))),
                                  onPressed: () {
                                    Utility.popNavigator(context);
                                    if(this
                                        .widget
                                        ?.okCallBack != null) {
                                      this.widget?.okCallBack!(
                                          listCurCheckButtonModels);
                                    }
                                  },
                                )),
                          ],
                        )
                      ],
                    ))),
          )
        ]));
  }

  Container getPopupMenu() {
    return Container(
        margin: EdgeInsets.only(right: CONSTANTS.missionPageMargin),
        child: PopupMenuButton<String>(
          tooltip: '',
          padding: EdgeInsets.all(20.0),
          child: Container(
            width: 40,
            height: 35,
            decoration: BoxDecoration(
                color: ThemeManager.getInstance().getCardBackgroundColor(defaultColor: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Icon(
              Icons.swap_vert,
              size: 30,
              color: ThemeManager.getInstance().getIconColor(defaultColor: Colors.red),
            ),
          ),
          onSelected: (String val) {
            if (val == 'order_by_list') {
              this.missionOrderEnum = MissionOrderEnum.orderByWords;
            } else if (val == 'order_by_time') {
              this.missionOrderEnum = MissionOrderEnum.orderByTime;
            } else if (val == 'order_by_mission_priority') {
              this.missionOrderEnum = MissionOrderEnum.orderByPriority;
            } else if (val == 'order_by_created_time') {
              this.missionOrderEnum = MissionOrderEnum.orderByCreatedTime;
            } else if (val == 'update_time_last_time') {
              this.missionOrderEnum = MissionOrderEnum.orderByUpdateTime;
            }
            SharePreferenceUtil.getSyncInstance()
                .setMissionOrderEnum(missionOrderEnum, mode: "export_xls");
            this.widget.onTapListener!({
              "enum": this.missionOrderEnum,
              "data": this.listCurCheckButtonModels
            });
            setState(() {});
          },
          itemBuilder: (context) {
            // PopupMenuButtonStateGlobalKey.currentState.mounted = true;
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'order_by_list',
                child: Text(getI18NKey().order_by_list,
                    style: TextStyle(fontSize: 13)),
              ),
              PopupMenuItem<String>(
                value: 'order_by_time',
                child: Text(
                  getI18NKey().order_by_time,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              PopupMenuItem<String>(
                value: 'order_by_created_time',
                child: Text(
                  getI18NKey().order_by_created_time,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              PopupMenuItem<String>(
                value: 'update_time_last_time',
                child: Text(
                  getI18NKey().order_by_update_time,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              PopupMenuItem<String>(
                value: 'order_by_mission_priority',
                child: Text(
                  getI18NKey().order_by_mission_priority,
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ];
          },
        ));
  }
}

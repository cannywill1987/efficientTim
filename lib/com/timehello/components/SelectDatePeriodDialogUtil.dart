import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/models/WeekendCheckModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'CheckImage.dart';
import 'WeekendWidget.dart';

typedef OnTapCreateTagListener = void Function(dynamic obj);

GlobalKey<DialogContentState> DialogContentStateGlobalKey = GlobalKey();

GlobalKey<WeekendWidgetState> weekendWidgetStateGlobalKey = GlobalKey();

class SelectDatePeriodDialogUtil {
  // static DialogContent dialogContent;

  static show(BuildContext mContext,
      {String? title,
      bool? onlyRight = false,
      String? content,
      String? leftText,
      String? rightText,
      List<SheetDataModel>? list,
      OnTapListener? onTapListener,
      OnTapCreateTagListener? onTapCreateTagListener,
      Function? okCallBack,
      Function? cancelCallBack,
      String okRouteUri = "",
      bool input = false}) {
    title = title ?? getI18NKey().repeat;
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return DialogContent(
              key: DialogContentStateGlobalKey,
              title: title,
              leftText: leftText,
              rightText: rightText,
              onlyRight: onlyRight,
              okCallBack: okCallBack,
              list: list ?? [],
              onTapListener: onTapListener,
              cancelCallBack: cancelCallBack,
              onTapCreateTagListener: onTapCreateTagListener,
              okRouteUri: okRouteUri,
              input: input);
          // } else {
          //   return dialogContent;
          // }
        });
  }
}

class DialogContent extends StatefulWidget {
   String? title; //标题
  String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
   List<SheetDataModel>? list;
  List<CheckModel>? listCheckModels = CONSTANTS.getWeekendCheckModels();

   OnTapListener? onTapListener;
   OnTapCreateTagListener? onTapCreateTagListener;
  DialogContentState? dialogContentState;

  DialogContent(
      {Key? key,
      this.onTapCreateTagListener,
      this.onTapListener,
      this.title,
      this.leftText,
      this.rightText,
      this.onlyRight,
      this.okCallBack,
      this.list,
      this.cancelCallBack,
      this.okRouteUri,
      this.input})
      : super(key: key);

  @override
  DialogContentState createState() => dialogContentState = DialogContentState(
      onTapCreateTagListener: this.onTapCreateTagListener,
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
      listCheckModels: this.listCheckModels,
      okCallBack: this.okCallBack,
      list: this.list,
      cancelCallBack: this.cancelCallBack,
      okRouteUri: this.okRouteUri,
      input: this.input);
}

class DialogContentState extends State<DialogContent> {
  String? label = '';
   String? title; //标题
   String? content; //内容
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   bool? onlyRight; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
  int? valueMiddleSelected = 1;
  int? valueRightSelected = 1;
  List<SheetDataModel>? list;
  List<CheckModel>? listCheckModels = [];
   OnTapListener? onTapListener;
   OnTapCreateTagListener? onTapCreateTagListener;
  SheetDataModel? _sheetDataModelCur = null;
  FixedExtentScrollController middleScrollController =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController rightScrollController =
      FixedExtentScrollController(initialItem: 0);

  DialogContentState(
      {this.onTapCreateTagListener,
      this.onTapListener,
      this.title,
      this.list,
      this.content,
      this.leftText,
        this.listCheckModels,
      this.rightText,
      this.onlyRight,
      this.okCallBack,
      this.cancelCallBack,
      this.okRouteUri,
      this.input});

  // @override
  // void didUpdateWidget(DialogContent oldWidget) {
  //
  // }

  @override
  void initState() {
    super.initState();
  }

  setCheck(List<SheetDataModel> list, int index) {
    list.forEach((data) {
      if (data.index == index) {
        data.isChecked = true;
      } else {
        data.isChecked = false;
      }
    });
    setState(() {
      this.list = list;
    });
  }

  getContentView() {
    List<Widget> list = [];
    List<SheetDataModel> listModels = this.list ?? [];
    for (int i = 0; i < listModels.length; i++) {
      SheetDataModel data = listModels[i];
      list.add(InkWell(
        onTap: () {
          if (this.onTapListener != null) {
            setCheck(this.list ?? [], data.index ?? 0);
            this._sheetDataModelCur = data;
            this.onTapListener!(data);
          }
        },
        child: Container(
            height: 60,
            padding: new EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    data.icon ?? SizedBox.shrink(),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      data.title ?? '',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                CheckImage(
                  checked: data.isChecked ?? false,
                  checkIcon: Icon(Icons.radio_button_checked_outlined,
                      color: ColorsConfig.gray_a7),
                  uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                      color: ColorsConfig.gray_a7),
                ),
              ],
            )),
      ));
    }
    return Column(
      children: list,
    );
  }

  resetWeekendDatas() {
    weekendWidgetStateGlobalKey.currentState?.resetDatas();
  }

  getCreateTagWidget() {
    List<Widget> list = [];
    List<SheetDataModel> listModels = this.list ?? [];
    list.add(InkWell(
      onTap: () {
        if (this.onTapCreateTagListener != null) {
          this.onTapCreateTagListener!(null);
        }
      },
      child: Container(
          height: 60,
          padding: new EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.add,
                    size: 14,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    getI18NKey().createTag,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          )),
    ));
    return Column(
      children: list,
    );
  }

  @override
  void didChangeDependencies() {
  }

  @override
  Widget build(BuildContext context) {
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
                  color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
                  constraints:
                      BoxConstraints(maxHeight: 500, maxWidth: 500),
                  // color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(title ?? "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Text(
                          CONSTANTS.getRepetiveDateString(
                                  this.valueMiddleSelected ?? 0,
                                  this.valueRightSelected ?? 0,
                                  this.listCheckModels ?? []) ??
                              "",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400)),
                      SizedBox(height: 10),
                      Container(
                          height: 200,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment(-0.5, 0),
                                child: new Text(
                                  getI18NKey().each,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Align(
                                child: Container(
                                  width: 80,
                                  child: new ListWheelScrollView.useDelegate(
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        valueMiddleSelected = index + 1;
                                      });
                                    },
                                    controller: middleScrollController,
                                    physics: FixedExtentScrollPhysics(
                                      parent: BouncingScrollPhysics(),
                                    ),
                                    itemExtent: 30,
                                    overAndUnderCenterOpacity: 0.2,
                                    childDelegate:
                                        ListWheelChildLoopingListDelegate(
                                      children: List<Widget>.generate(
                                        30,
                                        (index) => Text(
                                          '${index + 1}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment(0.5, 0),
                                child: Container(
                                  width: 80,
                                  child: new ListWheelScrollView(
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        this.valueRightSelected = index + 1;
                                      });
                                      if (this.valueRightSelected != 1) {
                                        this.listCheckModels = [];
                                        this.resetWeekendDatas();
                                      }
                                    },
                                    controller: rightScrollController,
                                    physics: FixedExtentScrollPhysics(
                                      parent: BouncingScrollPhysics(),
                                    ),
                                    itemExtent: 30,
                                    overAndUnderCenterOpacity: 0.2,
                                    children: <Widget>[
                                      Text(getI18NKey().day),
                                      Text(getI18NKey().week),
                                      Text(getI18NKey().month),
                                      Text(getI18NKey().year),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      WeekendWidget(
                          list: this.widget.listCheckModels ?? [],
                          key: weekendWidgetStateGlobalKey,
                          onCheckedListener: (days) async {
                            rightScrollController.jumpToItem(1);
                            this.setState(() {
                              this.listCheckModels = days;
                            });
                            print(days);
                          }),
                      new ButtonBar(
                        children: <Widget>[
                          new ElevatedButton(
                            child: new Text(getI18NKey().cancel),
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
                                    MaterialStateProperty.resolveWith((states) {
                                  //设置按下时的背景颜色
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white;
                                  }
                                  //默认不使用背景颜色
                                  return Colors.white;
                                }),
                                textStyle: MaterialStateProperty.all(TextStyle(
                                    fontSize: 18, color: Colors.black))),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (this.cancelCallBack != null) {
                                this.cancelCallBack!();
                              }
                            },
                          ),
                          new ElevatedButton(
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
                                    MaterialStateProperty.resolveWith((states) {
                                  //设置按下时的背景颜色
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.red;
                                  }
                                  //默认不使用背景颜色
                                  return Colors.red;
                                }),
                                textStyle: MaterialStateProperty.all(TextStyle(
                                    fontSize: 18, color: Colors.red))),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (this.okCallBack != null) {
                                this.okCallBack!(this.valueMiddleSelected, this.valueRightSelected, this.listCheckModels);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ))),
        )
      ]),
    );
  }
}

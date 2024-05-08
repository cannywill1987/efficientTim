import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'CustomTabBar.dart';

typedef OnClickFinishListener = void Function(int numTomatoes, int duration);

GlobalKey<DialogContentState> DialogContentStateGlobalKey = GlobalKey();

class SelectTomatoesDialogUtil {
  // static DialogContent dialogContent;

  static  show(BuildContext mContext,
      {String? title,
      bool onlyRight = false,
      String? content,
      String? leftText,
      String? rightText,
      List<SheetDataModel>? list,
      OnTapListener? onTapListener,
      int? numTomatoes,
      int? duration,
      Function? okCallBack,
      Function? cancelCallBack,
      String okRouteUri = "",
      bool shouldShowBottom = false,
      bool input = false}) {
    title = title ?? getI18NKey().remind;
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return DialogContent(
              key: DialogContentStateGlobalKey,
              title: title,
              content: content,
              leftText: leftText,
              rightText: rightText,
              onlyRight: onlyRight,
              numTomatoes: numTomatoes,
              shouldShowBottom: shouldShowBottom,
              duration: duration,
              okCallBack: okCallBack,
              list: list ?? [],
              onTapListener: onTapListener,
              cancelCallBack: cancelCallBack,
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
   OnTapListener? onTapListener;
  int? numTomatoes;
  int? duration;
  bool? shouldShowBottom;

  DialogContent(
      {Key? key,
      this.numTomatoes,
      this.duration,
      this.onTapListener,
      this.title,
      this.content,
      this.shouldShowBottom,
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
  DialogContentState createState() => DialogContentState(
      numTomatoes: this.numTomatoes ?? 0,
      duration: this.duration ?? 0,
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      shouldShowBottom: this.shouldShowBottom,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
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
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
  FixedExtentScrollController tomatoesScrollController =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController durationScrollController =
      FixedExtentScrollController(initialItem: 0);
  int numTomatoes = 0;
  int duration = 0;
  int? curTab = 0;
  bool? shouldShowBottom;

  DialogContentState(
      {this.numTomatoes = 0,
      this.duration = 0,
      this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.shouldShowBottom,
      this.rightText,
      this.onlyRight,
      this.okCallBack,
      this.list,
      this.cancelCallBack,
      this.okRouteUri,
      this.input}) {
    tomatoesScrollController =
        FixedExtentScrollController(initialItem: this.numTomatoes ?? 0);
    durationScrollController =
        FixedExtentScrollController(initialItem: this.duration ?? 0);
  }

  @override
  void didUpdateWidget(DialogContent oldWidget) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      //自定义dialog布局
      child: Stack(children: [
        Align(
          alignment: this.shouldShowBottom == true
              ? Alignment.bottomCenter
              : Alignment.center,
          child: ClipRRect(
              borderRadius: this.shouldShowBottom == true
                  ? BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14))
                  : BorderRadius.circular(14),
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  color: ThemeManager.getInstance().getDialogBackgroundColor(defaultColor: Colors.white),
                  constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
                  // color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      CustomTabBar(onCheckedListener: (data) {
                        setState(() {
                          this.curTab = data;
                        });
                      }),
                      SizedBox(height: 10),
                      Text(
                          getI18NKey().calculateTomatoesTime(
                              (1 + this.numTomatoes).toString(),
                              (1 + this.duration).toString(),
                              ((1 + this.numTomatoes) *
                                      (1 + this.duration) /
                                      60)
                                  .toInt()
                                  .toString(),
                              ((1 + this.numTomatoes) *
                                      (1 + this.duration) %
                                      60)
                                  .toInt()
                                  .toString()),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400)),
                      SizedBox(height: 10),
                      this.getTomatoesCount(this.curTab == 0),
                      this.getTomatoDurationCount(this.curTab == 1),
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
                                this.okCallBack!(numTomatoes, duration);
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

  Widget getTomatoesCount(bool isVisible) {
    List<Widget> listWidgets = [];
    for (int index = 0; index < 100; index++) {
      listWidgets.add(Text(
        '${index + 1}',
        style: TextStyle(fontSize: 20),
      ));
    }

    return Visibility(
        visible: isVisible,
        child: Container(
          height: 200,
          child: Stack(
            children: [
              Container(
                child: new ListWheelScrollView(
                  onSelectedItemChanged: (index) {
                    setState(() {
                      this.numTomatoes = index;
                    });
                  },
                  controller: tomatoesScrollController,
                  physics: FixedExtentScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemExtent: 30,
                  overAndUnderCenterOpacity: 0.2,
                  children: listWidgets,
                ),
              ),
              Align(
                alignment: Alignment(0.5, 0),
                child: new Text(
                  getI18NKey().tomato,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget getTomatoDurationCount(bool isVisible) {
    List<Widget> listWidgets = [];
    for (int index = 0; index < 100; index++) {
      listWidgets.add(Text(
        '${index + 1}',
        style: TextStyle(fontSize: 20),
      ));
    }
    return Visibility(
        visible: isVisible,
        child: Container(
            height: 200,
            child: Stack(
              children: [
                Container(
                  child: new ListWheelScrollView(
                    onSelectedItemChanged: (index) {
                      setState(() {
                        this.duration = index;
                      });
                    },
                    controller: durationScrollController,
                    physics: FixedExtentScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemExtent: 30,
                    overAndUnderCenterOpacity: 0.2,
                    children: listWidgets,
                  ),
                ),
                Align(
                  alignment: Alignment(0.5, 0),
                  child: new Text(
                    getI18NKey().mins2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            )));
  }
}

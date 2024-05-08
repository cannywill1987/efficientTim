import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

typedef OnClickFinishListener = void Function(int numTomatoes, int duration);

GlobalKey<DialogContentState> DialogContentStateGlobalKey = GlobalKey();

class SelectCustomDialogUtil {
  // static DialogContent dialogContent;

  static show(BuildContext mContext,
      {String? title,
        Widget? child,
        double? maxHeight = 300,
        bool? onlyRight = false,
        String? content,
        String? leftText,
        String? rightText,
        OnTapListener? onTapListener,
        Function? okCallBack,
        Function? cancelCallBack,
        String? okRouteUri = "",
        bool? input = false}) {
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
              okCallBack: okCallBack,
              maxHeight: maxHeight,
              child: child,
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
   OnTapListener? onTapListener;
   double? maxHeight;
  Widget? child;
  int? numTomatoes;
  int? duration;

  DialogContent(
      {Key? key,
        this.child,
        this.maxHeight,
        this.numTomatoes,
        this.duration,
        this.onTapListener,
        this.title,
        this.content,
        this.leftText,
        this.rightText,
        this.onlyRight,
        this.okCallBack,
        this.cancelCallBack,
        this.okRouteUri,
        this.input})
      : super(key: key);

  @override
  DialogContentState createState() => DialogContentState(
      onTapListener: this.onTapListener,
      title: this.title,
      content: this.content,
      leftText: this.leftText,
      rightText: this.rightText,
      onlyRight: this.onlyRight,
      child: this.child,
      maxHeight: this.maxHeight,
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
   String? okRouteUri; //右边按钮跳转路由
   bool? input; //是否展示输入框
   Widget? child;
   double? maxHeight;
  List<SheetDataModel>? list;
   OnTapListener? onTapListener;
  FixedExtentScrollController? durationScrollController =
  FixedExtentScrollController(initialItem: 0);

  DialogContentState(
      {this.onTapListener,
        this.title,
        this.child,
        this.content,
        this.maxHeight,
        this.leftText,
        this.rightText,
        this.onlyRight,
        this.list,
        this.okRouteUri,
        this.input}) {}

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
          alignment: Alignment.center,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  color: ThemeManager.getInstance().getBackgroundColor(defaultColor: Colors.white),
                  constraints:
                  BoxConstraints(maxHeight: this.maxHeight ?? 10, maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(this.widget.title ?? "",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400)),
                      SizedBox(height: 10),
                      Expanded(child: this.widget.child ?? SizedBox.shrink()),
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
                              if (this.widget.cancelCallBack != null) {
                                this.widget.cancelCallBack!();
                              }
                            },
                          ),
                          RawKeyboardListener(
                              autofocus: true,
                              onKey: (event) {
                                if (event.runtimeType == RawKeyDownEvent) {
                                  if (event.physicalKey == PhysicalKeyboardKey.enter) {
                                    this.widget?.okCallBack!(null);
                                    Navigator.of(context).pop();
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
                                            fontSize: 18, color: Colors.red))),
                                onPressed: () {
                                  this.widget?.okCallBack!(null);
                                  Navigator.of(context).pop();
                                },
                              )),
                        ],
                      )
                    ],
                  ))),
        )
      ]),
    );
  }
}

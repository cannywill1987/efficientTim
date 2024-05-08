import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

typedef OnClickFinishListener = void Function(int numTomatoes, int duration);

GlobalKey<DialogContentState> DialogContentStateGlobalKey = GlobalKey();

class SelectTomatoesDialogUtil {
  // static DialogContent dialogContent;

  static show(BuildContext mContext,
      {String? title,
      bool onlyRight = false,
      Widget? child,
      String? leftText = "",
      String? rightText = "",
      Function? okCallBack,
      Function? cancelCallBack,
      bool shouldShowBottom = false}) {
    title = title ?? getI18NKey().remind;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return DialogContent(
            key: DialogContentStateGlobalKey,
            title: title,
            leftText: leftText,
            child: child,
            rightText: rightText,
            shouldShowBottom: shouldShowBottom,
            okCallBack: okCallBack,
            cancelCallBack: cancelCallBack,
          );
          // } else {
          //   return dialogContent;
          // }
        });
  }
}

class DialogContent extends StatefulWidget {
   String? title; //标题
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   Widget? child;
  bool? shouldShowBottom;

  DialogContent({
    Key? key,
    this.title,
    this.child,
    this.shouldShowBottom,
    this.leftText,
    this.rightText,
    this.okCallBack,
    this.cancelCallBack,
  }) : super(key: key);

  @override
  DialogContentState createState() => DialogContentState(
        title: this.title,
        leftText: this.leftText,
        shouldShowBottom: this.shouldShowBottom,
        child: this.child,
        rightText: this.rightText,
        okCallBack: this.okCallBack,
        cancelCallBack: this.cancelCallBack,
      );
}

class DialogContentState extends State<DialogContent> {
  String? label = '';
   String? title; //标题
   String? leftText; //左边按钮文字
   String? rightText; //右边按钮文字
   Function? okCallBack; //右边回调
   Function? cancelCallBack; //左边回调
   OnTapListener? onTapListener;
   Widget? child;
  bool? shouldShowBottom;

  DialogContentState({
    this.onTapListener,
    this.title,
    this.child,
    this.leftText,
    this.shouldShowBottom,
    this.rightText,
    this.okCallBack,
    this.cancelCallBack,
  }) {}

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
                      color: Colors.white,
                      constraints:
                          BoxConstraints(maxHeight: 500, maxWidth: 500),
                      // color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          //todo child
                          this.child ?? SizedBox.shrink(),
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
                                this.okCallBack!();
                              }
                            },
                          ),
                        ],
                      ))))
        ]));
  }
}

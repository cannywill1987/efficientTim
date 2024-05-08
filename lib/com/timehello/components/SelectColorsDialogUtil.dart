import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../page/createFolderPage/components/ColorsGridViewWidget.dart';

typedef OnTapCreateTagListener = void Function(dynamic obj);

GlobalKey<
    DialogContentState> SelectColorsDialogUtilStateGlobalKey = GlobalKey();

/**
 * 用于选择app颜色
 */
class SelectColorsDialogUtil {
  static  show(BuildContext mContext,
      {String? title,
        bool? onlyRight = false,
        String? content = '',
        String? leftText,
        String? rightText,
        OnTapListener? onTapListener,
        Function? okCallBack,
        Function? cancelCallBack,
        String okRouteUri = "",
        bool input = false}) {
    title = title ?? getI18NKey().remind;
    leftText = leftText ?? getI18NKey().cancel;
    rightText = rightText ?? getI18NKey().confirm;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
          return DialogContent(
              key: SelectColorsDialogUtilStateGlobalKey,
              title: title,
              content: content,
              leftText: leftText,
              rightText: rightText,
              onlyRight: onlyRight,
              okCallBack: okCallBack,
              onTapListener: onTapListener,
              cancelCallBack: cancelCallBack,
              okRouteUri: okRouteUri,
              );
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
   OnTapListener? onTapListener;

  DialogContent({Key? key,
    this.onTapListener,
    this.title,
    this.content,
    this.leftText,
    this.rightText,
    this.onlyRight,
    this.okCallBack,
    this.cancelCallBack,
    this.okRouteUri,
  })
      : super(key: key);

  @override
  DialogContentState createState() =>
      DialogContentState(
        onTapListener: this.onTapListener,
        title: this.title,
        content: this.content,
        leftText: this.leftText,
        rightText: this.rightText,
        onlyRight: this.onlyRight,
        okCallBack: this.okCallBack,
        cancelCallBack: this.cancelCallBack,
        okRouteUri: this.okRouteUri,
      );
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
   OnTapListener? onTapListener;
   OnTapCreateTagListener? onTapCreateTagListener;

  DialogContentState({this.onTapCreateTagListener,
    this.onTapListener,
    this.title,
    this.content,
    this.leftText,
    this.rightText,
    this.onlyRight,
    this.okCallBack,
    this.cancelCallBack,
    this.okRouteUri,
    this.input});

  @override
  void didUpdateWidget(DialogContent oldWidget) {
  }


  @override
  void initState() {
    super.initState();
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
                  color: Colors.white,
                  constraints:
                  BoxConstraints(maxHeight: 500, maxWidth: 500),
                  // color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Text(title ?? "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Text(content ?? "",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400)),
                      SizedBox(height: 30),
                      Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ColorsGridViewWidget(onTapListener: (data) {
                            this.widget?.onTapListener!(data);
                            Navigator.of(context).pop();
                          }),
                      ),
                    ],
                  ))),
        )
      ]),
    );
  }
}

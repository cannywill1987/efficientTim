import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SheetDataModel.dart';
import 'package:time_hello/com/timehello/util/ScreenUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../util/TextUtil.dart';

class SelectDateDialogUtil {
  static show(BuildContext mContext,
      {String? title,
      bool onlyRight = false,
      String? content,
      String? leftText,
      String? rightText,
      int? initValue,
      List<SheetDataModel>? list,
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
          return SassDialog(
              title: title,
              content: content,
              leftText: leftText,
              rightText: rightText,
              initValue: initValue,
              onlyRight: onlyRight,
              okCallBack: okCallBack,
              list: list ?? [],
              onTapListener: onTapListener,
              cancelCallBack: cancelCallBack,
              okRouteUri: okRouteUri,
              input: input);
        });
  }
}

class SassDialog extends Dialog {
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
  int? initValue;

  SassDialog(
      {this.onTapListener,
      this.title,
      this.content,
      this.leftText,
      this.rightText,
      this.initValue,
      this.onlyRight,
      this.okCallBack,
      this.list,
      this.cancelCallBack,
      this.okRouteUri,
      this.input});

  getContentView(context) {
    List<Widget> list = [];
    List<SheetDataModel> listModels = this.list ?? [];
    for (int i = 0; i < listModels.length; i++) {
      SheetDataModel data = listModels[i];
      list.add(InkWell(
        onTap: () {
          // if (this.onTapListener != null) {
            Navigator.of(context).pop();
            this.onTapListener?.call(data);
          // }
        },
        child: Container(
            height: 50,
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                data.icon ?? SizedBox.shrink(),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title ?? '',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    TextUtil.isEmpty(data.desc) ? SizedBox.shrink() : Text(
                      data.desc ?? '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            )),
      ));
    }
    return Column(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      //自定义dialog布局
      child: Stack(children: [
        Align(
          alignment: Utility.isHandsetBySize()
              ? Alignment.bottomCenter
              : Alignment.center,
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 15),
              decoration: Utility.isHandsetBySize()
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(0)))
                  : BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
              constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
              // color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text(title ?? "",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  Text(content ?? "",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  Container(child: getContentView(context))
                ],
              )),
        )
      ]),
    );
  }
}
